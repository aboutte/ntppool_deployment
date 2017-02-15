#!/usr/bin/env ruby

require 'bundler/setup'
require 'cloudformation-ruby-dsl/cfntemplate'
require 'cloudformation-ruby-dsl/spotprice'
require 'cloudformation-ruby-dsl/table'

template do

  value :AWSTemplateFormatVersion => '2010-09-09'

  value :Description => 'AWS CloudFormation Sample Template VPC_AutoScaling_With_Public_IPs.template: Sample template showing how to create a load balanced, auto scaled group in a VPC where the EC2 instances can directly access the internet. **WARNING** This template creates Elastic Load Balancers and Amazon EC2 instances. You will be billed for the AWS resources used if you create a stack from this template.'

  parameter 'KeyName',
            :Description => 'Name of an existing EC2 KeyPair to enable SSH access to the instances',
            :Type => 'AWS::EC2::KeyPair::KeyName',
            :ConstraintDescription => 'must be the name of an existing EC2 KeyPair.'

  parameter 'SSHLocation',
            :Description => 'Lockdown SSH access to the bastion host (default can be accessed from anywhere)',
            :Type => 'String',
            :MinLength => '9',
            :MaxLength => '18',
            :Default => '0.0.0.0/0',
            :AllowedPattern => '(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})/(\\d{1,2})',
            :ConstraintDescription => 'must be a valid CIDR range of the form x.x.x.x/x.'

  parameter 'WebServerInstanceType',
            :Description => 'WebServer Server EC2 instance type',
            :Type => 'String',
            :Default => 't2.small',
            :AllowedValues => %w(t1.micro t2.nano t2.micro t2.small t2.medium t2.large m1.small m1.medium m1.large m1.xlarge m2.xlarge m2.2xlarge m2.4xlarge m3.medium m3.large m3.xlarge m3.2xlarge m4.large m4.xlarge m4.2xlarge m4.4xlarge m4.10xlarge c1.medium c1.xlarge c3.large c3.xlarge c3.2xlarge c3.4xlarge c3.8xlarge c4.large c4.xlarge c4.2xlarge c4.4xlarge c4.8xlarge g2.2xlarge g2.8xlarge r3.large r3.xlarge r3.2xlarge r3.4xlarge r3.8xlarge i2.xlarge i2.2xlarge i2.4xlarge i2.8xlarge d2.xlarge d2.2xlarge d2.4xlarge d2.8xlarge hi1.4xlarge hs1.8xlarge cr1.8xlarge cc2.8xlarge cg1.4xlarge),
            :ConstraintDescription => 'must be a valid EC2 instance type.'

  parameter 'WebServerCount',
            :Description => 'Number of EC2 instances to launch for the WebServer server',
            :Type => 'Number',
            :Default => '1'

  mapping 'SubnetConfig',
          :VPC => { :CIDR => '10.0.0.0/16' },
          :Public => { :CIDR => '10.0.0.0/24' }

  mapping 'Region2Examples',
          :'us-east-1' => { :Examples => 'https://s3.amazonaws.com/cloudformation-examples-us-east-1' },
          :'us-west-2' => { :Examples => 'https://s3-us-west-2.amazonaws.com/cloudformation-examples-us-west-2' },
          :'us-west-1' => { :Examples => 'https://s3-us-west-1.amazonaws.com/cloudformation-examples-us-west-1' },
          :'eu-west-1' => { :Examples => 'https://s3-eu-west-1.amazonaws.com/cloudformation-examples-eu-west-1' },
          :'eu-west-2' => { :Examples => 'https://s3-eu-west-2.amazonaws.com/cloudformation-examples-eu-west-2' },
          :'eu-central-1' => { :Examples => 'https://s3-eu-central-1.amazonaws.com/cloudformation-examples-eu-central-1' },
          :'ap-southeast-1' => { :Examples => 'https://s3-ap-southeast-1.amazonaws.com/cloudformation-examples-ap-southeast-1' },
          :'ap-northeast-1' => { :Examples => 'https://s3-ap-northeast-1.amazonaws.com/cloudformation-examples-ap-northeast-1' },
          :'ap-northeast-2' => { :Examples => 'https://s3-ap-northeast-2.amazonaws.com/cloudformation-examples-ap-northeast-2' },
          :'ap-southeast-2' => { :Examples => 'https://s3-ap-southeast-2.amazonaws.com/cloudformation-examples-ap-southeast-2' },
          :'ap-south-1' => { :Examples => 'https://s3-ap-south-1.amazonaws.com/cloudformation-examples-ap-south-1' },
          :'us-east-2' => { :Examples => 'https://s3-us-east-2.amazonaws.com/cloudformation-examples-us-east-2' },
          :'ca-central-1' => { :Examples => 'https://s3-ca-central-1.amazonaws.com/cloudformation-examples-ca-central-1' },
          :'sa-east-1' => { :Examples => 'https://s3-sa-east-1.amazonaws.com/cloudformation-examples-sa-east-1' },
          :'cn-north-1' => { :Examples => 'https://s3.cn-north-1.amazonaws.com.cn/cloudformation-examples-cn-north-1' }

  mapping 'AWSInstanceType2Arch',
          :'t1.micro' => { :Arch => 'PV64' },
          :'t2.nano' => { :Arch => 'HVM64' },
          :'t2.micro' => { :Arch => 'HVM64' },
          :'t2.small' => { :Arch => 'HVM64' },
          :'t2.medium' => { :Arch => 'HVM64' },
          :'t2.large' => { :Arch => 'HVM64' },
          :'m1.small' => { :Arch => 'PV64' },
          :'m1.medium' => { :Arch => 'PV64' },
          :'m1.large' => { :Arch => 'PV64' },
          :'m1.xlarge' => { :Arch => 'PV64' },
          :'m2.xlarge' => { :Arch => 'PV64' },
          :'m2.2xlarge' => { :Arch => 'PV64' },
          :'m2.4xlarge' => { :Arch => 'PV64' },
          :'m3.medium' => { :Arch => 'HVM64' },
          :'m3.large' => { :Arch => 'HVM64' },
          :'m3.xlarge' => { :Arch => 'HVM64' },
          :'m3.2xlarge' => { :Arch => 'HVM64' },
          :'m4.large' => { :Arch => 'HVM64' },
          :'m4.xlarge' => { :Arch => 'HVM64' },
          :'m4.2xlarge' => { :Arch => 'HVM64' },
          :'m4.4xlarge' => { :Arch => 'HVM64' },
          :'m4.10xlarge' => { :Arch => 'HVM64' },
          :'c1.medium' => { :Arch => 'PV64' },
          :'c1.xlarge' => { :Arch => 'PV64' },
          :'c3.large' => { :Arch => 'HVM64' },
          :'c3.xlarge' => { :Arch => 'HVM64' },
          :'c3.2xlarge' => { :Arch => 'HVM64' },
          :'c3.4xlarge' => { :Arch => 'HVM64' },
          :'c3.8xlarge' => { :Arch => 'HVM64' },
          :'c4.large' => { :Arch => 'HVM64' },
          :'c4.xlarge' => { :Arch => 'HVM64' },
          :'c4.2xlarge' => { :Arch => 'HVM64' },
          :'c4.4xlarge' => { :Arch => 'HVM64' },
          :'c4.8xlarge' => { :Arch => 'HVM64' },
          :'g2.2xlarge' => { :Arch => 'HVMG2' },
          :'g2.8xlarge' => { :Arch => 'HVMG2' },
          :'r3.large' => { :Arch => 'HVM64' },
          :'r3.xlarge' => { :Arch => 'HVM64' },
          :'r3.2xlarge' => { :Arch => 'HVM64' },
          :'r3.4xlarge' => { :Arch => 'HVM64' },
          :'r3.8xlarge' => { :Arch => 'HVM64' },
          :'i2.xlarge' => { :Arch => 'HVM64' },
          :'i2.2xlarge' => { :Arch => 'HVM64' },
          :'i2.4xlarge' => { :Arch => 'HVM64' },
          :'i2.8xlarge' => { :Arch => 'HVM64' },
          :'d2.xlarge' => { :Arch => 'HVM64' },
          :'d2.2xlarge' => { :Arch => 'HVM64' },
          :'d2.4xlarge' => { :Arch => 'HVM64' },
          :'d2.8xlarge' => { :Arch => 'HVM64' },
          :'hi1.4xlarge' => { :Arch => 'HVM64' },
          :'hs1.8xlarge' => { :Arch => 'HVM64' },
          :'cr1.8xlarge' => { :Arch => 'HVM64' },
          :'cc2.8xlarge' => { :Arch => 'HVM64' }

  mapping 'AWSInstanceType2NATArch',
          :'t1.micro' => { :Arch => 'NATPV64' },
          :'t2.nano' => { :Arch => 'NATHVM64' },
          :'t2.micro' => { :Arch => 'NATHVM64' },
          :'t2.small' => { :Arch => 'NATHVM64' },
          :'t2.medium' => { :Arch => 'NATHVM64' },
          :'t2.large' => { :Arch => 'NATHVM64' },
          :'m1.small' => { :Arch => 'NATPV64' },
          :'m1.medium' => { :Arch => 'NATPV64' },
          :'m1.large' => { :Arch => 'NATPV64' },
          :'m1.xlarge' => { :Arch => 'NATPV64' },
          :'m2.xlarge' => { :Arch => 'NATPV64' },
          :'m2.2xlarge' => { :Arch => 'NATPV64' },
          :'m2.4xlarge' => { :Arch => 'NATPV64' },
          :'m3.medium' => { :Arch => 'NATHVM64' },
          :'m3.large' => { :Arch => 'NATHVM64' },
          :'m3.xlarge' => { :Arch => 'NATHVM64' },
          :'m3.2xlarge' => { :Arch => 'NATHVM64' },
          :'m4.large' => { :Arch => 'NATHVM64' },
          :'m4.xlarge' => { :Arch => 'NATHVM64' },
          :'m4.2xlarge' => { :Arch => 'NATHVM64' },
          :'m4.4xlarge' => { :Arch => 'NATHVM64' },
          :'m4.10xlarge' => { :Arch => 'NATHVM64' },
          :'c1.medium' => { :Arch => 'NATPV64' },
          :'c1.xlarge' => { :Arch => 'NATPV64' },
          :'c3.large' => { :Arch => 'NATHVM64' },
          :'c3.xlarge' => { :Arch => 'NATHVM64' },
          :'c3.2xlarge' => { :Arch => 'NATHVM64' },
          :'c3.4xlarge' => { :Arch => 'NATHVM64' },
          :'c3.8xlarge' => { :Arch => 'NATHVM64' },
          :'c4.large' => { :Arch => 'NATHVM64' },
          :'c4.xlarge' => { :Arch => 'NATHVM64' },
          :'c4.2xlarge' => { :Arch => 'NATHVM64' },
          :'c4.4xlarge' => { :Arch => 'NATHVM64' },
          :'c4.8xlarge' => { :Arch => 'NATHVM64' },
          :'g2.2xlarge' => { :Arch => 'NATHVMG2' },
          :'g2.8xlarge' => { :Arch => 'NATHVMG2' },
          :'r3.large' => { :Arch => 'NATHVM64' },
          :'r3.xlarge' => { :Arch => 'NATHVM64' },
          :'r3.2xlarge' => { :Arch => 'NATHVM64' },
          :'r3.4xlarge' => { :Arch => 'NATHVM64' },
          :'r3.8xlarge' => { :Arch => 'NATHVM64' },
          :'i2.xlarge' => { :Arch => 'NATHVM64' },
          :'i2.2xlarge' => { :Arch => 'NATHVM64' },
          :'i2.4xlarge' => { :Arch => 'NATHVM64' },
          :'i2.8xlarge' => { :Arch => 'NATHVM64' },
          :'d2.xlarge' => { :Arch => 'NATHVM64' },
          :'d2.2xlarge' => { :Arch => 'NATHVM64' },
          :'d2.4xlarge' => { :Arch => 'NATHVM64' },
          :'d2.8xlarge' => { :Arch => 'NATHVM64' },
          :'hi1.4xlarge' => { :Arch => 'NATHVM64' },
          :'hs1.8xlarge' => { :Arch => 'NATHVM64' },
          :'cr1.8xlarge' => { :Arch => 'NATHVM64' },
          :'cc2.8xlarge' => { :Arch => 'NATHVM64' }

  mapping 'AWSRegionArch2AMI',
          :'us-east-1' => { :PV64 => 'ami-2a69aa47', :HVM64 => 'ami-6869aa05', :HVMG2 => 'ami-bb18efad' },
          :'us-west-2' => { :PV64 => 'ami-7f77b31f', :HVM64 => 'ami-7172b611', :HVMG2 => 'ami-31912f51' },
          :'us-west-1' => { :PV64 => 'ami-a2490dc2', :HVM64 => 'ami-31490d51', :HVMG2 => 'ami-0a9dcf6a' },
          :'eu-west-1' => { :PV64 => 'ami-4cdd453f', :HVM64 => 'ami-f9dd458a', :HVMG2 => 'ami-873e61e1' },
          :'eu-west-2' => { :PV64 => 'NOT_SUPPORTED', :HVM64 => 'ami-886369ec', :HVMG2 => 'NOT_SUPPORTED' },
          :'eu-central-1' => { :PV64 => 'ami-6527cf0a', :HVM64 => 'ami-ea26ce85', :HVMG2 => 'ami-a16ba4ce' },
          :'ap-northeast-1' => { :PV64 => 'ami-3e42b65f', :HVM64 => 'ami-374db956', :HVMG2 => 'ami-6b443f0c' },
          :'ap-northeast-2' => { :PV64 => 'NOT_SUPPORTED', :HVM64 => 'ami-2b408b45', :HVMG2 => 'NOT_SUPPORTED' },
          :'ap-southeast-1' => { :PV64 => 'ami-df9e4cbc', :HVM64 => 'ami-a59b49c6', :HVMG2 => 'ami-1c0ba17f' },
          :'ap-southeast-2' => { :PV64 => 'ami-63351d00', :HVM64 => 'ami-dc361ebf', :HVMG2 => 'ami-bf0d0adc' },
          :'ap-south-1' => { :PV64 => 'NOT_SUPPORTED', :HVM64 => 'ami-ffbdd790', :HVMG2 => 'ami-6135440e' },
          :'us-east-2' => { :PV64 => 'NOT_SUPPORTED', :HVM64 => 'ami-f6035893', :HVMG2 => 'NOT_SUPPORTED' },
          :'ca-central-1' => { :PV64 => 'NOT_SUPPORTED', :HVM64 => 'ami-730ebd17', :HVMG2 => 'NOT_SUPPORTED' },
          :'sa-east-1' => { :PV64 => 'ami-1ad34676', :HVM64 => 'ami-6dd04501', :HVMG2 => 'NOT_SUPPORTED' },
          :'cn-north-1' => { :PV64 => 'ami-77559f1a', :HVM64 => 'ami-8e6aa0e3', :HVMG2 => 'NOT_SUPPORTED' }

  resource 'VPC', :Type => 'AWS::EC2::VPC', :Properties => {
      :CidrBlock => find_in_map('SubnetConfig', 'VPC', 'CIDR'),
      :EnableDnsSupport => 'true',
      :EnableDnsHostnames => 'true',
      :Tags => [
          {
              :Key => 'Application',
              :Value => aws_stack_id,
          },
          { :Key => 'Network', :Value => 'Public' },
      ],
  }

  resource 'PublicSubnet', :Type => 'AWS::EC2::Subnet', :Properties => {
      :VpcId => ref('VPC'),
      :CidrBlock => find_in_map('SubnetConfig', 'Public', 'CIDR'),
      :Tags => [
          {
              :Key => 'Application',
              :Value => aws_stack_id,
          },
          { :Key => 'Network', :Value => 'Public' },
      ],
  }

  resource 'InternetGateway', :Type => 'AWS::EC2::InternetGateway', :Properties => {
      :Tags => [
          {
              :Key => 'Application',
              :Value => aws_stack_id,
          },
          { :Key => 'Network', :Value => 'Public' },
      ],
  }

  resource 'GatewayToInternet', :Type => 'AWS::EC2::VPCGatewayAttachment', :Properties => {
      :VpcId => ref('VPC'),
      :InternetGatewayId => ref('InternetGateway'),
  }

  resource 'PublicRouteTable', :Type => 'AWS::EC2::RouteTable', :Properties => {
      :VpcId => ref('VPC'),
      :Tags => [
          {
              :Key => 'Application',
              :Value => aws_stack_id,
          },
          { :Key => 'Network', :Value => 'Public' },
      ],
  }

  resource 'PublicRoute', :Type => 'AWS::EC2::Route', :DependsOn => 'GatewayToInternet', :Properties => {
      :RouteTableId => ref('PublicRouteTable'),
      :DestinationCidrBlock => '0.0.0.0/0',
      :GatewayId => ref('InternetGateway'),
  }

  resource 'PublicSubnetRouteTableAssociation', :Type => 'AWS::EC2::SubnetRouteTableAssociation', :Properties => {
      :SubnetId => ref('PublicSubnet'),
      :RouteTableId => ref('PublicRouteTable'),
  }

  resource 'PublicNetworkAcl', :Type => 'AWS::EC2::NetworkAcl', :Properties => {
      :VpcId => ref('VPC'),
      :Tags => [
          {
              :Key => 'Application',
              :Value => aws_stack_id,
          },
          { :Key => 'Network', :Value => 'Public' },
      ],
  }

  resource 'InboundHTTPPublicNetworkAclEntry', :Type => 'AWS::EC2::NetworkAclEntry', :Properties => {
      :NetworkAclId => ref('PublicNetworkAcl'),
      :RuleNumber => '100',
      :Protocol => '6',
      :RuleAction => 'allow',
      :Egress => 'false',
      :CidrBlock => '0.0.0.0/0',
      :PortRange => { :From => '80', :To => '80' },
  }

  resource 'InboundDynamicPortPublicNetworkAclEntry', :Type => 'AWS::EC2::NetworkAclEntry', :Properties => {
      :NetworkAclId => ref('PublicNetworkAcl'),
      :RuleNumber => '101',
      :Protocol => '6',
      :RuleAction => 'allow',
      :Egress => 'false',
      :CidrBlock => '0.0.0.0/0',
      :PortRange => { :From => '1024', :To => '65535' },
  }

  resource 'InboundSSHPublicNetworkAclEntry', :Type => 'AWS::EC2::NetworkAclEntry', :Properties => {
      :NetworkAclId => ref('PublicNetworkAcl'),
      :RuleNumber => '102',
      :Protocol => '6',
      :RuleAction => 'allow',
      :Egress => 'false',
      :CidrBlock => ref('SSHLocation'),
      :PortRange => { :From => '22', :To => '22' },
  }

  resource 'OutboundPublicNetworkAclEntry', :Type => 'AWS::EC2::NetworkAclEntry', :Properties => {
      :NetworkAclId => ref('PublicNetworkAcl'),
      :RuleNumber => '100',
      :Protocol => '6',
      :RuleAction => 'allow',
      :Egress => 'true',
      :CidrBlock => '0.0.0.0/0',
      :PortRange => { :From => '0', :To => '65535' },
  }

  resource 'PublicSubnetNetworkAclAssociation', :Type => 'AWS::EC2::SubnetNetworkAclAssociation', :Properties => {
      :SubnetId => ref('PublicSubnet'),
      :NetworkAclId => ref('PublicNetworkAcl'),
  }

  resource 'PublicElasticLoadBalancer', :Type => 'AWS::ElasticLoadBalancing::LoadBalancer', :Properties => {
      :CrossZone => 'true',
      :SecurityGroups => [ ref('PublicLoadBalancerSecurityGroup') ],
      :Subnets => [ ref('PublicSubnet') ],
      :Listeners => [
          { :LoadBalancerPort => '80', :InstancePort => '80', :Protocol => 'HTTP' },
      ],
      :HealthCheck => { :Target => 'HTTP:80/', :HealthyThreshold => '3', :UnhealthyThreshold => '5', :Interval => '90', :Timeout => '60' },
  }

  resource 'PublicLoadBalancerSecurityGroup', :Type => 'AWS::EC2::SecurityGroup', :Properties => {
      :GroupDescription => 'Public ELB Security Group with HTTP access on port 80 from the internet',
      :VpcId => ref('VPC'),
      :SecurityGroupIngress => [
          { :IpProtocol => 'tcp', :FromPort => '80', :ToPort => '80', :CidrIp => '0.0.0.0/0' },
      ],
      :SecurityGroupEgress => [
          { :IpProtocol => 'tcp', :FromPort => '80', :ToPort => '80', :CidrIp => '0.0.0.0/0' },
      ],
  }

  resource 'WebServerFleet', :Type => 'AWS::AutoScaling::AutoScalingGroup', :DependsOn => 'PublicRoute', :CreationPolicy => { :ResourceSignal => { :Timeout => 'PT45M', :Count => ref('WebServerCount') } }, :UpdatePolicy => { :AutoScalingRollingUpdate => { :MinInstancesInService => '1', :MaxBatchSize => '1', :PauseTime => 'PT15M', :WaitOnResourceSignals => 'true' } }, :Properties => {
      :AvailabilityZones => [ get_att('PublicSubnet', 'AvailabilityZone') ],
      :VPCZoneIdentifier => [ ref('PublicSubnet') ],
      :LaunchConfigurationName => ref('WebServerLaunchConfig'),
      :MinSize => '1',
      :MaxSize => '10',
      :DesiredCapacity => ref('WebServerCount'),
      :LoadBalancerNames => [ ref('PublicElasticLoadBalancer') ],
      :Tags => [
          { :Key => 'Network', :Value => 'Public', :PropagateAtLaunch => 'true' },
      ],
  }

  resource 'WebServerLaunchConfig', :Type => 'AWS::AutoScaling::LaunchConfiguration', :Metadata => { :'AWS::CloudFormation::Init' => { :config => { :packages => { :yum => { :httpd => [] } }, :files => { :'/var/www/html/index.html' => { :content => join("\n", '<img src="', find_in_map('Region2Examples', aws_region, 'Examples'), '/cloudformation_graphic.png" alt="AWS CloudFormation Logo"/>', '<h1>Congratulations, you have successfully launched the AWS CloudFormation sample.</h1>'), :mode => '000644', :owner => 'root', :group => 'root' }, :'/etc/cfn/cfn-hup.conf' => { :content => join('', "[main]\n", 'stack=', aws_stack_id, "\n", 'region=', aws_region, "\n"), :mode => '000400', :owner => 'root', :group => 'root' }, :'/etc/cfn/hooks.d/cfn-auto-reloader.conf' => { :content => join('', "[cfn-auto-reloader-hook]\n", "triggers=post.update\n", "path=Resources.WebServerLaunchConfig.Metadata.AWS::CloudFormation::Init\n", 'action=/opt/aws/bin/cfn-init -v ', '         --stack ', aws_stack_name, '         --resource WebServerLaunchConfig ', '         --region ', aws_region, "\n", "runas=root\n") } }, :services => { :sysvinit => { :httpd => { :enabled => 'true', :ensureRunning => 'true', :files => [ '/etc/httpd/conf.d/aptobackend.conf', '/var/www/html/index.html' ] }, :'cfn-hup' => { :enabled => 'true', :ensureRunning => 'true', :files => [ '/etc/cfn/cfn-hup.conf', '/etc/cfn/hooks.d/cfn-auto-reloader.conf' ] } } } } } }, :Properties => {
      :ImageId => find_in_map('AWSRegionArch2AMI', aws_region, find_in_map('AWSInstanceType2Arch', ref('WebServerInstanceType'), 'Arch')),
      :SecurityGroups => [ ref('WebServerSecurityGroup') ],
      :InstanceType => ref('WebServerInstanceType'),
      :KeyName => ref('KeyName'),
      :AssociatePublicIpAddress => 'true',
      :UserData => base64(
          join('',
               "#!/bin/bash -xe\n",
               "yum update -y aws-cfn-bootstrap\n",
               "# Install the sample application\n",
               '/opt/aws/bin/cfn-init -v ',
               '    --stack ',
               aws_stack_id,
               '    --resource WebServerLaunchConfig ',
               '    --region ',
               aws_region,
               "\n",
               "# Signal copletion\n",
               '/opt/aws/bin/cfn-signal -e $? ',
               '    --stack ',
               aws_stack_id,
               '    --resource WebServerFleet ',
               '    --region ',
               aws_region,
               "\n",
          )
      ),
  }

  resource 'WebServerSecurityGroup', :Type => 'AWS::EC2::SecurityGroup', :Properties => {
      :GroupDescription => 'Allow access from load balancer and bastion as well as outbound HTTP and HTTPS traffic',
      :VpcId => ref('VPC'),
      :SecurityGroupIngress => [
          {
              :IpProtocol => 'tcp',
              :FromPort => '80',
              :ToPort => '80',
              :SourceSecurityGroupId => ref('PublicLoadBalancerSecurityGroup'),
          },
          {
              :IpProtocol => 'tcp',
              :FromPort => '22',
              :ToPort => '22',
              :CidrIp => ref('SSHLocation'),
          },
      ],
  }

end.exec!
