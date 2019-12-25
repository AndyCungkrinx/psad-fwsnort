# psad-fwsnort
Firewall combine with Iptables+PSAD+Fwsnort
Make sure u are running as root user
# Step For Installation
================================================
Centos 7
================================================
- git clone https://github.com/AndyCungkrinx/psad-fwsnort.git
- cd psad-fwsnort
- git checkout centos
- chmod u+x centos-upgrade-kernel.sh && chmod u+x centos-fw.sh
BUILD=$PWD
+++++++++++++++++++++++++++++++++++++++++++++++
Upgrade kernel first
+++++++++++++++++++++++++++++++++++++++++++++++
./centos-upgrade-kernel.sh
reboot

===============================================
Installing PSAD+FWSNORT
===============================================
./centos-fw.sh
cd $BUILD
mv /etc/fwsnort/fwsnort.conf /etc/fwsnort/fwsnort.conf.back
mv /etc/psad/psad.conf /etc/psad/psad.conf.back
cp $BUILD/fwsnort.conf /etc/fwsnort/fwsnort.conf
cp $BUILD/psad.conf /etc/psad/psad.conf
systemctl restart psad
systemctl status psad
