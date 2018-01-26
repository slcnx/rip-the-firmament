qemu-img create -f qcow2 -o size=120G,preallocation=off c7-2-v1.img
virt-install --name c7-2-v1 --ram 2048 --vcpus 4 --disk  /zz/c7-2-v1.img  -b br-int --pxe
## virt-install --name c7-2 --ram 2048 --vcpus 4 --disk  /zz/c7-2.img  --cdrom CentOS-7-x86_64-Minimal-1511.iso -b br-int 

