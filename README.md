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

This module creates a service for consul watch and triggers a puppet agent run if the key changes.

## Setup

### What consul_watch affects **OPTIONAL**

This executes a puppet agent run if the key in consul that you look for changes.
This depends on consul so it it a pre-requisite that you have consul already installed on the node that you are testing this.
This also depends on puppet agent being set up and is up and running.
Consul should be set up with key value pairs for setting up the consul watch.

### Setup Requirements **OPTIONAL**

Setup Consul
Setup Puppet agent
Setup artifact_url key in consul 


### Beginning with consul_watch

Steps: 
1) Create a file resource for directory, /opt/continuous_delivery/bin
2) Enter a value in artifact_url. 
3) Do a sudo tail -f /var/log/messages to monitor the puppet agent run information.
4) Edit the artifact_url to point to a different URL. Now the log should show that the consul watch triggered a puppet agent run.

## Usage

You can customize the lookup for consul key based on how you've set yours up.

## Reference

## Limitations

None.

## Development

Open to refactoring. Send in your PR and I shall get that added should that add more value to the module.

## Release Notes/Contributors/Etc. **Optional**

# consul_watch
