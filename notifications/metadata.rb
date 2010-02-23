maintainer        "Dan DeLeo"
maintainer_email  "dan@opscode.com"
license           "Apache 2.0"
description       "Sets an at_exit hook which forwards exceptions to CouchDB and S3"
version           "0.1"

%w{ centos redhat fedora ubuntu debian }.each do |os|
  supports os
end
