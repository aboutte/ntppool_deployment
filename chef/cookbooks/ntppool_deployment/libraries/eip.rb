def init
  node['ntppool_deployment']['chef_gems'].each do |chef_gem|
    chef_gem chef_gem do
      action :install
    end
    require chef_gem
  end
  require 'resolv'
end

def acquire_eip(aws_clients)
  aws_clients[:ec2].allocate_address(domain: 'vpc').public_ip
end

def attach_eip
  init
  ec2 = Aws::EC2::Client.new(region: node['ec2']['placement_availability_zone'][0..-2])

  case node['cloud']['eip']
  when Resolv::IPv4::Regex
    eip = node['cloud']['eip']
  when Resolv::IPv6::Regex
    abort
  else
    puts 'Aquaring an IP'
    eip = acquire_eip(ec2)
  end

  ec2.associate_address(instance_id: node['ec2']['instance_id'],
                        public_ip: eip,
                        private_ip_address: node['ipaddress'],
                        allow_reassociation: true)
end
