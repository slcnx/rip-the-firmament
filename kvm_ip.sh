#!/bin/bash
#
for i in $(seq 1 254); do
{
ping -c1 -W2 -w1 172.16.0.$i &> /dev/null
} &
done
virsh list | awk 'NR==1{printf "%-6s %-15s %-12s %12s\n",$1,$2,"IP",$3}' 
virsh list | awk 'NR==2{printf "%-6s %-6s %26s\n",$1,$2,$3}'     

# 拣出运行中的虚拟机名
vm_running=$(virsh list | grep "running" | awk '{print $2}')
# 以主机名循环，打印主机名和对应的IP
for i in $vm_running; do
  mac=$(virsh dumpxml $i | grep "mac address" | sed "s@.*'\(.*\)'.*@\1@g")
  ip=$(arp -ne | grep "$mac" | awk '{print $1}')
  #printf "%-s %20s\n" $i $ip
  virsh list | awk -v ip=$ip -v i=$i '{ if (NR>2&&$2==i) {printf "%-6s %-15s %-12s %12s\n",$1,$2,ip,$3} }'
done

