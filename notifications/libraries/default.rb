#
# Author:: Daniel DeLeo <dan@opscode.com>
#
# Cookbook Name:: notifications
# Recipe:: default
#
# Copyright 2010, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'aws/s3'



# EVIL MONKEY PATCH EXCEPTION TO CONVERT ITSELF TO A HASH
# ...so we can later JSONize it.
class Exception
  def to_hsh(base_attrs={})
    base_attrs.merge({:message => message, :name => self.class.name, :backtrace => backtrace})
  end
end

# EVIL MONKEY PATCH Chef::Log TO ALSO LOG TO A StringIO-based 
# logger at debug level. This lets us extract the logs later and send 
# them to S3
class ::Chef
  class Log
    class << self

      def reset_memory_log
        @memory_log, @memory_log_stringio = nil, nil
      end

      def memory_log
        @memory_log ||= begin 
                          logr = Logger.new(memory_log_stringio)
                          logr.level = Logger::DEBUG
                          logr
                        end
      end

      def memory_log_stringio
        @memory_log_stringio ||= StringIO.new
      end

      def method_missing(method_symbol, *args)
        memory_log.send(method_symbol, *args)
        logger.send(method_symbol, *args)
      end
 
    end

  end
end

# Start with a clean log for each chef run.
Chef::Log.reset_memory_log

# Don't define the at_exit hook multiple times, once is great kthxbi
unless defined?(Chef::AT_EXIT_HOOK_INSERTED) && Chef::AT_EXIT_HOOK_INSERTED
  at_exit do
    last_exception = $!
    
    # No easy way to grab the node object in the at_exit hook :(
    node = $HACKY_WAY_TO_PASS_NODE_TO_EXIT_HOOK

    couchdb_notification_url = node[:notifications][:couchdb_notification_url]
    couchdb_notification_db  = node[:notifications][:notification_database]
    
    s3_logs_bucket = node[:notifications][:s3_bucket]
    s3_config = {
      :access_key_id      =>  node[:notifications][:s3_access_key],
      :secret_access_key  =>  node[:notifications][:s3_secret_key]
    }
    unless last_exception.kind_of?(SystemExit) && last_exception.success?
      timestamp = Time.now
      Chef::Log.info("Uploading logs to S3")
      Chef::Log.info("S3 bucket: #{s3_logs_bucket}")
      s3_object_id = "#{node.name}-#{timestamp.to_i.to_s}.debug.log"
      Chef::Log.info("S3 object id: #{s3_object_id}")


      AWS::S3::Base.establish_connection!(s3_config)
      AWS::S3::Bucket.find(s3_logs_bucket) rescue AWS::S3::Bucket.create(s3_logs_bucket)
      AWS::S3::S3Object.store(s3_object_id, Chef::Log.memory_log_stringio.string, s3_logs_bucket)
      obj_s3_url = AWS::S3::S3Object.url_for(s3_object_id, s3_logs_bucket, :expires_in => (60 * 60 * 24 * 14))
      Chef::Log.info("S3 URL for object (valid for 2 weeks): #{obj_s3_url}")

      AWS::S3::Base.disconnect


      Chef::Log.info("Forwarding exception data from failed run")
      Chef::Log.info("Exception: #{last_exception.inspect}")
      rest = Chef::REST.new(couchdb_notification_url, nil, nil)
      id   = UUIDTools::UUID.random_create.to_s
      metadata = {:node => node.name, :time => timestamp, :s3_bucket => s3_logs_bucket, :s3_object_id => s3_object_id, :s3_url => obj_s3_url}
      Chef::Log.info("Exception metadata: #{metadata.inspect}")
      rest.put_rest("#{couchdb_notification_db}/#{id}", last_exception.to_hsh(metadata))
    end
  end
end

# Set a global flag that to say we inserted the at exit hook
class Chef
  AT_EXIT_HOOK_INSERTED = true
end
