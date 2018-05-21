#!/usr/bin/expect
set timeout 1
set PASS rachel
set USER root
spawn sudo ssh -l $USER 192.168.137.94
#ssh root@$1 << eeooff
expect "*#*" { send "apt install proftpd\r" }
expect "Y/N" { send "Y\r" }
expect "*#*" { send "ftpasswd --passwd --file=/etc/proftpd/ftpd.passwd --name=passwd_test --uid=1000 --home=/home/passwd_test --shell=/sbin/nologin\r" }
expect "*#*" { send "ftpasswd --group --file=/etc/proftpd/ftpd.group --name=passwdtest_group --gid=1000\r" }
expect "*Password:*" { send  "123\r" }
expect "*Password:*" { send "123\r" }

expect "*#*" { send "useradd passwd_test\r" }
expect "*#*" { send "passwd passwd_test\r" }
expect "*password:*" { send  "123\r" }
expect  "*password:*" { send "123\r" }
expect "*#*" { send "scp /etc/proftpd/proftpd.conf root@192.168.137.94:/etc/proftpd\r" }

expect "yes/no" { send "yes\r" }
expect "*password:*" { send  "$PASS\r" }

#spawn ftpasswd --passwd --file=/etc/proftpd/ftpd.passwd --name=passwd_test --uid=1000 --home=/home/passwd_test --shell=/sbin/nologin
#spawn ftpasswd --group --file=/etc/proftpd/ftpd.group --name=passwdtest_group --gid=1000

#spawn ftpasswd --group --name=passwdtest_group --gid=99 --member=passwd_test
#spawn mv /etc/proftpd/proftpd.conf /etc/proftpd/proftpd.conf.bak
#spawn useradd passwd_test
#spawn passwd passwd_test
#expect "Password: "
#send  "123\n"
#expect  "password: "
#send "123\n"

# exit
# eeooff
# copy configuration file 
#spawn scp /etc/proftpd/proftpd.conf root@$1:/etc/proftpd
#expect "Password: "
#senc "rachel"
#echo "maybe_successful??"
