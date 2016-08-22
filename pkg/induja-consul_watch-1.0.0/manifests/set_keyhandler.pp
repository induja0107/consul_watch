# == Class: set_keyhandler
#
# Creates a file resource that is used by the consul watch functionality for executing puppet agent run
# === Authors
#
# induja.vijayaragavan 
#
# === Copyright
#
# Copyright 2016 Induja Vijayaragavan, unless otherwise noted.
#
class set_keyhandler {

  file { '/opt/continuous_delivery/bin/my-key-handler.sh' :
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    content => "#!/bin/bash \n sudo puppet agent -t & \n",
  }
}
