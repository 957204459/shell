#!/bin/bash
echo "             \"1:selinux\"    "
echo "             \"2:hostname\"   "
read -p "enter:" xy
case $xy in
     1)
        sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config 2>/dev/null
        if [ $?=="0" ]
        then
            echo "chenggong"
        else
            echo "shibai"
        fi
     ;;
     2)
       read -p "enter hostname:" name
       sed -i '/HOSTNAME/d' /etc/sysconfig/network
       echo "HOSTNAME=$name" >>/etc/sysconfig/network
    ;;
     *)
       echo "usage $0 1 2"
    ;;
esac
