
parameter 'environment',
          Description: 'What environment to deploy the application into',
          Type: 'String',
          Default: 'production',
          AllowedValues: %w[production],
          ConstraintDescription: 'Must be a valid environment.'

parameter 'hostname',
          Description: 'What Hostname should be used?',
          Type: 'String',
          Default: 'ntp-usw2.andyboutte.com'

parameter 'eip',
          Description: 'EIP to associate with EC2 instance.  Optional, if EIP is not provided one will be acquired.',
          Type: 'String',
          Default: '52.37.145.131',
          ConstraintDescription: 'Must be a valid CIDR range of the form x.x.x.x'

parameter 'keyName',
          Description: 'Name of an existing EC2 KeyPair to enable SSH access to the instances',
          Type: 'String',
          MinLength: '1',
          MaxLength: '64',
          AllowedPattern: '[-_ a-zA-Z0-9]*',
          Default: 'aboutte',
          ConstraintDescription: 'Can contain only alphanumeric characters, spaces, dashes and underscores.'

parameter 'instanceType',
          Description: 'NTP Server EC2 instance type',
          Type: 'String',
          Default: 't2.micro',
          ConstraintDescription: 'Must be a valid EC2 instance type.'
