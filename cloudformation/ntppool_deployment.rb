#!/usr/bin/env ruby

require './lib/preload.rb'

template do
  load_from_file('./lib/autoloader.rb')
  value AWSTemplateFormatVersion: '2010-09-09'
  value Description: 'AWS CloudFormation to deploy a NTP Pool Server'
  load_from_file('./parameters.rb')

  tag :Name, Value: 'ntpd'
  tag :application, Value: 'ntpd'
  tag :environment, Value: parameters['Environment']
  tag :launched_by, Value: ENV['USER']

  resource 'VPC', Type: 'AWS::EC2::VPC', Properties: {
    CidrBlock: '10.0.0.0/16',
    EnableDnsSupport: 'true',
    EnableDnsHostnames: 'true'
  }

  resource 'PublicSubneta', Type: 'AWS::EC2::Subnet', Properties: {
    VpcId: ref('VPC'),
    AvailabilityZone: "#{aws_region}a",
    CidrBlock: '10.0.0.0/24'
  }

  resource 'PublicSubnetb', Type: 'AWS::EC2::Subnet', Properties: {
    VpcId: ref('VPC'),
    AvailabilityZone: "#{aws_region}b",
    CidrBlock: '10.0.1.0/24'
  }

  resource 'PublicSubnetc', Type: 'AWS::EC2::Subnet', Properties: {
    VpcId: ref('VPC'),
    AvailabilityZone: "#{aws_region}c",
    CidrBlock: '10.0.2.0/24'
  }

  resource 'InternetGateway', Type: 'AWS::EC2::InternetGateway'

  resource 'GatewayToInternet', Type: 'AWS::EC2::VPCGatewayAttachment', Properties: {
    VpcId: ref('VPC'),
    InternetGatewayId: ref('InternetGateway')
  }

  resource 'PublicRouteTable', Type: 'AWS::EC2::RouteTable', Properties: {
    VpcId: ref('VPC')
  }

  resource 'PublicRoute', Type: 'AWS::EC2::Route', DependsOn: 'GatewayToInternet', Properties: {
    RouteTableId: ref('PublicRouteTable'),
    DestinationCidrBlock: '0.0.0.0/0',
    GatewayId: ref('InternetGateway')
  }

  resource 'PublicSubnetaRouteTableAssociation', Type: 'AWS::EC2::SubnetRouteTableAssociation', Properties: {
    SubnetId: ref('PublicSubneta'),
    RouteTableId: ref('PublicRouteTable')
  }

  resource 'PublicSubnetbRouteTableAssociation', Type: 'AWS::EC2::SubnetRouteTableAssociation', Properties: {
    SubnetId: ref('PublicSubnetb'),
    RouteTableId: ref('PublicRouteTable')
  }

  resource 'PublicSubnetcRouteTableAssociation', Type: 'AWS::EC2::SubnetRouteTableAssociation', Properties: {
    SubnetId: ref('PublicSubnetc'),
    RouteTableId: ref('PublicRouteTable')
  }

  resource 'PublicNetworkAcl', Type: 'AWS::EC2::NetworkAcl', Properties: {
    VpcId: ref('VPC')
  }

  resource 'InboundNTPPublicNetworkAclEntry', Type: 'AWS::EC2::NetworkAclEntry', Properties: {
    NetworkAclId: ref('PublicNetworkAcl'),
    RuleNumber: '100',
    Protocol: '17',
    RuleAction: 'allow',
    Egress: 'false',
    CidrBlock: '0.0.0.0/0',
    PortRange: { From: '123', To: '123' }
  }

  resource 'InboundDynamicPortPublicNetworkAclEntry', Type: 'AWS::EC2::NetworkAclEntry', Properties: {
    NetworkAclId: ref('PublicNetworkAcl'),
    RuleNumber: '101',
    Protocol: '6',
    RuleAction: 'allow',
    Egress: 'false',
    CidrBlock: '0.0.0.0/0',
    PortRange: { From: '1024', To: '65535' }
  }

  resource 'Outbound80PublicNetworkAclEntry', Type: 'AWS::EC2::NetworkAclEntry', Properties: {
    NetworkAclId: ref('PublicNetworkAcl'),
    RuleNumber: '200',
    Protocol: '6',
    RuleAction: 'allow',
    Egress: 'true',
    CidrBlock: '0.0.0.0/0',
    PortRange: { From: '80', To: '80' }
  }

  resource 'Outbound443PublicNetworkAclEntry', Type: 'AWS::EC2::NetworkAclEntry', Properties: {
    NetworkAclId: ref('PublicNetworkAcl'),
    RuleNumber: '201',
    Protocol: '6',
    RuleAction: 'allow',
    Egress: 'true',
    CidrBlock: '0.0.0.0/0',
    PortRange: { From: '443', To: '443' }
  }

  resource 'Outbound123PublicNetworkAclEntry', Type: 'AWS::EC2::NetworkAclEntry', Properties: {
    NetworkAclId: ref('PublicNetworkAcl'),
    RuleNumber: '202',
    Protocol: '17',
    RuleAction: 'allow',
    Egress: 'true',
    CidrBlock: '0.0.0.0/0',
    PortRange: { From: '123', To: '123' }
  }

  resource 'OutboundDynamicPortPublicNetworkAclEntry', Type: 'AWS::EC2::NetworkAclEntry', Properties: {
    NetworkAclId: ref('PublicNetworkAcl'),
    RuleNumber: '203',
    Protocol: '6',
    RuleAction: 'allow',
    Egress: 'false',
    CidrBlock: '0.0.0.0/0',
    PortRange: { From: '1024', To: '65535' }
  }

  resource 'PublicSubnetaNetworkAclAssociation', Type: 'AWS::EC2::SubnetNetworkAclAssociation', Properties: {
    SubnetId: ref('PublicSubneta'),
    NetworkAclId: ref('PublicNetworkAcl')
  }

  resource 'PublicSubnetbNetworkAclAssociation', Type: 'AWS::EC2::SubnetNetworkAclAssociation', Properties: {
    SubnetId: ref('PublicSubnetb'),
    NetworkAclId: ref('PublicNetworkAcl')
  }

  resource 'PublicSubnetcNetworkAclAssociation', Type: 'AWS::EC2::SubnetNetworkAclAssociation', Properties: {
    SubnetId: ref('PublicSubnetc'),
    NetworkAclId: ref('PublicNetworkAcl')
  }

  resource 'IAMRole', Type: 'AWS::IAM::Role', Properties: {
    AssumeRolePolicyDocument: {
      Version: '2012-10-17',
      Statement: [
        {
          Effect: 'Allow',
          Principal: { Service: ['ec2.amazonaws.com'] },
          Action: ['sts:AssumeRole']
        }
      ]
    },
    Path: '/'
  }

  resource 'IAMInstanceProfile', Type: 'AWS::IAM::InstanceProfile', Properties: {
    Path: '/',
    Roles: [ref('IAMRole')]
  }

  resource 'ntpdasg', Type: 'AWS::AutoScaling::AutoScalingGroup', Properties: {
    VPCZoneIdentifier: [ref('PublicSubneta'), ref('PublicSubnetb'), ref('PublicSubnetc')],
    LaunchConfigurationName: ref('ntpdlc'),
    MinSize: '1',
    MaxSize: '1',
    DesiredCapacity: '1'
  }

  resource 'ntpdlc', Type: 'AWS::AutoScaling::LaunchConfiguration', Properties: {
    ImageId: amazon_linux_ami_id,
    AssociatePublicIpAddress: true,
    IamInstanceProfile: ref('IAMInstanceProfile'),
    SecurityGroups: [ref('ntpdsg')],
    InstanceType: ref('InstanceType'),
    KeyName: ref('KeyName'),
    UserData: base64(interpolate(assemble_userdata))
  }

  resource 'ntpdsg', Type: 'AWS::EC2::SecurityGroup', Properties: {
    GroupDescription: 'EC2 security group',
    VpcId: ref('VPC'),
    SecurityGroupIngress: [
      { IpProtocol: 'udp', FromPort: '123', ToPort: '123', CidrIp: '0.0.0.0/0' },
      { IpProtocol: 'tcp', FromPort: '22', ToPort: '22', CidrIp: "#{public_ip}/32" }
    ],
    SecurityGroupEgress: [
      { IpProtocol: 'udp', FromPort: '123', ToPort: '123', CidrIp: '0.0.0.0/0' },
      { IpProtocol: 'udp', FromPort: '53', ToPort: '53', CidrIp: '0.0.0.0/0' },
      { IpProtocol: 'tcp', FromPort: '80', ToPort: '80', CidrIp: '0.0.0.0/0' },
      { IpProtocol: 'tcp', FromPort: '443', ToPort: '443', CidrIp: '0.0.0.0/0' }
    ]
  }

  resource 'WaitHandle', Type: 'AWS::CloudFormation::WaitConditionHandle'

  resource 'WaitCondition', Type: 'AWS::CloudFormation::WaitCondition', DependsOn: 'ntpdasg', Properties: {
    Handle: ref('WaitHandle'),
    Timeout: '600',
    Count: 1
  }
end.exec!
