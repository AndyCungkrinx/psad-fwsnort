#!/bin/bash
BPS=$BPS/psad-fwsnort
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
yum install git wget pcre pcre-devel make automake cmake gcc-c++ openssl net-tools -y
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Depedencies has been installed
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

echo "=======================================================================================================
Installing PSAD 
======================================================================================================="
cd $BPS
iptables-save > $HOME/iptables.back
iptables -F
iptables -X
iptables -A INPUT -j LOG
iptables -A INPUT -j LOG
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
cp $BPS/snort_rules/ /etc/fwsnort/snort_rules
cp $BPS/snort_rules/ /etc/psad/snort_rules

echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
All rules copied
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
