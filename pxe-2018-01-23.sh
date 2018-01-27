#!/bin/bash
#
# 由于br-int是NAT桥所以 路由器的IP指向br-int的地址。如果是桥接时，应该修改路由器IP

# /var/lib/tftpboot/
_default() {
cat > /var/lib/tftpboot/pxelinux.cfg/default << EOF
default menu.c32
prompt 5
timeout 30
MENU TITLE CentOS 7 PXE Menu 

LABEL linux
MENU LABEL Install CentOS 7 x86_64
KERNEL vmlinuz 
APPEND initrd=initrd.img inst.repo=$URL 	ks=http://${IP}/centos7.cfg	
EOF
}

# /etc/dhcp/dhcpd.conf
_dhcpd() {
cat > /etc/dhcp/dhcpd.conf << EOF 
option domain-name "lccnx.cn";
option domain-name-servers ${IP};
default-lease-time 600;
max-lease-time 7200;
log-facility local7;
subnet ${NETWORK} netmask ${NETMASK} {
  range ${PRE}.${MIN} ${PRE}.${MAX};
  option routers  ${IP};
  filename "pxelinux.0";
  next-server ${IP};
}
EOF
}

ip addr list
read -p 'Enter a interface: ' IFACE
[ -z "$IFACE" ] && exit 0

IP=$(ifconfig ${IFACE} | awk '/inet\>/{print $2}')
NETMASK=$(ifconfig ${IFACE} | awk '/inet\>/{print $4}')
NETWORK=$(ipcalc -n $IP  $NETMASK | tr -dc '.[0-9]' | xargs)
PRE=${IP%.*}
MIN=$[$RANDOM%240]
MAX=$[$MIN+10]

# input installation repo
read -p 'Enter a url for installation repo: ' URL
[ -z "$URL" ] && exit 0
#URL='http://172.16.0.1/centos/7/x86_64'

# root用户对应密码
read -t 10 -p 'Enter a password for login root: ' PASSWORD
PASSWORD=${PASSWORD:-666666zz}
PASSWORD=$(openssl passwd -1 -salt $(openssl rand -hex 7) $PASSWORD)

# pxe常见程序包
yum -y -d 0 -e 0 install tftp-server dhcp httpd syslinux

# configure dhcp
_dhcpd

# configure tftp
cp /usr/share/syslinux/pxelinux.0 /var/lib/tftpboot/
[ -f /var/lib/tftpboot/vmlinuz ] || wget http://mirrors.aliyun.com/centos/7/os/x86_64/images/pxeboot/vmlinuz -P /var/lib/tftpboot/
[ -f /var/lib/tftpboot/initrd.img ] || wget http://mirrors.aliyun.com/centos/7/os/x86_64/images/pxeboot/initrd.img -P /var/lib/tftpboot/ 
cp /usr/share/syslinux/{chain.c32,menu.c32,memdisk,mboot.c32} /var/lib/tftpboot/
mkdir -pv /var/lib/tftpboot/pxelinux.cfg/
_default


# configure kickstart
sed -r -i "s@(rootpw --iscrypted).*@\1 $PASSWORD@" centos7.cfg
sed -r -i "s@(url --url=).*@\1\"$URL\"@" centos7.cfg

\cp centos7.cfg /var/www/html/centos7.cfg

systemctl enable tftp.socket dhcpd.service httpd.service 
systemctl restart tftp.socket dhcpd.service httpd.service 
iptables -F
setenforce 0

