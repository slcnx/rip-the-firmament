#!/bin/bash
#
read -p 'enter current ip ' IP
read -p 'enter dest ip ' dest_ip

ssh-copy-id -i ~/.ssh/id_rsa.pub ${IP}
ssh ${IP} 'date'
ssh ${IP} 'ls /etc/sysconfig/network-scripts/ifcfg*'
ssh ${IP} 'rm -f /etc/sysconfig/network-scripts/ifcfg-ens3'
ssh ${IP} 'ls /etc/sysconfig/network-scripts/ifcfg*'
ssh ${IP} "echo -e \"DEVICE=eth0\nONBOOT=yes\nBOOTPROTO=static\nIPADDR=${dest_ip}\nNETMASK=255.255.0.0\nGATEWAY=172.16.0.1\nDNS=172.16.0.1\nIPV6INIT=no\" > /etc/sysconfig/network-scripts/ifcfg-eth0"
ssh ${IP} 'ls /etc/sysconfig/network-scripts/ifcfg*'
ssh ${IP} 'cat /etc/sysconfig/network-scripts/ifcfg-eth0'
ssh ${IP} 'systemctl restart network.service'
sleep 1
ssh ${IP} 'systemctl restart network.service'
