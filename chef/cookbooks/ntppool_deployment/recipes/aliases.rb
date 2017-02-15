#
# Cookbook Name:: ntppool_deployment
# Recipe:: aliases
#
# Copyright (C) 2017 Andy Boutte
#
# All rights reserved - Do Not Redistribute
#

magic_shell_alias 'mon' do
  command 'ntpq -p'
end

magic_shell_alias 'cap' do
  command 'tshark -te -ni any -R \'ntp\''
end
