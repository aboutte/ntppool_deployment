def acquire_eip(aws_clients)
  aws_clients[:ec2].allocate_address(domain: 'vpc').public_ip
end

def attach_eip
  node['ntppool_deployment']['chef_gems'].each do |chef_gem|
    chef_gem chef_gem do
      action :install
    end
    require chef_gem
  end
  require 'resolv'

  aws_clients = {}
  aws_clients[:ec2] = Aws::EC2::Client.new(region: node['ec2']['placement_availability_zone'][0..-2])

  case node['cloud']['eip']
  when Resolv::IPv4::Regex
    puts 'Its a valid IPv4 address.'
    eip = node['cloud']['eip']
  when Resolv::IPv6::Regex
    puts 'Its a valid IPv6 address.'
    puts 'but IPv6 is not supported yet.'
    abort
  else
    puts 'Its not a valid IP address.'
    puts 'Aquaring an IP'
    eip = acquire_eip(aws_clients)
  end

  aws_clients[:ec2].associate_address(instance_id: node['ec2']['instance_id'],
                                      public_ip: eip,
                                      private_ip_address: node['ipaddress'],
                                      allow_reassociation: true)
end
