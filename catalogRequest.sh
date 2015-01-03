#!/bin/bash

#export java so the call from jenkins works
export JAVA_HOME=/opt/vmware-jre
export PATH=$PATH:/opt/vmware-jre/bin

#go into the cloud client directory
#change to the directory you extracted your cloud client into
cd /opt/cloudclient-3.0.0

#execute the application request so the new build gets pulled from the binary repository
./cloudclient.sh vra catalog request submit --groupid '"Biteback Corp IT"' --id $1 --description scripted --reason JenkinsRequest --export /root/catalogRequest.txt