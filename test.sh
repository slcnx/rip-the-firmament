grep -E -i '(svm|vmx)' /proc/cpuinfo || exit 1
ls -lh /dev/kvm

yum -y -d 0 -e 0 install qemu-kvm  libvirt-daemon-kvm virt-install
systemctl start libvirtd.service

# create NAT bridge
brctl addbr br-int
iptables -t nat -A POSTROUTING -j MASQUERADE
ifconfig br-int 172.17.0.1 netmask 255.255.0.0 up
sysctl -w net.ipv4.ip_forward=1
