# == Class: consul_watch
#
# Sets up consul watch to look for any changes in artifact_url and trigger puppet agent run 
# Creates file and service resources for the consul watch
# === Variables
#
# deploy_path is a custom fact that is used by Puppet to decide on the Applications deployment path 
# Pass this parameter from your class to reflect the right key in consul to watch for.
# opt continuous delivery bin is the folder structure that will be used for placing all the Continuous Delivery shell scripts and other executables
# === Authors
#
# induja.vijayaragavan 
#
# === Copyright
#
# Copyright 2016 Induja Vijayaragavan, unless otherwise noted.
#
#class consul_watch(String $war_url) {

  notice("\$war_url comes back as  ${war_url}")
  
  file { '/opt/continuous_delivery' :
    ensure => 'directory',
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
  }

  file { '/opt/continuous_delivery/bin' :
    ensure => 'directory',
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
  }

  file { '/opt/continuous_delivery/bin/my-key-handler.sh' :
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    content => "#!/bin/bash \n sudo puppet agent -t & \n",
  }

  # Create a shell script for consul watch based on the changes to artifact_url key and invoke my-key-handler shell script  
  file { '/opt/continuous_delivery/bin/consulwatch.sh':
    notify  => Service['consulwatch'],
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    content => "#!/bin/bash \n sudo consul watch -type key -key ${war_url} /opt/continuous_delivery/bin/my-key-handler.sh & \n",
  }
  # Create a custom user defined service called consulwatch that runs in the agents in the background and invokes consulwatch shell script
  service { 'consulwatch':
    ensure     => 'running',
    provider   => 'base',
    start      => '/opt/continuous_delivery/bin/consulwatch.sh',
    pattern    => 'consul watch',
    hasstatus  => true,
    hasrestart => true,
  }
#}
