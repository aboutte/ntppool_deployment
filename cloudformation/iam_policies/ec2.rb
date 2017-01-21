
resource 'EIPAccess', Type: 'AWS::IAM::Policy', Properties: {
  PolicyName: 'EIPAccess',
  PolicyDocument: {
    Statement: [
      {
        Effect: 'Allow',
        Action: [
          'ec2:AllocateAddress',
          'ec2:AssociateAddress'
        ],
        Resource: '*'
      }
    ]
  },
  Roles: [ref('IAMRole')]
}
