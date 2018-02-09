#!/bin/bash
#
[ -z "$1" ] && echo "$(basename $0) snapshot_name" &&  exit 
NEW_NAME=$1
NEW_NAME_IMAGE_PATH="/images/${NEW_NAME}.img"

virt_name=$(fgrep 'virt_name=' qemu.sh)
virt_name=${virt_name#*=}
read -p 'Enter a template name: ' template_name
template_name=${template_name:-$virt_name}
echo $template_name

virt-clone -n $NEW_NAME -o $template_name -f $NEW_NAME_IMAGE_PATH


