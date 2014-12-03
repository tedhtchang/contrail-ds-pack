

#To server your own RHEL repo, set true for this attribute and create the directory structure 'operatingsystem/redhat6.5/x86_64/' under your http server's DoucmentRoot, place all RHEL ISO packages in side the directory, and run repocreate command to create a yum repo.
default['contrail']['setup_operatingsystem_dependencies_repo'] = false
default['contrail']['base_operatingsystem_dependencies_url'] = \
	"http://9.30.30.65:3080/scp/operatingsystem/#{node['platform']}#{node['platform_version']}/#{node['kernel']['machine']}/"

#Ted chang: For now, hard coding the repo server ip (http://9.30.30.65:3080/) but we nddeed to replace it with chef url(#{Chef::Config[:chef_server_url]})
default['contrail']['base_contrail_yum_url'] = "http://9.30.30.65:3080/scp/contrail/"

###########################################
#
#  Configuration for this cluster
#
###########################################
default['contrail']['openstack_release'] = "icehouse"
default['contrail']['multi_tenancy'] = false
default['contrail']['manage_neutron'] = false
default['contrail']['manage_nova_compute'] = true
default['contrail']['router_asn'] = 64512
default['contrail']['service_token'] = "contrail123"
default['contrail']['admin_token'] = "contrail123"
default['contrail']['admin_password'] = "contrail123"
default['contrail']['admin_user'] = "admin"
default['contrail']['admin_tenant_name'] = "admin"
default['contrail']['haproxy'] = false
default['contrail']['cfgm']['ip'] = "10.84.13.36"
default['contrail']['region_name'] = node.chef_environment
# Keystone
default['contrail']['keystone']['ip'] = "10.84.13.36"
default['contrail']['protocol']['keystone'] = "http"
#Database
default['contrail']['database']['ip'] = "9.30.30.22"
# Control
default['contrail']['control']['ip'] = "10.84.13.36"
# Analytics
default['contrail']['analytics']['ip'] = "10.84.13.36"
# Compute
default['contrail']['compute']['interface'] = "eth1"
default['contrail']['compute']['ip'] = "10.84.13.36"
default['contrail']['compute']['netmask'] = "255.255.255.0"
default['contrail']['compute']['gateway'] = "10.84.13.254"
default['contrail']['compute']['cidr'] = "10.84.13.0/24"
default['contrail']['compute']['dns1'] = "10.84.9.17"
default['contrail']['compute']['dns2'] = "10.84.5.100"
default['contrail']['compute']['dns3'] = "172.24.16.115"
default['contrail']['compute']['domain'] = "contrail.juniper.net"

