[![Build Status](https://api.travis-ci.org/aboutte/ntppool_deployment.svg?branch=master)](https://travis-ci.org/aboutte/ntppool_deployment)


# ntppool_deployment

## Summary

This repository can be used to quickly stand up NTP Pool servers.  I recently wanted to contribute back to the NTP Pool
but do not have have physical resources to donate back with.  Using Cloudformation we can provision all of the needed 
infrastructure and then using Chef we can configure an EC2 instance to the NTP Pool specifications.  


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
usage: ./ntppool_deployment.rb <expand|diff|validate|create|update|cancel-update|delete|describe|describe-resource|get-template>
```

### Launching CloudFormation stack:

```
bundle exec ./ntppool_deployment.rb create --region us-west-2 --stack-name ntppool-$(date '+%s') --parameters "Environment=production;Hostname=ntp-usw2.andyboutte.com" --disable-rollback
```
