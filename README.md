contrail Cookbook integration
=====================


TODO:
------------
* Add/Update override_attributes with ICO specific key/values in metadata.json- done
* Merge Contrail roles to roles directory after the contrail change to more specific role names
* chef /contrail/chef-repo/cookbooks/contrail/templates/default/rabbit-env.conf.erb, rabbitmeq-server will not start with FQDN.
	* Propose to change NODENAME=rabbit@<%=node['contrail']['cfgm']['hostname']%> to NODENAME=rabbit@<%=node['hostname']%>

ICO specific change list
----------
#### Cookbook
* chef/contrail/chef-repo/cookbooks/contrail/attributes/default.rb
* /contrail/chef-repo/cookbooks/contrail/templates/default/rabbit-env.conf.erb


#### Seach (*database* and *cfgm* in role) related changed:
* chef/contrail/chef-repo/cookbooks/contrail/recipes/cfgm.rb
* chef/contrail/chef-repo/cookbooks/contrail/recipes/database.rb
* chef/contrail/chef-repo/cookbooks/contrail/templates/default/contrail-api.conf.erb
* chef/contrail/chef-repo/cookbooks/contrail/templates/default/contrail-discovery.conf.erb
* chef/contrail/chef-repo/cookbooks/contrail/templates/default/contrail-schema.conf.erb
* chef/contrail/chef-repo/cookbooks/contrail/templates/default/contrail-svc-monitor.conf.erb
* chef/contrail/chef-repo/cookbooks/contrail/templates/default/haproxy.cfg.erb
* chef/contrail/chef-repo/cookbooks/contrail/recipes/analytics.rb
* chef/contrail/chef-repo/cookbooks/contrail/templates/default/contrail-analytics-api.conf.erb
* chef/contrail/chef-repo/cookbooks/contrail/templates/default/contrail-collector.conf.erb
* chef/contrail/chef-repo/cookbooks/contrail/templates/default/contrail-query-engine.conf.erb
* chef/contrail/chef-repo/cookbooks/contrail/recipes/webui.rb
* chef/contrail/chef-repo/cookbooks/contrail/templates/default/contrail-config.global.js.erb

#### Data type (use String instead of boolean or integer) related changes:
* chef/contrail/chef-repo/cookbooks/contrail/recipes/vrouter.rb
