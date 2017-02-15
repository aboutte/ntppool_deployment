
parameter 'Environment',
          Description: 'What environment to deploy the application into',
          Type: 'String',
          Default: 'production',
          AllowedValues: %w(production),
          ConstraintDescription: 'must be a valid environment.'

parameter 'Hostname',
          Description: 'What Hostname should be used?',
          Type: 'String',
          Default: 'ntp-usw2.andyboutte.com'

parameter 'eip',
          Description: 'EIP to associate with EC2 instance.  Optional, if EIP is not provided one will be aquired.',
          Type: 'String',
          Default: '52.37.145.131',
          ConstraintDescription: 'Must be a valid CIDR range of the form x.x.x.x'

parameter 'KeyName',
          Description: 'Name of an existing EC2 KeyPair to enable SSH access to the instances',
          Type: 'String',
          MinLength: '1',
          MaxLength: '64',
          AllowedPattern: '[-_ a-zA-Z0-9]*',
          Default: 'aboutte',
          ConstraintDescription: 'can contain only alphanumeric characters, spaces, dashes and underscores.'

parameter 'InstanceType',
          Description: 'NTP Server EC2 instance type',
          Type: 'String',
          Default: 't2.micro',
          ConstraintDescription: 'must be a valid EC2 instance type.'
