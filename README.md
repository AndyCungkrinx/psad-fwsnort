# psad-fwsnort
Firewall combine with Iptables+PSAD+Fwsnort <br>
Make sure u are running as root user <br>
# Step For Installation <br>
================================================<br>
Centos 7<br>
================================================<br>
% mkdir $HOME/build<br>
% BUILD=$HOME/build<br>
% cd $BUILD<br>
% git clone https://github.com/AndyCungkrinx/psad-fwsnort.git<br>
% BPS=$BUILD/psad-fwsnort<br>
% cd $BPS<br>
% git checkout centos<br>
% chmod u+x centos-upgrade-kernel.sh && chmod u+x centos-fw.sh<br>
<br>
+++++++++++++++++++++++++++++++++++++++++++++++<br>
Upgrade kernel first<br>
+++++++++++++++++++++++++++++++++++++++++++++++<br>
% ./centos-upgrade-kernel.sh<br>
% reboot<br>

===============================================<br>
Installing PSAD+FWSNORT (make sure runnig as root user)<br>
===============================================<br>
% BPS=$HOME/build/psad-fwsnort<br>
% cd $BPS<br>
% ./centos-fw.sh<br>
% systemctl restart psad<br>
% systemctl status psad<br>

===============================================<br>
Configure PSAD<br>
===============================================<br>
% nano /etc/psad/psad.conf<br>
- Change value of HOSTNAME to <your_domain> and HOME_NET to <your_ip><br>
<h3>Note:</h3> <br>
* For HOSTNAME you can leave with localhost<br>

===============================================<br>
Configure FWSNORT<br>
===============================================<br>
% nano /etc/fwsnort/fwsnort.conf<br>
- Change value of HOSTNAME to <your_domain> and HOME_NET to <your_ip><br>
<h3>Note:</h3> <br>
* For HOSTNAME you can leave with localhost<br>

# Example using rules
===============================================<br>
Using community rules<br>
===============================================<br>
% fwsnort --include-type ddos,backdoor<br>
% fwsnort.sh<br>
% systemctl restart psad<br>
% systemctl status psad<br>
===============================================<br>
Using emerging rules<br>
===============================================<br>
% fwsnort --include-type emerging.dos,emerging.scan<br>
% fwsnort.sh<br>
% systemctl restart psad<br>
% systemctl status psad<br>
