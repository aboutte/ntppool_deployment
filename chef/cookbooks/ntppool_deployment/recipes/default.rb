#
# Cookbook Name:: ntppool_deployment
# Recipe:: default
#
# Copyright (C) 2017 Andy Boutte
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'aliases'

hostname node['cloud']['hostname']

node['ntppool_deployment']['rpms'].each do |rpm|
  package rpm do
    retries 2
    retry_delay 10
    action :install
  end
end

file '/var/lib/ntp/sntp-kod' do
  mode '0755'
  owner 'ntp'
  group 'ntp'
end

include_recipe 'ntp'

# This function will use the EIP passed into chef at node['ntppool_deployment']['eip']
# else it will aquire an EIP
attach_eip
