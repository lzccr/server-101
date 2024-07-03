# Some change might need to be made to this document. 

# Update system
sudo pcman -Syu

# Install VM
sudo pacman -Syu qemu virt-manager
sudo systemstl start libvirtd

# Sync
sudo pacman -Sy syncthing
sudo systemctl enable --now syncthing@$(whoami).service
systemctl status syncthing@$(whoami).service
systemctl --user enable syncthing.service
sudo loginctl enable-linger <username>

# Printing
sudo pacman -Syu cups cups-pdf
sudo systemstl enable cups.service
lsusb # to make sure that the printer is connected
firefox /var/spool/cups-pdf/<username>/ # where pdf printed documents will go
