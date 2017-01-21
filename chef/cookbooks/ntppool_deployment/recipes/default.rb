#
# Cookbook Name:: ntppool_deployment
# Recipe:: default
#
# Copyright (C) 2017 Andy Boutte
#
# All rights reserved - Do Not Redistribute
#

# Update /etc/hosts
hostname node['cloud']['hostname']

# This function will use the EIP passed into chef at node['ntppool_deployment']['eip']
# else it will aquire an EIP
attach_eip

include_recipe 'ntp'
