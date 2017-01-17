
default['cms-rean']['yum_packages'] = ['lynx', 'htop', 'sysstat']

normal['wordpress']['version'] = 'latest'
normal['wordpress']['dir'] = '/var/www/wordpress/'
# The php cookbook default for node['php']['mysql']['package'] is 'php53-mysql' while node['php']['version'] is '5.6.13'
# This causes a conflict with the php common package.
normal['php']['mysql']['package'] = 'php56-mysqlnd'
# Generate random database prefix to help prevent attacker knowing names of common wordpress tables
normal['wordpress']['db']['prefix'] = ('a'..'z').to_a.shuffle[0,5].join
normal['wordpress']['db']['name'] = 'wordpress'
normal['wordpress']['db']['user'] = 'wordpress'
normal['wordpress']['db']['root_password'] = node['cloud']['mysql']['root_user_password']
normal['wordpress']['db']['pass'] = node['cloud']['mysql']['cms_user_password']
normal['wordpress']['server_name'] = node['cloud']['hostname']
normal['wordpress']['server_aliases'] = ["www.#{node['cloud']['hostname']}"]
