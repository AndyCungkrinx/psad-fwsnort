#!/bin/bash
BUILD=$HOME/build
BPS=$BUILD/psad-fwsnort
echo " _____     _____     ____     ______         _       _________   ___       ___    _____      __      _     ____     ______     ________ 
(  __ \   / ____\   (    )   (_  __ \       | |     (_   _____) (  (       )  )  / ____\    /  \    / )   / __ \   (   __ \   (___  ___)
 ) )_) ) ( (___     / /\ \     ) ) \ \   ___| |___    ) (___     \  \  _  /  /  ( (___     / /\ \  / /   / /  \ \   ) (__) )      ) )   
(  ___/   \___ \   ( (__) )   ( (   ) ) (___   ___)  (   ___)     \  \/ \/  /    \___ \    ) ) ) ) ) )  ( ()  () ) (    __/      ( (    
 ) )          ) )   )    (     ) )  ) )     | |       ) (          )   _   (         ) )  ( ( ( ( ( (   ( ()  () )  ) \ \  _      ) )   
( (       ___/ /   /  /\  \   / /__/ /      |_|      (   )         \  ( )  /     ___/ /   / /  \ \/ /    \ \__/ /  ( ( \ \_))    ( (    
/__\     /____/   /__(  )__\ (______/                 \_/           \_/ \_/     /____/   (_/    \__/      \____/    )_) \__/     /__\ "
echo "======================================================================================================
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
======================================================================================================"

echo "=======================================================================================================
Installing Depedencies
======================================================================================================="
yum --enablerepo=extras install epel-release
yum update
yum install git autoconf wget perl bison gcc gettext gzip m4 make net-tools perl-ExtUtils-Embed \
python-devel zlib-devel pcre pcre-devel make automake cmake gcc-c++ kernel-devel openssl \
net-tools psmisc perl-IPTables-ChainMgr perl-Date-Calc perl-Unix-Syslog perl-IPTables-Parse perl-NetAddr-IP libpcap-devel \
libpcre3-devel libdumbnet-devel bison flex zlib-devel liblzma-devel openssl libssl-devel -y
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Depedencies has been installed
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

echo "=======================================================================================================
Disable Firewald
======================================================================================================="
systemctl disable firewalld
systemctl stop firewalld
systemctl mask --now firewalld
iptables -F
iptables -X
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Firewalld disabled
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

echo "=======================================================================================================
Upgrading Perl
======================================================================================================="
yum install centos-release-scl-rh -y
yum --enablerepo=centos-sclo-rh-testing install rh-perl526-perl -y

echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Depedencies has been installed
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

echo "=======================================================================================================
Upgrading Iptables
======================================================================================================="
cd $BPS
wget http://www.netfilter.org/projects/iptables/files/iptables-1.8.3.tar.bz2
tar -xvf iptables-1.8.3.tar.bz2
cd iptables-1.8.3

./configure --prefix=/usr      \
            --sbindir=/sbin    \
            --disable-nftables \
            --enable-libipq    \
            --with-xtlibdir=/lib/xtables &&
make

make install &&
ln -sfv ../../sbin/xtables-legacy-multi /usr/bin/iptables-xml &&

for file in ip4tc ip6tc ipq xtables
do
  mv -v /usr/lib/lib${file}.so.* /lib &&
  ln -sfv ../../lib/$(readlink /usr/lib/lib${file}.so) /usr/lib/lib${file}.so
done
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Iptables upgraded
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

echo "=======================================================================================================
Build kernel module for PCRE and REGEX
======================================================================================================="
cd $BUILD
git clone https://github.com/xnsystems/kpcre.git
cd $BUILD/kpcre
make modules
make modules_install
modprobe ts_pcre

echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Building module finished
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

echo "=======================================================================================================
Installing PSAD 
======================================================================================================="
cd $BPS
iptables -F
iptables -X
iptables -A INPUT -j LOG
iptables -A INPUT -j LOG
iptables-save > /etc/sysconfig/iptables
touch /usr/bin/whois_psad
wget http://www.cipherdyne.com/psad/download/psad-2.4.6.tar.gz
tar xfz psad-2.4.6.tar.gz
cd $BPS/psad-2.4.6
./install.pl

echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PSAD has been installed
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

echo "=======================================================================================================
Installing FWSNORT
======================================================================================================="
cd $BPS
wget https://www.cipherdyne.org/fwsnort/download/fwsnort-1.6.8.tar.gz
tar xfz fwsnort-1.6.8.tar.gz
cd $BPS/fwsnort-1.6.8
./install.pl

echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FWSNORT has been installed
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

echo "=======================================================================================================
Copying rules
======================================================================================================="
cd $BPS
mv /etc/fwsnort/fwsnort.conf /etc/fwsnort/fwsnort.conf.back
mv /etc/psad/psad.conf /etc/psad/psad.conf.back
cp $BPS/fwsnort.conf /etc/fwsnort/fwsnort.conf
cp $BPS/psad.conf /etc/psad/psad.conf
rm -rf /etc/fwsnort/snort_rules
rm -rf /etc/psad/snort_rules
cp -r $BPS/snort_rules/ /etc/fwsnort/snort_rules
cp -r $BPS/snort_rules/ /etc/psad/snort_rules
ln -s /var/lib/fwnort/fwsnort.sh /usr/sbin/

echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
All rules copied
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

echo "=======================================================================================================
Enabling rc-local
======================================================================================================="
cat >/etc/rc.d/rc.local  <<EOL
#!/bin/bash
# THIS FILE IS ADDED FOR COMPATIBILITY PURPOSES
#
# It is highly advisable to create own systemd services or udev rules
# to run scripts during boot instead of using this file.
#
# In contrast to previous versions due to parallel execution during boot
# this script will NOT be run after all other services.
#
# Please note that you must run 'chmod +x /etc/rc.d/rc.local' to ensure
# that this script will be executed during boot.

touch /var/lock/subsys/local
iptables-restore < /etc/sysconfig/iptables
systemctl restart psad
EOL
chmod +x /etc/rc.d/rc.local
systemctl enable rc-local
scl enable rh-perl526 bash
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
rc-local has been enabled
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
