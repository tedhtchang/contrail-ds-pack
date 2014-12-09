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
# Recipe:: postcompute
#
keystone_ip = node['contrail']['keystone']['ip']
region_ip = node['contrail']['region_ip']
network_ip = node['contrail']['network_ip']
compute_ip = node['contrail']['compute_ip']
region_name = node['contrail']['region_name']
admin_token = node['contrail']['admin_token']

file '/tmp/postcompute.conf' do 
    owner 'root'
    group 'root'
    mode '0755'
    content "keystone_ip=#{keystone_ip} region_ip=#{region_ip} network_ip=#{network_ip} compute_ip=#{compute_ip} region_name=#{region_name} admin_token=#{admin_token}"
	action :create
end

bash "update-nova" do
    user "root"
    code <<-EOH
        sed -i 's|vif_driver=nova.virt.libvirt.vif.LibvirtGenericVIFDriver|# vif_driver=nova.virt.libvirt.vif.LibvirtGenericVIFDriver|' /etc/nova/nova.conf
    EOH
end