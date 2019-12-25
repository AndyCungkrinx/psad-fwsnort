# psad-fwsnort
Firewall combine with Iptables+PSAD+Fwsnort <br>
Make sure u are running as root user <br>
# Step For Installation <br>
================================================<br>
Centos 7<br>
================================================<br>
% git clone https://github.com/AndyCungkrinx/psad-fwsnort.git<br>
% cd psad-fwsnort<br>
% git checkout centos<br>
% chmod u+x centos-upgrade-kernel.sh && chmod u+x centos-fw.sh<br>
% BUILD=$PWD<br>
+++++++++++++++++++++++++++++++++++++++++++++++<br>
Upgrade kernel first<br>
+++++++++++++++++++++++++++++++++++++++++++++++<br>
% ./centos-upgrade-kernel.sh<br>
% reboot<br>

===============================================<br>
Installing PSAD+FWSNORT<br>
===============================================<br>
% ./centos-fw.sh<br>
% cd $BUILD<br>
% mv /etc/fwsnort/fwsnort.conf /etc/fwsnort/fwsnort.conf.back<br>
% mv /etc/psad/psad.conf /etc/psad/psad.conf.back<br>
% cp $BUILD/fwsnort.conf /etc/fwsnort/fwsnort.conf<br>
% cp $BUILD/psad.conf /etc/psad/psad.conf<br>
% systemctl restart psad<br>
% systemctl status psad<br>
