# Psad-Fwsnort
Firewall combine with Iptables+PSAD+Fwsnort <br>
Make sure u are running as root user <br>
# Step For Installation <br>
================================================<br>
Ubuntu 18.04 ARM64<br>
================================================<br>
% mkdir $HOME/build<br>
% BUILD=$HOME/build<br>
% cd $BUILD<br>
% git clone https://github.com/AndyCungkrinx/psad-fwsnort.git<br>
% BPS=$BUILD/psad-fwsnort<br>
% git checkout ubuntu-arm64<br>
% cd $BPS<br>
% chmod u+x ubuntu-up-kernel.sh && chmod u+x ubuntu-fw.sh<br>
<br>
+++++++++++++++++++++++++++++++++++++++++++++++<br>
Upgrade kernel first<br>
+++++++++++++++++++++++++++++++++++++++++++++++<br>
% ./ubuntu-up-kernel.sh<br>
% reboot<br>

===============================================<br>
Installing PSAD+FWSNORT (make sure runnig as root user)<br>
===============================================<br>
% BPS=$HOME/build/psad-fwsnort<br>
% cd $BPS<br>
% ./ubuntu-fw.sh<br>
% systemctl restart psad<br>
% systemctl status psad<br>


# Configure PSAD
% nano /etc/psad/psad.conf<br>
Change value of HOSTNAME to <your_domain> and HOME_NET to <your_ip><br>
<u>Note:</u> <br>
* For HOSTNAME you can leave with localhost<br>

# Configure FWSNORT
% nano /etc/fwsnort/fwsnort.conf<br>
- Change value of HOSTNAME to <your_domain> and HOME_NET to <your_ip><br>
<u>Note:</u> <br>
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
