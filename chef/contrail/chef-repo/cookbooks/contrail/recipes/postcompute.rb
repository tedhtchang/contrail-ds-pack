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
network_ip = node['contrail']['control']['hostname']
compute_ip = node['contrail']['compute']['ip']
region_name = node['contrail']['region_name']
admin_token = node['contrail']['admin_token']
ico_net_url="http://#{node['contrail']['region_fqdn']}:9696"
neutron_url="http://#{node['contrail']['network_ip']}:9696"

template "/tmp/qemu_to_append.erb" do
   source "qemu_to_append.erb"
   action :create
end
 
file '/tmp/postcompute.conf' do 
    owner 'root'
    group 'root'
    mode '0755'
    content "keystone_ip=#{keystone_ip} region_ip=#{region_ip} network_ip=#{network_ip} compute_ip=#{compute_ip} region_name=#{region_name} admin_token=#{admin_token}"
	action :create
end

bash "append_to_qemu" do
    user "root"
    code <<-EOF
        cat /tmp/qemu_to_append.erb >> /tmp/postcompute.conf
        cat /tmp/qemu_to_append.erb >> /etc/libvirt/qemu.conf
        rm /tmp/qemu_to_append.erb
    EOF
end
 
bash "update-nova" do
    user "root"
    code <<-EOH
        sed -i 's|vif_driver=nova.virt.libvirt.vif.LibvirtGenericVIFDriver|# vif_driver=nova.virt.libvirt.vif.LibvirtGenericVIFDriver|' /etc/nova/nova.conf
        sed -i 's|#{ico_net_url}|#{neutron_url}|' /etc/nova/nova.conf
    EOH
    not_if "grep -q '# vif_driver=nova.virt.libvirt.vif.LibvirtGenericVIFDriver' /etc/nova/nova.conf"
end

bash "restart-libvirtd" do
    user "root"
    code <<-EOH
        service libvirtd restart
    EOH
end

