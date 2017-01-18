
# Using chef-dk
rpm -ivh https://packages.chef.io/files/stable/chefdk/1.1.16/el/6/chefdk-1.1.16-1.el6.x86_64.rpm

# Pull down the application cookbook from GitHub
export HOME=/root/
mkdir -p /etc/chef/
cd /tmp/
git clone https://github.com/aboutte/ntppool_deployment.git
mv ntppool_deployment/chef/* /etc/chef/

cat <<EOF > /etc/chef/client.rb
log_level       :info
log_location    "/var/log/chef-client.log"
node_name       "$INSTANCE_ID"
chef_repo_path  "/etc/chef/"
cookbook_path   "/etc/chef/cookbooks/"
environment     "{{ref('Environment')}}"
local_mode      true
json_attribs    "/etc/chef/json_attributes.json"
EOF

# Create the json attributes file to define the run list and cloudformation parameters
cat <<EOF > /etc/chef/json_attributes.json
{
  "run_list": [
    "ntppool_deployment"
  ],
  "cloud": {
    "hostname": "{{ref('Hostname')}}",
  }
}
EOF

# Pull down all the dependency cookbooks
cd /etc/chef/cookbooks/ntppool_deployment
/usr/bin/berks vendor /etc/chef/cookbooks/

# Run chef
chef-client
