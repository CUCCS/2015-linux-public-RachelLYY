#!/bin/sh
set IP [lindex $argv 0]
expect /home/shell/ftp.sh $IP
expect /home/shell/dhcp_server.sh $IP
expect /home/shell/nfs_server.sh $IP
expect /home/shell/samba.sh $IP
