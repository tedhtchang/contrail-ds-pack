

#yumrepo.rb
default['contrail']['contrail_version'] = '1.2'
#To server your own RHEL repo, set true for this attribute and create the directory structure 'operatingsystem/redhat6.5/x86_64/' under your http server's DoucmentRoot.
default['contrail']['setup_operatingsystem_dependencies_repo'] = false
#Ted chang: for now Hard coding the repo server ip (http://9.30.30.65:3080/) but we need to replace it with chef url(#{Chef::Config[:chef_server_url]})
default['contrail']['base_contrail_yum_url'] = "http://9.30.30.65:3080/scp/contrail_Ted/#{default['contrail']['contrail_version']}/"
default['contrail']['base_operatingsystem_dependencies_url'] = \
	"http://9.30.30.65:3080/scp/operatingsystem/#{node['platform']}#{node['platform_version']}/#{node['kernel']['machine']}/"

