grep -E -i '(svm|vmx)' /proc/cpuinfo || exit 1
ls -lh /dev/kvm

yum -y -d 0 -e 0 install qemu-kvm  libvirt-daemon-kvm virt-install virt-viewer virt-manager

read -p "need a graphic interface?" opt
if [ "$opt" == "y" ] || [ "$opt" == "yes" ]; then
	yum -y -d 0 -e 0 install virt-viewer virt-manager
	yum -y groupinstall "X Window System"
fi

systemctl start libvirtd.service

#init
systemctl stop firewalld.service
setenforce 0

# create NAT bridge
brctl addbr br-int
iptables -t nat -A POSTROUTING -j MASQUERADE
ifconfig br-int 172.17.0.1 netmask 255.255.0.0 up
sysctl -w net.ipv4.ip_forward=1

install br-int /etc/init.d/br-int
chkconfig --add br-int
chkconfig br-int on
