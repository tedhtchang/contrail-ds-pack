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
# Recipe:: precompute
#

node.default['contrail']['compute']['hostname']=node["hostname"]
node.default['contrail']['compute']['ip']=node["ipaddress"]

node_hostname = node["hostname"]
node_ip = node["ipaddress"]

file '/tmp/precompute.conf' do 
    owner 'root'
    group 'root'
    mode '0755'
    content "node_hostname=#{node_hostname} node_ip=#{node_ip}"
	action :create
end

