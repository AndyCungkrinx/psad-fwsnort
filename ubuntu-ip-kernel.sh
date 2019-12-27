#!/bin/bash
echo " ______                              _           ______                  _           _             
(____  \              /\            | |         / _____)                | |         (_)            
 ____)  )_   _ _     /  \  ____   _ | |_   _   | /     _   _ ____   ____| |  _  ____ _ ____  _   _ 
|  __  (| | | (_)   / /\ \|  _ \ / || | | | |  | |    | | | |  _ \ / _  | | / )/ ___) |  _ \( \ / )
| |__)  ) |_| |_   | |__| | | | ( (_| | |_| |  | \____| |_| | | | ( ( | | |< (| |   | | | | |) X ( 
|______/ \__  (_)  |______|_| |_|\____|\__  |   \______)____|_| |_|\_|| |_| \_)_|   |_|_| |_(_/ \_)
        (____/                        (____/                      (_____| "

echo "=======================================================================================================
Upgrading latest kernel
======================================================================================================="
rpm –-import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
rpm -Uvh https://www.elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm
yum update && \
yum --enablerepo=elrepo-kernel install kernel-ml-{devel,headers,perf} -y && \
yum --enablerepo=elrepo-kernel install kernel-lt -y && \
sed -i 's/GRUB_DEFAULT=saved/GRUB_DEFAULT=0/g' /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg
grub2-set-default 0
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Kernel has been upgraded wait for rebooting
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
reboot
