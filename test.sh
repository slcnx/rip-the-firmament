grep -E -i '(svm|vmx)' /proc/cpuinfo || exit 1
ls -lh /dev/kvm

yum -y -d 0 -e 0 install qemu-kvm  libvirt-daemon-kvm virt-install
systemctl start libvirtd.service

# create NAT bridge
brctl addbr br-int
iptables -t nat -A POSTROUTING -j MASQUERADE
sysctl -w net.ipv4.ip_forward=1
ip addr add 172.16.0.0/16 dev br-int
