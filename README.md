https://api.travis-ci.org/aboutte/ntppool_deployment.svg?branch=master

# ntppool_deployment

## Summary

## Using Expanded .json Templates

The expanded CloudFormation templates can be found in the [expanded](https://github.com/andyboutte/cms-deployment/tree/master/cloudformation/applications/cms/expanded) directory.
These expanded templates are the output of the cloudformation-ruby-dsl and are ready for use.

## Parameters

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td>Environment</td>
    <td>string</td>
    <td>What environment to deploy the CMS in</td>
    <td>development</td>
  </tr>
  <tr>
    <td>FrontendInstanceType</td>
    <td>string</td>
    <td>EC2 instance size to use</td>
    <td>t2.small</td>
  </tr>
</table>

## Installing from GitHub

If development work is needed in the CloudFormation area go through this section.

### Prerequisites

- AWS credentials setup.  Example using environment variables in `~/.bash_profile`:

```
export AWS_ACCESS_KEY_ID="xxxxxxxx"
export AWS_SECRET_ACCESS_KEY="xxxxxxxx"
```
- A sane Ruby environment setup on your workstation.  The recommended approach would be to install the [ChefDK](https://downloads.chef.io/chef-dk/)

### Install

```
# Clone repo from GitHub
git clone https://github.com/andyboutte/cms-deployment.git
cd cms-deployment
gem install bundler
bundle install
cd applications/cms/
```

### Usage

##### Usage:

```
$ ./ntppool_deployment.rb
usage: ./ntppool_deployment.rb <expand|diff|validate|create|update|cancel-update|delete|describe|describe-resource|get-template>
```

##### Launching CloudFormation stack:

```
bundle exec ./ntppool_deployment.rb create --region us-west-2 --stack-name ntppool-$(date '+%s') --disable-rollback
```

##### Expand Ruby CloudFormation template into json:

```
 bundle exec ./ntppool_deployment.rb expand --region us-west-2 --parameters "Environment=production;Hostname=ntp-us-west-2.andyboutte.com"
```
