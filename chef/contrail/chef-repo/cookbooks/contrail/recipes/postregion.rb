# encoding: UTF-8
# =================================================================
# Licensed Materials - Property of IBM
#
# (c) Copyright IBM Corp. 2014 All Rights Reserved
#
# US Government Users Restricted Rights - Use, duplication or
# disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
# =================================================================
#
# Cookbook Name:: contrail
# Recipe:: postregion
#

ico_net_url="http://#{node['contrail']['region_fqdn']}:9696"
neutron_url="http://#{node['contrail']['network_ip']}:9696"
nova_url= "http://#{node['contrail']['region_ip']}:8774/v2/%(tenant_id)s"
region_name = node['contrail']['region_name']

template "/tmp/heat_to_append.erb" do
   source "heat_to_append.erb"
   action :create
end
 
bash "update-nova" do
    user "root"
    code <<-EOH
        sed -i 's|#{ico_net_url}|#{neutron_url}|' /etc/nova/nova.conf
        service openstack-nova-api restart
    EOH
#    not_if "grep -q #{neutron_url} /etc/nova/nova.conf"
end

#yum install -y python-contrail python-bottle python-gevent contrail-heat
%w{python-contrail python-bottle python-gevent contrail-heat}.each do |pkg|
	package pkg do
		action :install
	end
end

bash "update-heat" do
    user "root"
    code <<-EOH
        sed -i 's|#plugin_dirs=/usr/lib64/heat,/usr/lib/heat|plugin_dirs=/usr/lib/heat/resources|' /etc/heat/heat.conf
    EOH
end

bash "append-to-heat" do
    user "root"
    code <<-EOF
        cat /tmp/heat_to_append.erb >> /etc/heat/heat.conf
        rm /tmp/heat_to_append.erb
    EOF
end

bash "update-keystone-neutron-endpoint" do
    user "root"
    code <<-EOF
        # Delete defaut neutron endpoint
        . ~/keystonerc
        for i in `keystone endpoint-list|grep #{region_name}|grep $(keystone service-list|grep neutron|awk '{print $2}')|awk '{print $2}'`;do keystone endpoint-delete $i;done
        # Create new neutron endpoint
        keystone endpoint-create --region='#{region_name}' --service-id="`keystone service-list|grep neutron|awk '{print $2}'`" --publicurl='#{neutron_url}' --adminurl='#{neutron_url}' --internalurl='#{neutron_url}'
    EOF
end

bash "update-keystone-nova-endpoint" do
    user "root"
    code <<-EOF
        # Delete defaut nova endpoint
        . ~/keystonerc
        for i in `keystone endpoint-list|grep #{region_name}|grep $(keystone service-list|grep nova|awk '{print $2}')|awk '{print $2}'`;do keystone endpoint-delete $i;done
        # Create new nova endpoint
        keystone endpoint-create --region='#{region_name}' --service-id="`keystone service-list|grep nova|awk '{print $2}'`" --publicurl='#{nova_url}' --adminurl='#{nova_url}' --internalurl='#{nova_url}'
    EOF
end