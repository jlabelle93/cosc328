# TASK 1 START
# Run in VM2
sudo apt update
sudo apt install traceroute -y
#if your network just FUCKING DISAPPEARS for some reason: sudo nmcli networking on
traceroute -I -m 10 google.com
#seems the default method is via UDP, which was blocked for me for some reason
#take the screenshot showing it hits google.com within 10 hops
#might need to run: sudo apt install net-tools -y
arp -a
#take the screenshot in VM2

# Run in Kali VM
arp -a
#take the screenshot in Kali

# Run in VM2
ping -c 5 kali.cosc328.okc
#or use the IP address of Kali VM
arp -a
#take the screenshot

# Run in Kali VM
ping -c 5 vm2.cosc328.okc
#or use the IP address of VM2
arp -a
#take the screenshot

#Answer the question about how ARP actually worked here

# Run in VM2
netstat -a | more
#take the screenshot
sudo tcpdump -c 15 -i ens33
#take the screenshot
sudo tcpdump -c 2 -XX -i ens33
#take the screenshot of the hex and ascii output

# TASK 1 END

# Probably take snapshots here

# TASK 2 START
# Run in Kali VM
sudo apt update
sudo apt upgrade -y
sudo apt install software-properties-common apt-transport-https -y
sudo wget -q http://www.webmin.com/jcameron-key.asc -O- | sudo apt-key add -
#you'll get a deprecated warning, it should be fine
sudo add-apt-repository "deb [arch=amd64] http://download.webmin.com/download/repository sarge contrib"
#press enter
sudo apt install webmin -y
sudo systemctl status webmin
#looking for active status
#might need to sudo apt install ufw -y
#sudo ufw enable
sudo ufw allow 10000/tcp
sudo ufw reload
#update firewall and reload rules
#sudo /usr/share/webmin/changepass.pl /etc/webmin kali kali
#this shit doesn't work as the default install for webmin creates user root
#just keep it as root
sudo /usr/share/webmin/changepass.pl /etc/webmin root kali

# Run in VM2
#open a web browser
#visit https://kali.cosc328.okc:1000/
#Follow the instructions for the lab to do the next tasks
# TIME FOR COCKPIT
sudo apt install cockpit firewalld -y
sudo systemctl enable --now cockpit.socket
#add firewall rules
sudo ufw allow 9090
sudo ufw reload
#or (maybe and?)
sudo firewall-cmd --add-service=cockpit --permanent
sudo firewall-cmd --reload

# Run in Kali VM
#open a web browser
#visit https://vm2.cosc328.okc:9090/
#Follow the instructions for the lab to do the next tasks
sudo addgroup CockpitGroup --force-badname
sudo adduser cockpituser
sudo usermod -g users -G CockpitGroup cockpituser

# TASK 2 END

# Time for snapshots, like all of them

# TASK 3 START
#OH BOY NETPLAN
#OH BOY THERE REALLY AREN'T SUGGESTIONS HERE JUST FAFO

cat /proc/sys/net/ipv4/ip_forward
# if it isn't 1, follow the lab instructions to enable it (permanently)
# Follow the lab doc
# Don't forget to specify the CORRECT interface in the netplan
sudo apt update
sudo apt install net-tools -y
sudo service systemd-networkd restart
sudo nano /etc/netplan/net1_static_ip.yaml
sudo netplan apply
#ens33 is the default
#ens37 is VMNet2
#ens38 is VMNet3
# update the Kali interface file with the additional interface info