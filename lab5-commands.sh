# START TASK 1
# Set up the hostnames shit on each vm using the PDF supplied by the lab
# Check that each VM can talk to one another using the hostname using ping -c 5 <hostname>

# DON'T WORRY ABOUT THIS
# sudo apt install systemd-timesyncd -y
# sudo timedatectl set-ntp true
# timedatectl
# DON'T WORRY ABOUT THIS

# Run this on VM2
sudo apt update
sudo apt install ntp -y
sudo nano /etc/ntp.conf
# Change the server pool as specified in the lab
# ADD YOUR VM2 TO THE SERVER POOL OR IT WILL NOT SHOW UP IN THE LIST
# MAKE SURE TO ADD: server vm2.cosc328.okc OR whatever your hostname is
# Save changes
# Change firewall to allow NTP traffic (might be necessary)
sudo ufw allow ntp
sudo systemctl restart ntp
ntpq -p
# Should see something similar to his screenshot
# Take screenshot

# Run this on VM1
sudo apt update
sudo apt install ntp -y
sudo nano /etc/ntp.conf
# Remove all server pools including the fallback
# Add your server via hostname like: server vm2.cosc328.okc
# Change firewall to allow NTP traffic (might be necessary)
sudo ufw allow ntp
sudo systemctl restart ntp
ntpq -p
# Should see something similar to his screenshot
# Take screenshot

# Run this on VM1
sudo timedatectl set-timezone America/Toronto
# Take a screenshot as described

# Run this on the Kali VM
sudo dpkg-reconfigure tzdata
# Change it to America/Toronto
# Take a screenshot as described

# END TASK 1

# START TASK 2
# Run this on VM2
sudo apt update
sudo apt install vsftpd ftp -y
sudo systemctl enable vsftpd
sudo systemctl start vsftpd
sudo systemctl status vsftpd
# Active: active (running) <- what we want to see
sudo useradd -m ftpuser1
sudo useradd -m ftpuser2
sudo passwd ftpuser1
# letmein
sudo passwd ftpuser2
# letmein
sudo nano /etc/vsftpd.conf
# uncomment the line write_enable=YES
# go to the end, add:
# userlist_enable=YES
# userlist_file=/etc/vsftpd.userlist
# userlist_deny=NO
echo "ftpuser1" | sudo tee -a /etc/vsftpd.userlist
echo "ftpuser2" | sudo tee -a /etc/vsftpd.userlist
# Create the testfile in ftpuser1's home directory
sudo -u ftpuser1 sh -c 'echo "This is the content in the file." > /home/ftpuser1/testfile.txt'
ftp localhost
# Follow the instructions, login with ftpuser1, password: letmein
ls /home/ftpuser1
# Take the screenshot
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/vsftpd.pem -out /etc/ssl/private/vsftpd.pem
# Enter the info following the prompts
# Make sure to use your myokanagan email address when asked for an email
sudo nano /etc/vsftpd.conf
# Follow the instructions to change the cert location
# Save the changes
sudo systemctl restart vsftpd

# Run this on the Kali VM
sudo apt update
sudo apt install filezilla -y
filezilla
# Follow the instructions
# Take the screenshot

# END TASK 2

# START TASK 3
# You really should have done the hostnames thing by this point like I said up top
# Run this on VM1
sudo hostname ldap.cosc328.okc

## !!! Save yourself a headache, make a VM snapshot here
sudo apt update
sudo apt install slapd ldap-utils -y
# letmein
sudo slapcat
# make sure it works
nano base.ldif
#dn: ou=people,dc=cosc328,dc=okc
#objectClass: organizationalUnit
#ou: people
#
#dn: ou=groups,dc=cosc328,dc=okc
#objectClass: organizationalUnit
#ou: groups
# save
sudo ldapadd -x -D cn=admin,dc=cosc328,dc=okc -W -f base.ldif
sudo slappasswd
# letmein
# {SSHA}S90v817OIXmr/HdrtacDgDjLyiDciLqH (copy whatever is generated)
nano ldapuser.ldif
#dn: uid=cs328user,ou=people,dc=cosc328,dc=okc
#objectClass: inetOrgPerson
#objectClass: posixAccount
#objectClass: shadowAccount
#cn: cs328user
#sn: ubuntu
#userPassword: {SSHA}S90v817OIXmr/HdrtacDgDjLyiDciLqH
#loginShell: /bin/bash
#uidNumber: 2000
#gidNumber: 2000
#homeDirectory: /home/cs328user
#
#dn: cn=cs328user,ou=groups,dc=cosc328,dc=okc
#objectClass: posixGroup
#cn: cs328user
#gidNumber: 2000
#memberUid: cs328user
sudo ldapadd -x -D cn=admin,dc=cosc328,dc=okc -W -f ldapuser.ldif

## !!! Make a snapshot of your VM here
sudo apt install ldap-account-manager -y
sudo nano /etc/apache2/conf-enabled/ldap-account-manager.conf
# Comment out Require all granted
# Add Require ip 127.0.0.1 <your VM IP>
# Follow the guide for configuration
# BUT DO THE FOLLOWING
# Make sure all fields with the dc=... are set to dc=cosc328,dc=okc
# Make sure People is changed to people
# Make sure Group/group is changed to groups
sudo systemctl restart apache2

## !!! Probably want to make a VM snapshot here just in case things go sideways
sudo apt install libnss-ldapd libpam-ldapd ldap-utils ldap-auth-config -y
# ldapi:///ldap.cosc328.okc
# dc=cosc328,dc=okc
# Ensure the LDAP Lookups are enabled for: passwd, group, shadow 
# ldapi:///ldap.cosc328.okc
# dc=cosc328,dc=okc
# LDAP Version to use? 3
# Make local root Database Admin? YES
# Does the LDAP database require login? NO
# cn=admin,dc=cosc328,dc=okc
# letmein
sudo nano /etc/nsswitch.conf
# Add compat and ldap to the passwd, group, and shadow lines if not there
sudo nano /etc/pam.d/common-password
# Change line 26
# password [success=1 user_unknown=ignore default=die] pam_ldap.so try_first_pass
sudo nano /etc/pam.d/common-session
# Add the following to the end
# session optional    pam_mkhomedir.so skel=/etc/skel umask=077
sudo systemctl restart nslcd
## NOW IT SHOULD FINALLY FUCKING WORK HOLY SHIT
su - cs328user
# Should prompt for password and work now

### Stuff wasn't working here, then I restarted and magically it was working without changing shit
## TAKE SNAPSHOTS WHERE YOU THINK IT IS APPROPRIATE
# Run this on VM2
sudo apt update
sudo apt install libnss-ldapd libpam-ldapd ldap-utils ldap-auth-config -y
# ldapi:///ldap.cosc328.okc
# dc=cosc328,dc=okc
# Ensure the LDAP Lookups are enabled for: passwd, group, shadow 
# ldapi:///ldap.cosc328.okc
# dc=cosc328,dc=okc
# LDAP Version to use? 3
# Make local root Database Admin? YES
# Does the LDAP database require login? NO
# cn=admin,dc=cosc328,dc=okc
# letmein
sudo nano /etc/nsswitch.conf
# Add compat and ldap to the passwd, group, and shadow lines if not there
sudo nano /etc/pam.d/common-password
# Change line 26
# password [success=1 user_unknown=ignore default=die] pam_ldap.so try_first_pass
sudo nano /etc/pam.d/common-session
# Add the following to the end
# session optional    pam_mkhomedir.so skel=/etc/skel umask=077
sudo systemctl restart nslcd
## NOW IT SHOULD FINALLY FUCKING WORK HOLY SHIT
# If shit doesn't work try rebooting the VM
su cs328user
# Take the screenshot
ldapsearch -x -b dc=cosc328,dc=okc -h ldap.cosc328.okc
# Take the screenshot
ssh cs328user@ldap.cosc328.okc
# Make sure SSH is enabled on VM1
# Take the screenshot on successful SSH login

# Run this on VM1
# Follow the guide
openssl genrsa -aes128 -out ldap_server.key 4096
# Use letmein as the passphrase
openssl rsa -in ldap_server.key -out ldap_server.key
openssl req -new -days 3650 -key ldap_server.key -out ldap_server.csr
sudo openssl x509 -in ldap_server.csr -out ldap_server.crt -req -signkey ldap_server.key -days 3650
sudo cp {ldap_server.key,ldap_server.crt} /etc/ssl/certs/ca-certificates.crt /etc/ldap/sasl2/
sudo chown -R openldap. /etc/ldap/sasl2
nano ldap_ssl.ldif
#dn: cn=config
#changetype: modify
#add: olcTLSCACertificateFile
#olcTLSCACertificateFile: /etc/ldap/sasl2/ca-certificates.crt
#-
#replace: olcTLSCertificateFile
#olcTLSCertificateFile: /etc/ldap/sasl2/ldap_server.crt
#-
#replace: olcTLSCertificateKeyFile
#olcTLSCertificateKeyFile: /etc/ldap/sasl2/ldap_server.key
sudo ldapmodify -Y EXTERNAL -H ldapi:/// -f ldap_ssl.ldif
sudo systemctl restart slapd
echo "TLS_REQCERT allow" | sudo tee /etc/ldap/ldap.conf
sudo nano /etc/ldap.conf
# Uncomment the lines

# Run this on VM2
echo "TLS_REQCERT allow" | sudo tee /etc/ldap/ldap.conf
sudo nano /etc/ldap.conf
# Uncomment the lines
su cs328user

# END TASK 3