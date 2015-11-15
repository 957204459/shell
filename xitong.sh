#!/bin/bash
echo "             \"1:selinux\"    "
echo "             \"2:hostname\"   "
echo "             \"3:ulimit"
read -p "enter:" xy
case $xy in
     1)
        sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config 2>/dev/null
        if [ $? -eq 0 ]
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
     3)
       echo "* soft nofile 65535" >>/etc/security/limits.conf
       echo "* hard nofile 65535" >>/etc/security/limits.conf
       echo "* nproc soft 65535" >>/etc/security/limits.conf
       echo "* nproc hard 65535" >>/etc/security/limits.conf
       if [ $? -eq 0 ];then
         echo "chenggong"
       else
          echo "shibai"
       fi
     ;;
     *)
       echo "usage $0 1 2"
    ;;
esac
