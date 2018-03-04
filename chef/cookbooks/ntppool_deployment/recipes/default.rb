#
# Cookbook Name:: ntppool_deployment
# Recipe:: default
#
# Copyright (C) 2017 Andy Boutte
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'ntppool_deployment::aliases'

hostname node['cloud']['hostname']

file '/var/lib/ntp/sntp-kod' do
  mode '0755'
  owner 'ntp'
  group 'ntp'
end

include_recipe 'ntp'

# This function will use the EIP passed into chef at node['ntppool_deployment']['eip']
# else it will acquire an EIP
attach_eip unless node['cloud']['disable_eip_acquisition']
