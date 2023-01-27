#!/bin/bash
#install SELinux policy 
semodule -i trellixACC.pp
#recover the cli, solidcore is the default password
export RECOVER="sadmin recover -z solidcore"
eval $RECOVER
#add Application Control License
export APPC="sadmin license add x-x-x-x"
eval $AAPC
#add Change Control License
export CC="sadmin license add x-x-x-x"
eval $CC
#solidify the system
export BU="sadmin bu"
export EU="sadmin eu"
export SO="sadmin so"
export BO="sadmin bo"
eval $SO
eval $BO
#restart the service
export RESTART="service scsrvc restart"
eval $RESTART
#lockdown solidcore
export "LD=sadmin lockdown"
eval $LD
#collect props, check for policy and enforce
export MA="/opt/McAfee/agent/bin/cmdagent -p -c -e"
eval $MA