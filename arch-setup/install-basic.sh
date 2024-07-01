# This guide will help you install Arch Linux with GNOME desktop environment.

# This guide assumes that you are using EFI booting method. 
# If you are using a live CD/USB, make sure you are connected to the internet, then select the first option to boot into the live environment.
# It is normal that the booting will take up to 5 minutes. 


# First, make sure that you have a USB stick with Arch Linux flashed in. Use tools such as Balena Etcher or Rufus to flash the ISO file into the USB stick.
# Boot into the USB stick. You will be greeted with a terminal.

# Choose the first option to boot into the live environment. 

# (OPTIONAL) To increase the font size, run the following command:
setfont ter-132n

# You need Internet connection to proceed. To check if you are connected to the internet, run the following command:
ping google.com
# Press Ctrl+C to stop the ping.

# If you are using a wired conenction, this should return something. If you are using a wireless connection, you need to connect to a wireless network.
# For wireless connection, run the following command:
iwctl # This will open up the iwd prompt.
device list # This will list the network devices.You can also run station list to list the stations.
station <device> get-networks # This will scan for available networks.
station <device> connect <SSID> # This will connect to the network.
# You might need to enter the password. Press enter after entering the password.
# If the connection is successful there will be no output. If the connection is unsuccessful, there might be an error message.
exit # This will exit the iwd prompt.
ping google.com # This will check if you are connected to the internet.

clear # This will clear the terminal. Optional. 

pacman -Sy # This will update the package database.
pacman -Sy archlinux-keyring # This will update the keyring.


lsblk # This will list the block devices. You need to identify the disk you want to install Arch Linux on.
cfdisk /dev/nvme1n1 # This will open up the cfdisk partitioning tool. Replace /dev/nvme1n1 with your disk.
# Three partitions are needed: EFI, swap, and root.
# If you would like to dual boot with Windows, you need to create a Windows partition as well. If it already exists, DO NOT TOUCH IT. Only modify the free space.
# Create first partition: 500M to 1024M, EFI System.
# Create second partition: Linux swap.
# Create third partition: Linux filesystem.
# Write the changes and exit.
lsblk # To check if the partitions are created.
mkfs.fat -F32 /dev/nvme1n1p1 # This will format the EFI partition. Replace /dev/nvme1n1p1 with your EFI partition.
mkfs.ext4 /dev/nvme1n1p3 # This will format the root partition. Replace /dev/nvme1n1p3 with your root partition. You might need to choose `y` to confirm the format.
mkswap /dev/nvme1n1p2 # This will format the swap partition. Replace /dev/nvme1n1p2 with your swap partition.
# Mount the partitions.
mount /dev/nvme1n1p3 /mnt # This will mount the root partition. Replace /dev/nvme1n1p3 with your root partition.
mkdir /mnt/boot # This will create a directory for the boot partition. 
mount /dev/nvme1n1p1 /mnt/boot # This will mount the boot partition. Replace /dev/nvme1n1p1 with your EFI partition.
swapon /dev/nvme1n1p2 # This will enable the swap partition. Replace /dev/nvme1n1p2 with your swap partition.
lsblk # To check if the partitions are mounted.


pacstrap /mnt base base-devel linux linux-firmware git sudo neofetch htop intel-ucode nano vim bluez bluez-utils networkmanager man
# This will install the base packages. You can add or remove packages as needed.
# AMD users should replace intel-ucode with amd-ucode.
# You can choose default for everything here if you don't know what to choose.
# You might need to wait for hours for this, depending on your internet connection. 
# Approximately 2GB of data will be downloaded.


genfstab -U /mnt >> /mnt/etc/fstab # This will generate the fstab file.
cat /mnt/etc/fstab # This will display the fstab file. 


arch-chroot /mnt # This will change the root to the installed system.
neofetch # This will display the system information. Optional.


useradd -m -g users -G wheel,storage,power,video,audio -s /bin/bash <username> # This will create a new user. Replace <username> with your desired username.
passwd <username> # This will set the password for the new user.
EDITOR=nano visudo # This will open the sudoers file. Uncomment the line `%wheel ALL=(ALL) ALL` by removing the `#`. Press `Ctrl+X`, then `Y`, then `Enter` to save and exit.
su - <username> # This will switch to the new user.
sudo pacman -Syu # This will update the system, it also checks whether the new user has sudo privileges.


ln -sf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime # This will set the timezone. Replace America/Los_Angeles with your timezone.
hwclock --systohc # This will set the hardware clock.
nano /etc/locale.gen # This will open the locale.gen file. Uncomment the desired locale(s). Press `Ctrl+X`, then `Y`, then `Enter` to save and exit.
locale-gen # This will generate the locales.
nano /etc/locale.conf # This will open the locale.conf file. Add the following line: `LANG=en_US.UTF-8` (or the language you selected on locale.gen). Press `Ctrl+X`, then `Y`, then `Enter` to save and exit.
nano /etc/hostname # This will open the hostname file. Add your hostname. Press `Ctrl+X`, then `Y`, then `Enter` to save and exit.
nano /etc/hosts # This will open the hosts file. Add the following lines:
# 127.0.0.1   localhost
# ::1         localhost
# 127.0.1.1   yourhostname.localdomain  yourhostname
# Replace yourhostname with your hostname. Press `Ctrl+X`, then `Y`, then `Enter` to save and exit.


# installing GRUB, the bootloader
sudo pacman -Sy grub efibootmgr dosfstools os-prober mtools
lsblk # This will list the block devices. Identify the disk you want to install GRUB on.
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB # This will install GRUB. Replace /boot with your boot partition.
grub-mkconfig -o /boot/grub/grub.cfg # This will generate the GRUB configuration file.'


systemctl enable NetworkManager # This will enable the NetworkManager service.
systemctl enable bluetooth # This will enable the bluetooth service. Optional.
exit # This will exit the chroot environment.


umount -R /mnt # This will unmount the partitions.
reboot # This will reboot the system. Remove the USB stick when prompted.


# (one reboot later)


nmcli dev status # This will show the network devices. 
nmcli radio wifi on # This will turn on the wifi.
nmcli dev wifi list # This will list the available wifi networks.
sudo nmcli dev wifi connect <SSID> password "<password>" # This will connect to the wifi network. Replace <SSID> with the network name and <password> with the password. 
ping google.com


sudo pacman -Syu # This will update the system.# If you are using a wired conenction, this should return something. If you are using a wireless connection, you need to connect to a wireless network.
# For wireless connection, run the following command:
iwctl # This will open up the iwd prompt.
device list # This will list the network devices.You can also run station list to list the stations.
station <device> get-networks # This will scan for available networks.
station <device> connect <SSID> # This will connect to the network.
# You might need to enter the password. Press enter after entering the password.
# If the connection is successful there will be no output. If the connection is unsuccessful, there might be an error message.
exit # This will exit the iwd prompt.
ping google.com # This will check if you are connected to the internet.

clear # This will clear the terminal. Optional. 

pacman -Syu # This will update the package database.
pacman -Sy archlinux-keyring # This will update the keyring.


# Installing GNOME
sudo pacman -Sy gnome gnome-extra gdm # This will install GNOME and GDM.
sudo systemctl enable gdm # This will enable GDM.