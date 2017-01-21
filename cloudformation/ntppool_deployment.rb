#!/usr/bin/env ruby

require './lib/preload.rb'

template do
  load_from_file('./lib/autoloader.rb')
  value AWSTemplateFormatVersion: '2010-09-09'
  value Description: 'AWS CloudFormation to deploy a NTP Pool Server'
  load_from_file('./parameters.rb')

  tag :application, Value: 'ntpd'
  tag :environment, Value: parameters['Environment']
  tag :launched_by, Value: ENV['USER']

  resource 'ntpdasg', Type: 'AWS::AutoScaling::AutoScalingGroup', Properties: {
    VPCZoneIdentifier: ref('PublicSubnets'),
    LaunchConfigurationName: ref('ntpdlc'),
    MinSize: '1',
    MaxSize: '1',
    DesiredCapacity: '1'
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

  resource 'ntpdlc', Type: 'AWS::AutoScaling::LaunchConfiguration', Properties: {
    ImageId: amazon_linux_ami_id,
    IamInstanceProfile: ref('IAMInstanceProfile'),
    AssociatePublicIpAddress: true,
    SecurityGroups: [ref('ntpdsg')],
    InstanceType: ref('InstanceType'),
    KeyName: ref('KeyName'),
    UserData: base64(interpolate(assemble_userdata))
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
