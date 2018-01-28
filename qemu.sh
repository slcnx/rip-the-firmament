#!/bin/bash
#


path=/tmp/c7.2.img
#create images
qemu-img create -f qcow2 -o size=120G,preallocation=metadata $path

virt_name=c7.2
# pxe 安装
virt-install --name $virt_name --ram 2048 --vcpus 2 --disk  $path  --pxe -b br-int

## virt-install --name c7-2 --ram 2048 --vcpus 4 --disk  /zz/c7-2.img  --cdrom CentOS-7-x86_64-Minimal-1511.iso -b br-int 
