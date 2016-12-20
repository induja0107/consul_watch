# consul_watch

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with consul_watch](#setup)
    * [What consul_watch affects](#what-consul_watch-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with consul_watch](#beginning-with-consul_watch)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

This module creates a service for consul watch and triggers a puppet agent run if the key changes. This has been tested with rspec-puppet tests and is a working solution. 
This module will come in handy if you have Jenkins pipeline writing to the consul, puppet agent nodes doesn't have to wait for 30 minutes for identifying that the consul key for the deployment piece has changed. Since the consul watch is set up, the moment the artifact war location changes in consul, it kicks off a puppet agent run in the node in which the watch service is running and your app gets deployed instantly. This enables faster turn over of App deployment and testing for the developers.

## Setup

This sets up a service that runs in the background called consul_watch. 

### What consul_watch affects 

This executes a puppet agent run if the key in consul that you look for changes.
This depends on consul so it it a pre-requisite that you have consul already installed on the node that you are testing this.
This also depends on puppet agent being set up and is up and running.
Consul should be set up with key value pairs for setting up the consul watch.

### Setup Requirements 

Setup Consul
Setup Puppet agent
Setup artifact_url key in consul 
Pass appropriate parameters for $war_url, $admin_path, $admin_bin_path otherwise the defaults will apply. See module manifests for comments on how to set them.

### Beginning with consul_watch

Steps: 

     1) Create a file resource for directory, /opt/continuous_delivery/bin
     2) Enter a value in artifact_url. 
     3) Do a sudo tail -f /var/log/messages to monitor the puppet agent run information.
     4) Edit the artifact_url to point to a different URL. Now the log should show that the consul watch triggered a puppet agent run.

Note: deploy_path in the class denotes the path to the App in Consul - example: ESC/ContinuousDeployment/ESC-ContinuousDeployment-trunk/web

## Usage

    class { 'consul_watch' :
      war_url        => 'ESC/Continuous-Deployment/ESC-ContinuousDeployment/web/artifact_url',
      admin_path     => '/opt/continuous_delivery',
      admin_bin_path => '/opt/continuous_delivery/bin',
    }

You can customize the lookup for consul key based on how you've set yours up.

## Reference
https://www.consul.io/docs/commands/watch.html 

## Limitations

Tested on Centos 6,7 and RHEL 6 & 7 nodes.

## Development

Open to refactoring. Send in your PR and I shall get that added should that add more value to the module.

## Release Notes/Contributors/Etc. 
