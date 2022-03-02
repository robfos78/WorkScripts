#!/bin/bash

#Check for the existance of our log file, delete if true
FILE=/tmp/rmappcrl.log
if test -f "$FILE"; then 
	rm -rf /tmp/rmappcrl.log
else
	touch /tmp/rmappcrl.log
fi 
#Check if the sc service is stopped
SERVICE="scsrvc"
if pgrep -x "$SERVICE" >/dev/null
then
    /usr/local/mcafee/solidcore/scripts/scsrvc stop
else
    echo "$SERVICE stopped" &>> /tmp/rmappcrl.log
fi
#unload the SCMAPL Plugin
/etc/init.d/cma unload SOLIDCOR5000_LNX
#remove the solidcore service
chkconfig --del scsrvc
#remove solidcore packages
if [ $(rpm -aq|grep -c solidcoreS3) -gt 0 ]; then
	rpm -e solidcoreS3 --noscripts && rpm -e solidcoreS3-kmod --noscripts
else
	echo "solidcore package isn't present" &>> /tmp/rmappcrl.log
fi
#remove file structure
if [ -d "/etc/mcafee/solidcore" ]; then
	rm -rf "/etc/mcafee/solidcore"
else
	echo "file /etc/mcafee/solidcore did not exist" &>> /tmp/rmappcrl.log
fi
if [ -d "/var/log/mcafee/solidcore" ]; then
	rm -rf "/var/log/mcafee/solidcore"
else
	echo "file /var/log/mcafee/solidcore did not exist" &>> /tmp/rmappcrl.log
fi
if [ -d "/usr/local/mcafee/solidcore" ]; then
	rm -rf "/usr/local/mcafee/solidcore"
else
	echo "file /usr/local/mcafee/solidcore did not exist" &>> /tmp/rmappcrl.log
fi
if compgen -G "/opt/bitrock/solidcoreS3-*" > /dev/null; then
        rm -rf /opt/bitrock/solidcoreS3-*
else
        echo "file  /opt/bitrock/solidcoreS3-* did not exist" &>> /tmp/rmappcrl.log
fi
if [ -d "/tmp/solidcore.log" ]; then
	rm -rf "/tmp/solidcore.log"
else
	echo "file /tmp/solidcore.log did not exist" &>> /tmp/rmappcrl.log
fi
if [ -d "/tmp/.scsrvc-lock" ]; then
	rm -rf "/tmp/.scsrvc-lock"
else
	echo "file /tmp/.scsrvc-lock did not exist" &>> /tmp/rmappcrl.log
fi
if [ -d "/mcafee/" ]; then
	rm -rf "/mcafee/"
else
	echo "file /mcafee/ did not exist" &>> /tmp/rmappcrl.log
fi
if [ -d "/usr/sbin/sadmin" ]; then
	rm -rf "/usr/sbin/sadmin"
else
	echo "file /usr/sbin/sadmin did not exist" &>> /tmp/rmappcrl.log
fi
#Call back to ePO
/opt/McAfee/agent/bin/cmdagent -p 
fi









