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

if edge_couch?
  include_recipe "erlang"
  
  %w{ libc6 libicu-dev libtool libmozjs-dev libcurl4-gnutls-dev 
      mime-support subversion automake autoconf help2man}.each { |p| package p }
  
  subversion "CouchDB Edge" do
    repository "http://svn.apache.org/repos/asf/couchdb/trunk"
    revision couchdb[:revision]
    destination couchdb[:src_dir]
    action :sync
  end
  
  execute "bootstrap couchdb source" do
    command "./bootstrap"
    cwd "/opt/couchdb-src"
  end
  
  execute "configure couchdb" do
    command "./configure --prefix=/usr --sysconfdir=/etc"
    cwd "/opt/couchdb-src"
  end
  
  execute "make couchdb" do
    command "make"
    cwd "/opt/couchdb-src"
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
