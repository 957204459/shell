#!/bin/bash
##################################
#    向阳                        #
#    日期：2015-12-26            #
#################################
export PATH=$PATH:/bin:/sbin:/usr/sbin
#export LANG="zh_CN.GB18030"
. /etc/init.d/functions
if [ -z "$(egrep "CentOS|Redhat" /etc/issue)" ];then
    echo "Only for Redht or CentOS"
    exit 1
fi
if [[ $(whoami) -ne "root" ]];then
    echo "Please run the script as root"
fi	
setSelinux() {
	lokkit --disabled --selinux=disabled

}
setHostname() {
	\cp /etc/sysconfig/network /etc/sysconfig/network.$(date +%F)
        read -p "Please enter hostname:" hostname
        sed -i "/HOSTNAME/d" /etc/sysconfig/network
        echo "HOSTNAME=$hostname" >>/etc/sysconfig/network
        echo "set to hosts"
        echo "127.0.0.1 $hostname" >>/etc/hosts
}
setYum() {
	\cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.$(date +%F)
        echo "set yum epel"
        wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-6.repo
        echo "set yum aliyunRepo"
        wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo
        echo "yum install system software"
        yum -y install telnet wget nethogs autoconf automake make libtool gcc gcc-c++ >/dev/null 2>&1
        if [[ $? -eq "0" ]];then
            action "done" /bin/true
        else
            action "fail" /bin/false 
        fi
}
setUlimit() {
       echo "* soft nofile 65535" >>/etc/security/limits.conf
       echo "* hard nofile 65535" >>/etc/security/limits.conf
       echo "* nproc soft 65535" >>/etc/security/limits.conf
       echo "* nproc hard 65535" >>/etc/security/limits.conf

}
setHistory() {
        echo "set history add date"
        echo "export HISTTIMEFORMAT="%Y-%m-%d-%H:%M:%S"" >>/etc/bashrc
}
echo "################################"
echo "#                              "
echo "#               1:selinux"
echo "#               2:hostname"
echo "#               3:ulimit"
echo "#               4:yum"
echo "#               5 history add date"
echo "#                               " 
echo "################################"
read -p "确定:" xy
case $xy in
     1)
        setSelinux
        export LANG="en_US.UTF-8"
        if [ $? -eq 0 ]
        then
            action "selinux set disabled" /bin/true
        else
            echo "shibai"
        fi
       ;;
     2)
       setHostname
       ;;
     3)
       setUlimit
       if [ $? -eq 0 ];then
         echo "chenggong"
       else
          echo "shibai"
       fi
       ;;
     4)
       setYum
       ;;
     5)
       setHistory
       ;;
     *)
       echo "usage $0 1 2"
       ;;
esac
