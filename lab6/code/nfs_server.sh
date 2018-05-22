#!/usr/bin/expect
set timeout 1
set PASS rachel
set USER root
set IP [lindex $argv 0]
spawn sudo ssh -l $USER $IP
expect "*#*" { send "apt-get install rpcbind\r" }
expect "Y/N" { send "Y\r" }
expect "*#*" { send "apt install nfs-kernel-server\r" }
expect "Y/N" { send "Y\r" }
expect "*#*" { send "mkdir /home/read_and_write\r" }
expect "*#*" { send "mkdir /home/read_only\r" }
#expect "*#*" { send "mv /etc/exports /etc/exports.bak\r" }
expect "*#*" { send "scp /etc/exports root@$IP:/etc/exports\r"}
expect "yes/no" { send "yes\r" }
expect "*password:*" { send  "$PASS\r" }
expect "*#*" { send "exportfs -ra\r" }
expect "*#*" { send "service rpcbind start || true" }
expect "*#*" { send "service nfs-kernel-server restart\r" }
