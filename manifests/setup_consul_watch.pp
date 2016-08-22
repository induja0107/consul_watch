# == Class: consul_watch
#
# Sets up consul watch to look for any changes in artifact_url and trigger puppet agent run 
# Creates file and service resources for the consul watch
# === Variables
#
# deploy_path is a custom fact that is used by Puppet to decide on the Applications deployment path
# opt continuous_delivery bin is the folder structure that will be used for placing all the shell scripts and other executables
# === Authors
#
# induja 
#
# === Copyright
#
# Copyright 2016 Induja Vijayaragavan, unless otherwise noted.
#
class setup_consul_watch{

  # Get the facter value of deploy path 
  # Append artifact url so that we get the complete path for the key
  $path = join(["application/",$facts['deploy_path']])
  $war_url = join([$path,"/artifact_url"])

  notice("\$war_url comes back as  ${war_url}")

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
}

