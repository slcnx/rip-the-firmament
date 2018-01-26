# qemu-kvm 
-name NAME 
-m <MEM_SIZE> 
-cpu <CPU_TYPE> 
PART1
	-smp n,sockets=n,cores=n,threads=n PART2 PART3 
PART2
	-drive file=filename,if=virtio,media=disk,cache=writeback,format=qcow2 
	或
	-cdrom file 
PART3
	-vnc :0|:1
PART4
	-net nic[,macaddr=mac][,model=type]
	-net tap[,script=file]
qemu-img create -f qcow2 -o size=120G,preallocation=off c7-2-v1.img
virt-install --name c7-2-v1 --ram 2048 --vcpus 4 --disk  /zz/c7-2-v1.img  -b br-int --pxe
## virt-install --name c7-2 --ram 2048 --vcpus 4 --disk  /zz/c7-2.img  --cdrom CentOS-7-x86_64-Minimal-1511.iso -b br-int 

