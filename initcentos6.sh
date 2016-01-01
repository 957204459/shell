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
        hostname $hostname
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
setSysctl() {
        \cp /etc/sysctl.conf /etc/sysctl.conf.$(date +%F)
        cat >>/etc/sysctl.conf <<EOF
        net.ipv4.tcp_fin_timeout = 2
        net.ipv4.tcp_tw_reuse = 1
        net.ipv4.tcp_tw_recycle = 1
        net.ipv4.tcp_syncookies = 1
        net.ipv4.tcp_keepalive_time =600
        net.ipv4.ip_local_port_range = 4000    65000
        net.ipv4.tcp_max_syn_backlog = 16384
        net.ipv4.tcp_max_tw_buckets = 36000
        net.ipv4.route.gc_timeout = 100
        net.ipv4.tcp_syn_retries = 1
        net.ipv4.tcp_synack_retries = 1
        net.core.somaxconn = 16384
        net.core.netdev_max_backlog = 16384
        net.ipv4.tcp_max_orphans = 16384
        net.nf_conntrack_max = 25000000
        net.netfilter.nf_conntrack_max = 25000000
        net.netfilter.nf_conntrack_tcp_timeout_established = 180
        net.netfilter.nf_conntrack_tcp_timeout_time_wait = 120
        net.netfilter.nf_conntrack_tcp_timeout_close_wait = 60
        net.netfilter.nf_conntrack_tcp_timeout_fin_wait = 120
EOF
        sleep 2
        sysctl -p

}
echo "################################"
echo "#                              "
echo "#               1:selinux"
echo "#               2:hostname"
echo "#               3:ulimit"
echo "#               4:yum"
echo "#               5 history add date"
echo "#               6 sysctl optimize  " 
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
     6)
       setSysctl
       ;;
     *)
       echo "usage $0 1 2"
       ;;
esac
