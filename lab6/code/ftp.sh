#!/usr/bin/expect
set timeout 1
set PASS rachel
set USER root
set IP [lindex $argv 0]
spawn sudo ssh -l $USER $IP
#ssh root@$1 << eeooff
expect "*#*" { send "apt-get update\r" }
expect "*#*" { send "apt install proftpd\r" }
expect "Y/N" { send "Y\r" }
expect "*#*" { send "mkdir /home/passwd_test\r" }
expect "*#*" { send "ftpasswd --passwd --file=/etc/proftpd/ftpd.passwd --name=passwd_test --uid=1000 --home=/home/passwd_test --shell=/sbin/nologin\r" }
expect "*#*" { send "ftpasswd --group --file=/etc/proftpd/ftpd.group --name=passwdtest_group --gid=1000\r" }
expect "*Password:*" { send  "123\r" }
expect "*Password:*" { send "123\r" }
expect "*#*" { send "ftpasswd --group --name=passwdtest_group --gid=99 --member=passwd_test" }

expect "*#*" { send "useradd passwd_test\r" }
expect "*#*" { send "passwd passwd_test\r" }
expect "*password:*" { send  "123\r" }
expect  "*password:*" { send "123\r" }
expect "*#*" { send "scp /etc/proftpd/proftpd.conf root@$IP:/etc/proftpd\r" }

expect "yes/no" { send "yes\r" }
expect "*password:*" { send  "$PASS\r" }
expect "*#*": { send "/usr/sbin/proftpd\r"}

