#!/usr/bin/expect
set timeout 1
set PASS rachel
set USER root
set IP [lindex $argv 0]
spawn sudo ssh -l $USER $IP

expect "*#*" { send "apt-get install isc-dhcp-server\r" }
expect "Y/N" { send "Y\r" }
expect "*#*" { send "mv /etc/network/interfaces /etc/network/interfaces.bak\r" }

expect "*#*" { send "scp /etc/network/interfaces root@$IP:/etc/network/interfaces\r"}
expect "yes/no" { send "yes\r" }
expect "*password:*" { send  "$PASS\r" }

expect "*#*": { send "service networking restart\r" }

expect "*#*" { send "mv /etc/default/isc-dhcp-server /etc/default/isc-dhcp-server.bak\r" }
expect "*#*" { send "scp /etc/default/isc-dhcp-server     root@$IP:/etc/default/isc-dhcp-server\r" }
expect "yes/no" { send "yes\r" }
expect "*password:*" { send  "$PASS\r" }
expect "*#*" { send "mv /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.bak\r" }
expect "*#*" { send "scp /etc/dhcp/dhcpd.conf root@$IP:/etc/dhcp/dhcpd.conf\r" }
expect "yes/no" { send "yes\r" }
expect "*password:*" { send  "$PASS\r" }
# 启动服务
expect "*#*" { send "/etc/init.d/isc-dhcp-server start\r" }
# dns
expect "*#*" { send "apt install bind9\r" }
expect "Y/N" { send "Y\r" }
expect "*#*" { send "apt install dnsutils\r" }
expect "Y/N" { send "Y\r" }
expect "*#*" { send "mv /etc/bind/named.conf.local /etc/bind/named.conf.local.bak \r" }
expect "*#*" { send "scp /etc/bind/named.conf.local root@$IP:/etc/bind/named.conf\r" }
expect "yes/no" { send "yes\r" }
expect "*password:*" { send  "$PASS\r" }
expect "*#*" { send "scp /etc/bind/db.cuc.edu.cn root@$IP:/etc/bind/db.cuc.edu.cn\r" }
expect "yes/no" { send "yes\r" }
expect "*password:*" { send  "$PASS\r" }

