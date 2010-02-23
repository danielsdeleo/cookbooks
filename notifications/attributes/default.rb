# THIS COOKBOOK NEEDS THE FOLLOWING ATTRIBUTES WHICH HAVE NO SANE DEFAULTS:

# set_unless[:notifications][:couchdb_notification_url] = "a_couchdb_your_node_can_access"
# set_unless[:notifications][:notification_database]    = "the_db_to_store_exceptions_in"
# 
# set_unless[:notifications][:s3_bucket]                = "the_S3_bucket_where_your_log_files_go"
# set_unless[:notifications][:s3_access_key]            = "your_20ish_char_access_key_id"
# set_unless[:notifications][:s3_secret_key]            = "your_S3_secret_key" # not a X.509 cert, fyi
