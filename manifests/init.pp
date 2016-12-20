# == Class: consul_watch
#
# Sets up consul watch to look for any changes in artifact_url and trigger puppet agent run 
# Creates file and service resources for the consul watch
# === Parameters
# $war_url= which war file to look for to trigger puppet agent run. Default - 'ESC/Continuous-Deployment/ESC-ContinuousDeployment/web/artifact_url'
# $admin_path = The path for continuous delivery. Default - '/opt/continuous_delivery'
# $admin_bin_path = Path for executing shell commands. Default - '/opt/continuous_delivery/bin'
#
# === Variables
#
# deploy_path is a custom fact that is used by Puppet to decide on the Applications deployment path 
# Pass this parameter from your class to reflect the right key in consul to watch for.
# opt continuous delivery bin is the folder structure for placing all the Continuous Delivery shell scripts and other executables
# === Authors
#
# induja.vijayaragavan 
#
# === Copyright
#
# Copyright 2016 Induja Vijayaragavan, unless otherwise noted.
#
class consul_watch(
  String $war_url='ESC/Continuous-Deployment/ESC-ContinuousDeployment/web/artifact_url',
  String $admin_path='/opt/continuous_delivery',
  String $admin_bin_path='/opt/continuous_delivery/bin') {

  file { $admin_path :
    ensure => 'directory',
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
  }

  file {$admin_bin_path :
    ensure => 'directory',
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
  }

  # Trigger puppet agent run when the $war_url changes so we get the latest war deployed without having to wait half an hour.
  file { "${admin_bin_path}/my-key-handler.sh" :
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    content => "#!/bin/bash \n sudo puppet agent -t & \n",
  }

  # Create a shell script for consul watch based on the changes to artifact_url key and invoke my-key-handler shell script  
  file { "${admin_bin_path}/consulwatch.sh":
    notify  => Service['consulwatch'],
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    content => "#!/bin/bash \n sudo consul watch -type key -key ${war_url} ${admin_bin_path}/my-key-handler.sh & \n",
  }
  # Create a custom user defined service called consulwatch that runs in the agents in the background and invokes consulwatch shell script
  service { 'consulwatch':
    ensure     => 'running',
    provider   => 'base',
    start      => "${admin_bin_path}/consulwatch.sh",
    pattern    => 'consul watch',
    hasstatus  => true,
    hasrestart => true,
  }
}
