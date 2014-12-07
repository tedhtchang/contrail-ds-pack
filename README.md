contrail Cookbook integration
=====================


TODO:
------------
* Add/Update override_attributes with ICO specific key/values in metadata.json- done
* Merge Contrail roles to roles directory after the contrail change to more specific role names
* chef/contrail/chef-repo/cookbooks/contrail/templates/default/rabbit-env.conf.erb, rabbitmeq-server will not start with FQDN.

ICO specific change list
----------
#### Cookbook
* chef/contrail/chef-repo/cookbooks/contrail/attributes/default.rb
* chef/contrail/chef-repo/cookbooks/contrail/recipes/cfgm.rb
* chef/contrail/chef-repo/cookbooks/contrail/recipes/database.rb
* chef/contrail/chef-repo/cookbooks/contrail/templates/default/contrail-api.conf.erb
* chef/contrail/chef-repo/cookbooks/contrail/templates/default/contrail-discovery.conf.erb
* chef/contrail/chef-repo/cookbooks/contrail/templates/default/contrail-schema.conf.erb
* chef/contrail/chef-repo/cookbooks/contrail/templates/default/contrail-svc-monitor.conf.erb
* chef/contrail/chef-repo/cookbooks/contrail/templates/default/haproxy.cfg.erb
*
