# The Final Lab
# The one where the gang gets ARP poisoning
# Why does every lab have to be an ordeal

# START TASK 1

# Run on Kali VM
nmap -sP 192.168.n.0/24
# where n is the domain of your VMWare NAT (default gateway)
# 192.168.x.22 not showing up due to no server stuff running?
# YOLO it isn't even in his screenshot either
# Take the screenshot showing the terminal output

nmap -sT -p 80,443 192.168.n.0/24
# where n is the domain of your VMWare NAT (default gateway)
# 192.168.x.22 not showing up even after enabling ports hmmmmmm
# Take the screenshot showing the terminal output

# END TASK 1

# Make a snapshot ffs

# START TASK 2

# Run on VM2
sudo apt update
# Might not be necessary: sudo apt upgrade -y
sudo apt install telnetd -y
sudo systemctl status inetd
# Looking for active (running)
sudo ufw allow 23/tcp
sudo ufw reload
sudo ufw enable

# Run on VM1
# I had issues getting the connection working
telnet vm2.cosc328.okc 
# enter username
# enter password
sudo nano /etc/hosts.allow
# Add the hostname or IP address for VM1
# Take the screenshot showing the connection from VM1 -> VM2 via Telnet

# Run on Kali VM
# Open wireshark
# Set device to eth0
# Set display filter to telnet as the filter
# Re-run the above VM1 set of instructions
# Go back and look at the entries in Wireshark in Kali
# Find the password segment and take a screenshot as described in the lab doc

# END TASK 2

## SUFFERING BEGINS ####################################

# START TASK 3

# Just follow the lab doc instructions

# END TASK 3

# START TASK 4

# Just follow the lab doc instructions

# END TASK 4

# START TASK 5

# Just follow the lab doc instructions

# END TASK 5
