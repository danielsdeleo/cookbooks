maintainer        "Dan DeLeo"
maintainer_email  "dan@opscode.com"
license           "Proprietary, DO NOT DISTRIBUTE OUTSIDE OPSCODE BITCHES"
description       "Sets an at exit hook which forwards exceptions to a cloudant DB"
version           "0.1"

%w{ centos redhat fedora ubuntu debian }.each do |os|
  supports os
end
