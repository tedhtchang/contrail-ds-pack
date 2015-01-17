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

ico_net_url="http://#{node['contrail']['region_fqdn']}:9696"
neutron_url="http://#{node['contrail']['network_ip']}:9696"

template "/tmp/qemu_to_append.erb" do
   source "qemu_to_append.erb"
   action :create
end
 
bash "append_to_qemu" do
    user "root"
    code <<-EOF
        cat /tmp/qemu_to_append.erb >> /tmp/postcompute.conf
        cat /tmp/qemu_to_append.erb >> /etc/libvirt/qemu.conf
        rm /tmp/qemu_to_append.erb
    EOF
    not_if "grep -q '/dev/net/tun' /etc/libvirt/qemu.conf"
end
 
bash "update-nova" do
    user "root"
    code <<-EOH
        sed -i 's|vif_driver=nova.virt.libvirt.vif.LibvirtGenericVIFDriver|# vif_driver=nova.virt.libvirt.vif.LibvirtGenericVIFDriver|' /etc/nova/nova.conf
        sed -i 's|#{ico_net_url}|#{neutron_url}|' /etc/nova/nova.conf
    EOH
    not_if "grep -q '# vif_driver=nova.virt.libvirt.vif.LibvirtGenericVIFDriver' /etc/nova/nova.conf"
end

search_line="compute_monitors = ComputeDriverCPUMonitor"
insert_line1="libvirt_vif_driver = nova_contrail_vif.contrailvif.VRouterVIFDriver"
insert_line2="neutron_connection_host = #{node['contrail']['network_ip']}"

ruby_block "insert-nova" do
    block do
		file = Chef::Util::FileEdit.new('/etc/nova/nova.conf')
		file.insert_line_after_match(/#{search_line}/, insert_line1)
		file.insert_line_after_match(/#{insert_line1}/, insert_line2)
		file.write_file
	end
    not_if "grep -q 'libvirt_vif_driver = nova_contrail_vif.contrailvif.VRouterVIFDriver' /etc/nova/nova.conf"
end

bash "restart-libvirtd" do
    user "root"
    code <<-EOH
        service libvirtd restart
    EOH
end

bash "update-agent-param" do
    user "root"
    code <<-EOH
        sed -i 's|kmod=/lib|#kmod=/lib|' /etc/contrail/agent_param.tmpl
        echo kmod=/lib/modules/2.6.32-358.el6.x86_64/extra/net/vrouter/vrouter.ko >> /etc/contrail/agent_param.tmpl
    EOH
    not_if "grep -q '/lib/modules/2.6.32-358.el6.x86_64/extra/net/vrouter/vrouter.ko' /etc/contrail/agent_param.tmpl"
end

bash "update-ipaddress" do
    user "root"
    code <<-EOH
        sed -i 's|{}|#{node['contrail']['compute']['ip']}|' /etc/nova/nova.conf
        service openstack-nova-compute restart
    EOH
end
