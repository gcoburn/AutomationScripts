#!/bin/bash
# created by Gary coburn to enable the client authentication via lightwave ldap
# prereqs are that the lightwave client is already installed

/opt/likewise/bin/domainjoin-cli configure --enable pam
/opt/likewise/bin/domainjoin-cli configure --enable nsswitch
/opt/likewise/bin/lwregshell set_value '[HKEY_THIS_MACHINE\Services\lsass\Parameters\Providers]' LoadOrder "ActiveDirectory" "VmDir" "Local"
/opt/likewise/bin/lwsm restart lsass