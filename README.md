[![Build Status](https://api.travis-ci.org/aboutte/ntppool_deployment.svg?branch=master)](https://travis-ci.org/aboutte/ntppool_deployment)


# ntppool_deployment

## Summary

This repository can be used to quickly stand up NTP Pool servers.  I recently wanted to contribute back to the NTP Pool
but do not have have physical resources to donate back with.  Using Cloudformation we can provision all of the needed 
infrastructure and then using Chef we can configure an EC2 instance to the NTP Pool specifications.
 
## Details

The Cloudformation template will create the following resources:
- VPC
- 3 subnets, 1 per AZ
- ACL
    - inbound
       - UDP 123
    - outbound
        - TCP 80
        - TCP 443
        - UDP 123
        - TCP ephemeral ports (1024-65535)
- Launch Configuration
- Auto Scaling Group
- EIP (only if EIP has not be passed into CloudFormation via the eip parameter)

![AWS Architecture](/assets/aws_architecture.png)


## Usage

I prefer to autogenerate my CloudFormation JSON so I use the [cloudformation-ruby-dsl](https://github.com/bazaarvoice/cloudformation-ruby-dsl).
This section will walk through how to get your environment setup to launch a CloudFormation stack

### Prerequisites

- AWS credentials setup.  Example using environment variables in `~/.bash_profile`:

```
export AWS_ACCESS_KEY_ID="xxxxxxxx"
export AWS_SECRET_ACCESS_KEY="xxxxxxxx"
```
- A sane Ruby environment setup on your workstation.  My recommended approach would be to install the [ChefDK](https://downloads.chef.io/chef-dk/)

### Install

```
# Clone repo from GitHub
git clone git@github.com:aboutte/ntppool_deployment.git
cd ntppool_deployment
bundle install

```

### ntppool_deploument.rb usage message

```
$ ./ntppool_deployment.rb
usage: cloudformation/ntppool_deployment.rb <expand|diff|validate|create|update|cancel-update|delete|describe|describe-resource|get-template>
```

### Launching CloudFormation stack:

```
bundle exec cloudformation/ntppool_deployment.rb create --region us-west-2 --stack-name ntppool-$(date '+%s') --parameters "environment=production;hostname=ntp-usw2.andyboutte.com;eip=52.37.145.131;keyName=aboutte;instanceType=t2.micro" --disable-rollback
```

### Validate CloudFormation Syntax:

```
bundle exec cloudformation/ntppool_deployment.rb validate --region us-west-2 --stack-name ntppool-$(date '+%s') --parameters "environment=production;hostname=ntp-usw2.andyboutte.com;eip=52.37.145.131;keyName=aboutte;instanceType=t2.micro" --disable-rollback
```

## Travis CI

Some of the Rake tasks require AWS credentials.  I have created a `travisci` user in my NTP AWS account and provided the following inline IAM Policy:

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1489533261000",
            "Effect": "Allow",
            "Action": [
                "cloudformation:ValidateTemplate"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "Stmt1489533843000",
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeImages"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
```
Following the Travis CI [documentation](https://docs.travis-ci.com/user/encryption-keys/) I encrypted my AWS Key and Secret:
```
gem install travis
travis encrypt AWS_ACCESS_KEY_ID="AK...EA" --add
travis encrypt AWS_SECRET_ACCESS_KEY="P1V...QDV" --add
```

which automatically updated my .travis.yml file with the secrets.

## TODO: 

- [x] get Travis CI hooked up
- [ ] remove all the unnecessary rubocop overrides
- [ ] find API to automate the generation of [NTP Server](https://github.com/aboutte/ntppool_deployment/blob/master/chef/cookbooks/ntppool_deployment/attributes/default.rb#L2)
- [ ] write test to validate chef code
