#
# Cookbook Name:: notifications
# Attributes:: default
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

# THIS COOKBOOK NEEDS THE FOLLOWING ATTRIBUTES WHICH HAVE NO SANE DEFAULTS:

# set_unless[:notifications][:couchdb_notification_url] = "a_couchdb_your_node_can_access"
# set_unless[:notifications][:notification_database]    = "the_db_to_store_exceptions_in"
# 
# set_unless[:notifications][:s3_bucket]                = "the_S3_bucket_where_your_log_files_go"
# set_unless[:notifications][:s3_access_key]            = "your_20ish_char_access_key_id"
# set_unless[:notifications][:s3_secret_key]            = "your_S3_secret_key" # not a X.509 cert, fyi
