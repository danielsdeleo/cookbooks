maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs subversion"
version           "0.7"

depends "apache2::mod_dav_svn"

recipe "subversion::default", "Subversion Client"
recipe "subversion::server", "Subversion Server (Apache2 mod_dav_svn)"