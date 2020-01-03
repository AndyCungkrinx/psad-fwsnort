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
apt update
apt install build-essential libpcre3 libpcre3-dev zlib1g-dev checkinstall iptables-persistent git wget perl bash bc binutils binutils-dev \
bison g++-8 gcc-8 libunwind-dev gettext gzip m4 make net-tools libpci-dev python-dev make automake \
cmake openssl net-tools psmisc libpcap-dev libpcre3-dev libdumbnet-dev bison flex zlib1g-dev liblzma-dev openssl libssl-dev -y
update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 800 --slave /usr/bin/g++ g++ /usr/bin/g++-8
update-alternatives --config gcc

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
make -j4 EXTRA_CMAKE_OPTIONS='-DCMAKE_C_COMPILER=arm64-linux-gcc -DCMAKE_CXX_COMPILER=arm64-linux-gnu-g++ -DCXX_STANDARD_REQUIRED=c++17'

make -j4 EXTRA_CMAKE_OPTIONS='-DCMAKE_C_COMPILER=arm64-linux-gcc -DCMAKE_CXX_COMPILER=arm64-linux-gnu-g++ -DCXX_STANDARD_REQUIRED=c++17' install &&
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
Build modules 
======================================================================================================="
cd $BUILD
git clone https://github.com/xnsystems/kpcre.git
cd $BUILD/kpcre
make -j4 EXTRA_CMAKE_OPTIONS='-DCMAKE_C_COMPILER=arm64-linux-gcc -DCMAKE_CXX_COMPILER=arm64-linux-gnu-g++ -DCXX_STANDARD_REQUIRED=c++17' modules
make -j4 EXTRA_CMAKE_OPTIONS='-DCMAKE_C_COMPILER=arm64-linux-gcc -DCMAKE_CXX_COMPILER=arm64-linux-gnu-g++ -DCXX_STANDARD_REQUIRED=c++17' modules_install
modprobe ts_pcre


perl -MCPAN -e 'install Date::Calc'
perl -MCPAN -e 'install Unix::Syslog'
perl -MCPAN -e 'install IPTables::ChainMgr'
perl -MCPAN -e 'install IPTables::Parse'
perl -MCPAN -e 'install NetAddr::IP'

echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Done!
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

echo "=======================================================================================================
Installing PSAD 
======================================================================================================="
cd $BPS
iptables -F
iptables -X
iptables -A INPUT -j LOG
iptables -A INPUT -j LOG
iptables-save > /etc/iptables/rules.v4
touch /usr/bin/whois_psad
wget http://www.cipherdyne.com/psad/download/psad-2.4.6.tar.gz
tar xfz psad-2.4.6.tar.gz
rm -rf psad-2.4.6.tar.gz
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
rm -rf fwsnort-1.6.8.tar.gz
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
cat >/etc/rc.local  <<EOL
#!/bin/bash
iptables-restore < /etc/iptables/rules.v4
systemctl restart psad
modprobe ts_pcre
exit 0
EOL

systemctl enable rc-local

echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
rc-local has been enabled
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
