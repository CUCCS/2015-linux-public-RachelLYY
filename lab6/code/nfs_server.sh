#!/usr/bin/expect
set timeout 1
set PASS rachel
set USER root
spawn sudo ssh -l $USER 192.168.137.94
expect "*#*" { send "apt install nfs-kernel-server\r" }
expect "Y/N" { send "Y\r" }
expect "*#*" { send "mkdir /var/nfs/read_and_write\r" }
expect "*#*" { send "mkdir /var/nfs/read_only\r" }
#expect "*#*" { send "mv /etc/exports /etc/exports.bak\r" }
expect "*#*" { send "scp /etc/exports root@192.168.137.94:/etc/exports\r"}
expect "yes/no" { send "yes\r" }
expect "*password:*" { send  "$PASS\r" }
#  "*#*" { send "vim /etc/exports\r" }
#send { "/var/nfs/read_and_write *(insecure,rw,sync,no_subtree_check\r)" }
#send { "/var/nfs/read_only *(insecure,sync,no_root_squash,no_subtree_check\r" }
#send { ":wq!\r" }
#ssh root@192.168.137.94 << eeooff
#apt install nfs-kernel-server
#mkdir /var/nfs/read_and_write
#mkdir /var/nfs/read_only
#eeooff

