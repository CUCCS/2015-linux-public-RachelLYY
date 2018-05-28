#!/usr/bin/expect
set timeout 1
set PASS rachel
set USER root
set IP [lindex $argv 0]
spawn sudo ssh -l $USER $IP
expect "*#*" { send "apt-get install smbclient\r" }
expect "Y/n" { send "Y\r"}


