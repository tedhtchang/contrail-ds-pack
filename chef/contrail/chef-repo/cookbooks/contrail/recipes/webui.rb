#
# Cookbook Name:: contrail
# Recipe:: contrail-webui
#
# Copyright 2014, Juniper Networks
#

package "contrail-openstack-webui" do
    action :upgrade
    notifies :stop, "service[supervisor-webui]", :immediately
end

template "/etc/contrail/config.global.js" do
    source "contrail-config.global.js.erb"
    owner "contrail"
    group "contrail"
    mode 00640
    variables(:servers => get_database_nodes)
    notifies :restart, "service[contrail-webui]", :immediately
    notifies :restart, "service[contrail-webui-middleware]", :immediately
end

%w{ supervisor-webui contrail-webui contrail-webui-middleware }.each do |pkg|
    service pkg do
        action [:enable, :start]
    end
end
