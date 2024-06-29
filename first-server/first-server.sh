# ===================================
# ===========WARNING=================
# Do not directly run this script. 
# Manually copy and paste the commands. 
# or type them into your terminal. 
# ===================================

# This is a file of my first server's setup. 
# Example server/vps: ubuntu 22.04

# If you want to quit anything, press Ctrl + C.

# Run all these in your local machine
# ------------------------------------
# Basic Update and Upgrade (Optional for local machine)
sudo apt update && sudo apt upgrade

# change SSH key access
sudo chmod 600 key.pem
ssh -i /path/to/ssh/key.pem username@1.1.1.1 # replace 1.1.1.1 with your IP
# ------------------------------------


# =====================================================
# Congrats at this step you should be in your server. 
# =====================================================


# Basic Update and Upgrade (required for the server since your image might be out of date)
sudo apt update && sudo apt upgrade

# Basic Tools Installing
sudo apt install htop #Task Manager
sudo apt install neofetch #System Information
sudo apt install net-tools #For network
sudo apt install ncdu #For viewing disk info
sudo apt install vim #Text Editor (might come with your image)

# Verify
neofetch
htop

# Check (List) Disk
df -T 

# Check Network Interfaces
ifconfig

# Enable 2Gb of Swap (recommended if your server has less than 2Gb of RAM)
sudo dd if=/dev/zero of=/swapfile bs=1M count=2048 #2*1024
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
sudo swapon --show #or htop
sudo reboot #remember that this line can solve 80% of issues

# Disable Swap (only if you run out of disk space)
# If you do not understand what is this, ignore this. 
# In another word, you are doing the reverse of what you just did. 
sudo swapoff /swapfile
sudo rm /swapfile
sudo swapon --show #or htop
sudo reboot

# Install Databases and Website Tools
sudo apt install apache2
sudo apt install mysql-server
sudo mysql_secure_installation
# <y> <2> <y> <n> <y> <y>
sudo apt install php libapache2-mod-php php-mysql php-xml php-mbstring php-intl php-gd php-curl php-zip

# MySQL Config
sudo mysql -u root -p
CREATE DATABASE mediawiki;
CREATE DATABASE wordpress;
CREATE USER 'mediawikiuser'@'localhost' IDENTIFIED BY 'password';
CREATE USER 'wordpressuser'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON mediawiki.* TO 'mediawikiuser'@'localhost';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpressuser'@'localhost';
FLUSH PRIVILEGES;
SHOW DATABASES;
EXIT;

# IMPORTANT: FOR BOTH MEDIAWIKI AND WORDPRESS, TO GET THE DATABASE HOST, RUN THIS COMMAND: 
ifconfig
# Example output: 127.0.0.1
# Anything seems to be wrong? To verify all the configurations of your network, run this command:
ping 127.0.0.1
# to stop, press Ctrl + C. Recommended to stop after 3 seconds. 

# Install MediaWiki
#creates a wiki under <ip-adress>/mediawiki
wget https://releases.wikimedia.org/mediawiki/1.39/mediawiki-1.39.0.tar.gz
tar -xvzf mediawiki-1.39.0.tar.gz
sudo mv mediawiki-1.39.0 /var/www/html/mediawiki
sudo chown -R www-data:www-data /var/www/html/mediawiki
sudo rvim /etc/apache2/sites-available/mediawiki.conf
# :wq!
sudo a2ensite mediawiki.conf
sudo systemctl reload apache2
sudo mkdir /mwdeleted #to store deleted wikimedia deleted files, optional

# after this go to your wiki to generate Localsettings.php

# Manually edit WP Comfig or copypasting the config from local machine: 
cd /var/www/html/mediawiki
sudo touch LocalSettings.php
sudo rvim LocalSettings.php
# :wq!
cat LocalSettings.php
cd

#Check Disk Status
sudo ncdu / 
# For your reference, at this point my disk used 5.4Gb. 
# Your disk's usage might be higher or lower, it depents on your image and distro.

# Install Wordpress
#creates a wiki under <ip-adress>/wordpress
wget https://wordpress.org/latest.tar.gz
tar -xvzf latest.tar.gz
sudo mv wordpress /var/www/html/wordpress
sudo chown -R www-data:www-data /var/www/html/wordpress
sudo rvim /etc/apache2/sites-availavle/wordpress.conf
# :wq!
sudo a2ensite wordpress.conf
sudo systemctl reload apache2

# Manually edit WP Comfig
ls /var/www/html/wordpress
sudo rvim wp-config.php

# If you own a domain and want to sign it: 
# protip: This is how you get rif of the "it is not seccure" warning created by your browser
sudo apt install certbot python3-certbot-apache
sudo certbot --apache