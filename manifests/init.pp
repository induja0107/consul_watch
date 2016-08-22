# Class: consul_watch
# ===========================
#
# Full description of class consul_watch here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'consul_watch':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Author Name <author@domain.com>
#
# Copyright
# ---------
#
# Copyright 2016 Your name here, unless otherwise noted.
#
class consul_watch {
  # Get the facter value of deploy path 
  # Append artifact url so that we get the complete path for the key
  $path = join(["application/",$facts['deploy_path']])
  $war_url = join([$path,"/artifact_url"])

  notice("\$war_url comes back as  ${war_url}")
  
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
}
