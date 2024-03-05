# Do shit here for the purposes of setting up VM1 since we keep having to nuke it

### Set the IP address ###
# IP: 192.168.146.11
# Mask: 255.255.255.0
# Gateway: 192.168.146.2
# DNS: 8.8.8.8
### -------- ###

sudo apt update
sudo apt install apache2 php7.4 mysql-server -y
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo systemctl restart apache2

sudo nano /etc/hosts
# 192.168.146.11 ldap.cosc328.okc
# 192.168.146.22 vm2.cosc328.okc
# 192.168.146.33 kali.cosc328.okc

sudo reboot