#
# Cookbook Name:: contrail
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

#This intend to replicate the behavior setup.sh
#Some steps may not be necessary. See my comment below



#create contrail installer repo
#Note: recipe[contrail::yumrepo] should take care of this step

#cat << __EOT__ > /etc/yum.repos.d/contrail-install.repo
#[contrail_install_repo]
#name=contrail_install_repo
#baseurl=file:///opt/contrail/contrail_install_repo/
#enabled=1
#priority=1
#gpgcheck=0
#__EOT__
#----------------------------------------------------------

# copy files over
#mkdir -p /opt/contrail/contrail_install_repo
#mkdir -p /opt/contrail/bin
%w{'/opt/contrail/contrail_install_repo' '/opt/contrail/bin'}.each do |dir|
	directory dir do
		recursive true
		action :create
	end
end

# Note: no longer necessary since yum reposerver is served remotely on chef server by default
#cd /opt/contrail/contrail_install_repo; tar xvzf /opt/contrail/contrail_packages/contrail_rpms.tgz

# create shell scripts and put to bin
# Note: I don't see the /opt/contrail/contrail_packages/helpers/ so ignore for now
#cp /opt/contrail/contrail_packages/helpers/* /opt/contrail/bin/

# Remove existing python-crypto-2.0.1 rpm.
#yum -y --disablerepo=* remove python-crypto-2.0.1
# Remove contrail-fabric-utils
# Workaround to fix bug(https://bugs.launchpad.net/juniperopenstack/+bug/1361452)
#yum -y --disablerepo=* remove contrail-fabric-utils
%w{python-crypto contrail-fabric-utils}.each do |pkg|
	package pkg do
		options	'--disablerepo=*'
		action :remove
	end
end
#Install basic packages
#mv /opt/contrail/contrail_packages/setup.sh /opt/contrail/contrail_packages/setup.sh.backup
#Note: There won't be such file to backup


#yum -y --disablerepo=* --enablerepo=contrail_install_repo install contrail-setup contrail-fabric-utils python-pip
%w{contrail-setup contrail-fabric-utils python-pip}.each do |pkg|
	package pkg do
		options	'--disablerepo=* --enablerepo=contrail_install_repo'
		action :install
	end
end
#mv /opt/contrail/contrail_packages/setup.sh.backup /opt/contrail/contrail_packages/setup.sh
# Note: I don't think I need to backup setup.sh. There won't be one to backup

#pip-python install /opt/contrail/contrail_installer/contrail_setup_utils/pycrypto-2.6.tar.gz
#pip-python install /opt/contrail/contrail_installer/contrail_setup_utils/paramiko-1.11.0.tar.gz
#pip-python install /opt/contrail/contrail_installer/contrail_setup_utils/Fabric-1.7.0.tar.gz
include_recipe "python::package"
%w{'/opt/contrail/contrail_installer/contrail_setup_utils/pycrypto-2.6.tar.gz' \
	'/opt/contrail/contrail_installer/contrail_setup_utils/paramiko-1.11.0.tar.gz' \
	'/opt/contrail/contrail_installer/contrail_setup_utils/Fabric-1.7.0.tar.gz'}.each do |ppkg|
	python_pip ppkg do
		action :install
	end
end