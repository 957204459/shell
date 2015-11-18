#!/bin/bash
dstdir=`date +%Y-%m-%d`
[ -f /root/zab.sql ] && rm -rf /root/zab.gz
mysqldump -uroot -proot --opt zabbix | gzip >/root/zab.gz
ssh 192.168.8.59 "rm -rf /root/bak/*"
sleep 10
scp -r /root/zab.gz 192.168.8.59:/root/bak/

