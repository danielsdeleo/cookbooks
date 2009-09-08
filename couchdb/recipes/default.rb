#
# Author:: Joshua Timberman <joshua@opscode.com>
# Cookbook Name:: couchdb
# Recipe:: default
#
# Copyright 2008, OpsCode, Inc
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

if edge?
  include_recipe "erlang"
  
  %w{libc6 libicu-dev libtool libmozjs-dev libcurl4-gnutls-dev mime-support subversion}.each { |p| package p }
  
  # group "couchdb"
  # 
  # user "couchdb" do
  #   comment "CouchDB Administrator"
  #   gid "couchdb"
  #   home "/var/lib/couchdb"
  #   shell "/bin/bash"
  # end
  
  subversion "CouchDB Edge" do
    repository "http://svn.apache.org/repos/asf/couchdb/trunk"
    revision "HEAD"
    destination "/opt/couchdb-src"
    #user "couchdb"
    action :sync
  end
  
  execute "configure couchdb" do
    command "./configure"
    cwd "/opt/couchdb-src"
    user "couchdb"
    group "couchdb"
  end
  
  execute "make couchdb" do
    command "make"
    cwd "/opt/couchdb-src"
    user "couchdb"
    group "couchdb"
  end
  
  execute "make couchdb" do
    command "make install"
    cwd "/opt/couchdb-src"
  end
  
else
  package "couchdb"
end

directory "/var/lib/couchdb" do
  owner "couchdb"
  group "couchdb"
  recursive true
end

service "couchdb" do
  if platform?("centos","redhat","fedora")
    start_command "/sbin/service couchdb start &> /dev/null"
    stop_command "/sbin/service couchdb stop &> /dev/null"
  end
  supports [ :restart, :status ]
  action [ :enable, :start ]
end
