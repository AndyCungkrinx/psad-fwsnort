# Psad-Fwsnort
<h4>Firewall combine with Iptables+PSAD+Fwsnort <br>
This running as layer 7 NGFirewall. If u need using layer 2 for next level hardening, you can using firewalld or UWF.<br>
Make sure u are running as root user <br>
# Step For Installation <br></h4>

<h2>Ubuntu 18.04</h2>
% mkdir $HOME/build<br>
% BUILD=$HOME/build<br>
% cd $BUILD<br>
% git clone https://github.com/AndyCungkrinx/psad-fwsnort.git<br>
% BPS=$BUILD/psad-fwsnort<br>
% cd $BPS<br>
% chmod u+x ubuntu-up-kernel.sh && chmod u+x ubuntu-fw.sh<br>
<br>
<h3>Upgrade kernel first</h3>
% ./ubuntu-up-kernel.sh<br>
% reboot<br>

<h3>Installing PSAD+FWSNORT (make sure runnig as root user)</h3>
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
<h3>Using community rules (you can see using command "ls /etc/fwsnort/snort_rules")</h3>
% fwsnort --include-type ddos,backdoor --ipt-drop<br>
% /var/lib/fwsnort/fwsnort.sh<br>
% systemctl restart psad<br>
% systemctl status psad<br>

<h3>Using emerging rules (you can see using command "ls /etc/fwsnort/snort_rules")</h3>
% fwsnort --include-type emerging-dos,emerging-scan --ipt-drop<br>
% /var/lib/fwsnort/fwsnort.sh<br>
% systemctl restart psad<br>
% systemctl status psad<br>

# Saving all rules permanently
% iptables-save > /etc/iptables/rules.v4<br>
