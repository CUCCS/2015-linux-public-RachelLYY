#!/usr/bin/expect
set timeout 1
set PASS rachel
set USER root
spawn sudo ssh -l $USER 192.168.137.94
expect "*#*" { send "apt-get install smbclient\r" }
expect "Y/n" { send "Y\r"}


