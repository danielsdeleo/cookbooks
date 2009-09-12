#
# Cookbook Name:: couchdb
# Attributes:: couchdb
#
# Copyright 2009, Opscode, Inc.
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

couchdb Mash.new unless attribute?("couchdb")
couchdb[:edge] = "false" unless couchdb[:edge]
couchdb[:src_dir] = Chef::Config[:file_cache_path] + "/source/couchdb" unless couchdb.has_key?(:src_dir)
couchdb[:revision] = "HEAD" unless couchdb.has_key?(:revision)
couchdb[:configure_prefix] = "/usr/local" unless couchdb.has_key?(:configure_prefix)