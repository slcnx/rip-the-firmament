grep -E -i '(svm|vmx)' /proc/cpuinfo || exit 1
ls -lh /dev/kvm

yum -y -d 0 -e 0 install qemu-kvm  libvirt-daemon-kvm virt-install
systemctl start libvirtd.service

# create NAT bridge
brctl addbr br-int
iptables -t nat -F POSTROUTING
iptables -t nat -A POSTROUTING -j MASQUERADE
sysctl -w net.ipv4.ip_forward=1
ifconfig br-int 172.16.0.1/16 up
