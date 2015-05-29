#!/bin/bash
# go to the repos directory
cd /etc/yum.repos.d
read -p "Are you installing server or client components? (enter s for server, c for client) " installType
if [ "$installType" = "s" ] ; then
    installCommand="tdnf install -y vmware-lightwave-server"
    nextSteps="use /opt/vmware/bin/ic-promote to build your first server or /opt/vmware/bin/ic-promote --partner <hostname or ip-address of partner instance> to build a partner server"
elif [ "$installType" = "c" ] ; then
    installCommand="tdnf install -y vmware-lightwave-clients"
    nextSteps="use /opt/vmware/bin/ic-join --domain-controller <hostname or ip-address of domain controller> to join the domain"    
else
    echo "You didn't enter a valid response... exiting!!!"
fi

#get the lightwave repo
echo "Getting the lightwave.repo"
wget http://raw.githubusercontent.com/gcoburn/AutomationScripts/master/lightwave.repo

#get the extras repo
echo "Getting the photon-extras.repo"
wget http://raw.githubusercontent.com/gcoburn/AutomationScripts/master/photon-extras.repo

#edit the photon-iso.repo
echo "Editing the photon-iso.repo"
sed -i 's/enabled=0/enabled=1/g' ./photon-iso.repo

#install server optional
echo "Installing components"
$installCommand

echo " "
echo " "
tput setaf 2; echo "Installation complete:" 
echo " "
tput setaf 2; echo $nextSteps