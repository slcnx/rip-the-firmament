#!/bin/bash
#
# path: 镜像路径

image_default_path=/zz/images
[ -d $image_default_path ] || mkdir $image_default_path -p

# image path
read -p "image path[$image_default_path]: " path
! echo $path | grep '.img$' &> /dev/null && echo "example: file.img" && exit 1

if echo "$path" | grep ^/ &> /dev/null; then
	dir=$(dirname $path)
	test -d $dir || mkdir -p $dir
else
	path=$image_default_path/$path
	dir=$(dirname $path)
	test -d $dir || mkdir -p $dir
fi
[ -f $path ] && echo "$path exist!" && exit 2
echo $path
virtualName=$(basename $path)
temp_xml=$(mktemp -u .test.XXXXXX.xml)

# xml
virt_name=$(fgrep 'virt_name=' qemu.sh)
virt_name=${virt_name#*=}
cp /etc/libvirt/qemu/${virt_name}.xml ./test.xml
cp ./test.xml ./$temp_xml 
virtualName=${virtualName%.img}
sed -i -r "s@(<name>)(.*)(</name>)@\1$virtualName\3@" $temp_xml
sed -i -r "s@(<source file=)(.*)(/>)@\1\'$path\'\3@" $temp_xml
sed -i '/uuid/d' $temp_xml
sed -i '/mac address/d' $temp_xml

# image
image_path=$(fgrep 'path=' qemu.sh )
image_path=${image_path#*=}
cp  $image_path $path

# define xml
virsh define $temp_xml

rm ./$temp_xml

