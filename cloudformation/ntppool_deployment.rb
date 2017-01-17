#!/usr/bin/env ruby

require './lib/preload.rb'

template do
  load_from_file('./lib/autoloader.rb')
  value AWSTemplateFormatVersion: '2010-09-09'

  value Description: 'AWS CloudFormation to deploy a NTP Pool Server'

  parameter 'Environment',
            Description: 'What environment to deploy the application into',
            Type: 'String',
            Default: 'production',
            AllowedValues: %w(production),
            ConstraintDescription: 'must be a valid environment.'

  parameter 'Hostname',
            Description: 'What Hostname should be used?',
            Type: 'String',
            Default: 'ntp-us-west-2.andyboutte.com'

  parameter 'VpcId',
            Description: 'What VPC to deploy NTP server into',
            Type: 'String',
            Default: 'vpc-41da6226'

  parameter 'PublicSubnets',
            Description: 'What subnet to deploy NTP server into',
            Type: 'CommaDelimitedList',
            Default: 'subnet-30fd0c79,subnet-5e1bc439,subnet-d06b3388'

  parameter 'eip',
            Description: 'What subnet to deploy NTP server into',
            Type: 'CommaDelimitedList',
            Default: 'subnet-30fd0c79,subnet-5e1bc439,subnet-d06b3388'

  parameter 'KeyName',
            Description: 'Name of an existing EC2 KeyPair to enable SSH access to the instances',
            Type: 'String',
            MinLength: '1',
            MaxLength: '64',
            AllowedPattern: '[-_ a-zA-Z0-9]*',
            Default: 'aboutte',
            ConstraintDescription: 'can contain only alphanumeric characters, spaces, dashes and underscores.'

  parameter 'InstanceType',
            Description: 'Frontend Server EC2 instance type',
            Type: 'String',
            Default: 't2.small',
            AllowedValues: %w(t1.micro t2.small m1.small m1.medium m1.large m1.xlarge m2.xlarge m2.2xlarge m2.4xlarge m3.xlarge m3.2xlarge c1.medium c1.xlarge cc2.8xlarge),
            ConstraintDescription: 'must be a valid EC2 instance type.'

  tag :application, Value: 'ntpd'
  tag :environment, Value: parameters['Environment']
  tag :launched_by, Value: ENV['USER']

  resource 'ntpdasg', :Type => 'AWS::AutoScaling::AutoScalingGroup', :Properties => {
      :VPCZoneIdentifier => ref('PublicSubnets'),
      :LaunchConfigurationName => ref('ntpdlc'),
      :MinSize => '1',
      :MaxSize => '1',
      :DesiredCapacity => '1'
  }

  resource 'ntpdlc', :Type => 'AWS::AutoScaling::LaunchConfiguration', :Properties => {
      :ImageId => amazon_linux_ami_id,
      # :IamInstanceProfile => ref('IAMInstanceProfile'),
      :AssociatePublicIpAddress => true,
      :SecurityGroups => [ ref('ntpdsg') ],
      :InstanceType => ref('InstanceType'),
      :KeyName => ref('KeyName'),
      :UserData => base64(interpolate(assemble_userdata)),
  }

  resource 'ntpdsg', Type: 'AWS::EC2::SecurityGroup', Properties: {
    GroupDescription: 'EC2 security group',
    VpcId: ref('VpcId'),
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
    Timeout: '300',
    Count: 1
  }
end.exec!
