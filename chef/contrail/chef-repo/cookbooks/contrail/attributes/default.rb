require 'uri'
#To server your own RHEL repo, set true for this attribute and create the directory structure 'operatingsystem/redhat6.5/x86_64/' under your http server's DoucmentRoot.
default['contrail']['setup_operatingsystem_dependencies_repo'] = "false"
#Ted chang: for now Hard coding the repo server ip (http://9.30.30.65:3080/) but we need to replace it with chef url(#{Chef::Config[:chef_server_url]})
uri = URI("#{Chef::Config[:chef_server_url]}")
chef_server_ip = uri.host
default['contrail']['base_contrail_yum_url'] = "http://#{chef_server_ip}:3080/scp/contrail/"
default['contrail']['base_operatingsystem_dependencies_url'] = \
	"http://9.30.30.65:3080/scp/operatingsystem/#{node['platform']}#{node['platform_version']}/#{node['kernel']['machine']}/"
default['contrail']['keystone_ip']="1.1.1.1"
default['contrail']['region_ip']="1.1.1.2"
default['contrail']['network_ip']="1.1.1.3"
default['contrail']['compute_ip']="1.1.1.4"
default['contrail']['region_fqdn']="a.b.c.com"

# Contrail
default['contrail']['openstack_release'] = "icehouse"
default['contrail']['multi_tenancy'] = "false"
default['contrail']['manage_neutron'] = "false"
default['contrail']['manage_nova_compute'] = "true"
default['contrail']['router_asn'] = "64512"
default['contrail']['service_token'] = "#{node['openstack']['identity']['simple_token_secret']}"
default['contrail']['admin_token'] = "#{node['openstack']['identity']['simple_token_secret']}"
default['contrail']['admin_password'] = "passw0rd"
default['contrail']['admin_user'] = "#{node['openstack']['identity']['admin_user']}"
default['contrail']['admin_tenant_name'] = "#{node['openstack']['identity']['admin_tenant_name']}"
default['contrail']['haproxy'] = "false"
default['contrail']['cfgm']['hostname'] = "hostname.ibm.com"
default['contrail']['cfgm']['ip'] = "#{node['contrail']['network_ip']}"
default['contrail']['region_name'] = "#{node['openstack']['region']}" 
default['contrail']['openstack']['ip'] = "#{node['contrail']['region_ip']}"
# Keystone
default['contrail']['keystone']['ip'] = "#{node['contrail']['keystone_ip']}"
default['contrail']['protocol']['keystone'] = "http"
#Database
default['contrail']['database']['ip'] = "#{node['contrail']['network_ip']}"
# Control
default['contrail']['control']['ip'] = "#{node['contrail']['network_ip']}"
default['contrail']['control']['hostname'] = "hostname2.ibm.com"
# Analytics
default['contrail']['analytics']['ip'] = "#{node['contrail']['network_ip']}"
# Compute
default['contrail']['compute']['interface'] = "eth1"
default['contrail']['compute']['ip'] = "#{node['contrail']['compute_ip']}"
default['contrail']['compute']['hostname'] = "compute.host"
default['contrail']['compute']['netmask'] = "255.255.255.128"
default['contrail']['compute']['gateway'] = "9.30.30.1"
default['contrail']['compute']['cidr'] = "9.30.30.0/24"
default['contrail']['compute']['dns1'] = "9.30.140.13"
default['contrail']['compute']['dns2'] = "9.0.9.1"
default['contrail']['compute']['dns3'] = ""
default['contrail']['compute']['domain'] = "aaa.bbb.com"
