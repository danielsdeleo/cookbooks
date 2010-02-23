maintainer        "Dan DeLeo"
maintainer_email  "dan@opscode.com"
license           "Proprietary, DO NOT DISTRIBUTE OUTSIDE OPSCODE BITCHES"
description       "guaranteed epic failure, that is all"
version           "0.1"

%w{ centos redhat fedora ubuntu debian }.each do |os|
  supports os
end
