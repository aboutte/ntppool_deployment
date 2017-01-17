
/opt/aws/bin/cfn-signal -e $? '{{ref('WaitHandle')}}'
