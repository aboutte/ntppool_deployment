def acquire_eip(aws_clients)
  aws_clients[:ec2].allocate_address(domain: 'vpc')
end

def attach_eip
  node['ntppool_deployment']['chef_gems'].each do |chef_gem|
    chef_gem chef_gem do
      action :install
    end
    require chef_gem
  end

  az = node['ec2']['placement_availability_zone']
  region = az[0..-2]
  instance_id = node['ec2']['instance_id']

  aws_clients = {}
  aws_clients[:ec2] = Aws::EC2::Client.new(region: region)

  eip = node['ntppool_deployment']['eip'] ? node['ntppool_deployment']['eip'] : acquire_eip(aws_clients)

  resp = aws_clients[:ec2].associate_address({
    allocation_id: eip[:allocation_id],
    instance_id: instance_id,
  })

end
