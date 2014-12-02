#!/bin/sh

PACK_WORKSPACE=`echo $(cd "$(dirname "$0")"; pwd)`
SHELL_PATH=$PACK_WORKSPACE

#Un-pack the pack
#if [ -d $PACK_WORKSPACE ]; then
#    rm -rf $PACK_WORKSPACE
#fi
#mkdir $PACK_WORKSPACE
#tar zxvf $1 -C $PACK_WORKSPACE
#

#Dump base environment to json file
knife environment show deployment-service -F json -c /etc/chef/knife.rb > /tmp/deployment-service.json

cd $PACK_WORKSPACE/chef
for name in `ls`
do
    cd $PACK_WORKSPACE/chef
    cd $name/chef-repo/roles
    #Upload roles
    knife role from file * -c /etc/chef/knife.rb
    #Upload cookbooks
    cd ../cookbooks
    knife cookbook upload * -c /etc/chef/knife.rb -o .
    #Merge base environment to /tmp/deployment-service.json
    cd $PACK_WORKSPACE/chef/$name
    python $SHELL_PATH/lib/envUtil.py /tmp/deployment-service.json `pwd`/metadata.json
    #Replace base environment in chef server
    knife environment from file /tmp/deployment-service.json -c /etc/chef/knife.rb
    #Copy binaries and create yum repo
    mkdir /data/repos/scp/$name
    cp $PACK_WORKSPACE/chef/$name/packages/* /data/repos/scp/$name/
    createrepo /data/repos/scp/$name
    yum clean all
done

#Register new templates
cd $PACK_WORKSPACE/templates
for template in `ls`
do
    source ~/openrc;ds template-create -f $template $template
done

echo "New packs have been added successfully!"
