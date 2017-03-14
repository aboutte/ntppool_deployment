
AWS_CLIENTS = {}.freeze

AWS_CLIENTS[:ec2] = Aws::EC2::Client.new(
  region: aws_region
)

def amazon_linux_ami_id
  amazon_linux_amis = AWS_CLIENTS[:ec2].describe_images(owners: ['amazon'],
                                                        filters: [
                                                          {
                                                            name: 'architecture',
                                                            values: ['x86_64']
                                                          },
                                                          {
                                                            name: 'state',
                                                            values: ['available']
                                                          },
                                                          {
                                                            name: 'virtualization-type',
                                                            values: ['hvm']
                                                          },
                                                          {
                                                            name: 'description',
                                                            values: ['Amazon Linux AMI*']
                                                          },
                                                          {
                                                            name: 'name',
                                                            values: ['amzn-ami-hvm-*']
                                                          }
                                                        ])

  # The results of describe_images is an array of all Amazon Linux AMIs
  # To find the latest sort by the object attribute creation_date
  amazon_linux_amis.images.sort_by!(&:creation_date)
  amazon_linux_amis.images.last.image_id
end
