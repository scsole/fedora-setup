#!/bin/bash

if [ $(id -u) = 0 ]; then
    echo "This script should not be run as root!"
    echo "You may need to enter your password multiple times!"
    exit 1
fi



#
# System configuration
#

# Increase the number of allowed inotify subscriptions for non-root users
sudo tee /etc/sysctl.d/40-max-user-watches.conf > /dev/null <<EOF
fs.inotify.max_user_watches=524288
EOF

# Ensure system clock is in UTC (defaults to RTC if dual booting alongside Windows)
sudo timedatectl set-local-rtc 0



#
# Configure DNF Repos
#

# Enable RPM Fusion Free Repo
sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm

# Enable RPM Fusion Nonfree Repo
sudo dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Disable Modular Repos
sudo sed -i 's/enabled=1/enabled=0/' /etc/yum.repos.d/fe*mod*

# RPM Fusion makes this obsolete
sudo sed -i 's/enabled=1/enabled=0/g' /etc/yum.repos.d/fedora-cisco-openh264.repo

# Enpass (password manager) Repo
sudo wget -P /etc/yum.repos.d/ https://yum.enpass.io/enpass-yum.repo



# Force update the whole system to the latest and greatest
sudo dnf upgrade --best --allowerasing --refresh -y

# And also remove any packages without a source backing them
sudo dnf distro-sync -y



#
# Install useful packages
#

PKGS=(
    'vim-enhanced'              # VIM editor with all recent enhancements
    'gthumb'                    # Image viewer, editor, organizer
    'lm_sensors'                # Hardware monitoring tools
    'neofetch'                  # System info tool
    'bashtop'                   # Awesome resource monitor
    'htop'                      # Process monitor
    'iotop'                     # I/O monitor
    'exfat-utils'               # Utilities for exFAT file systems
    'bsdtar'                    # Manipulate tape archives
    'filezilla'                 # S/FTP client
    'transmission'              # Lightweight BitTorrent client
    'sqlitebrowser'             # Create, design, and edit SQLite databases
    'gnome-shell-extension-dash-to-dock' # Dock for GNOME shell
    'gnome-shell-extension-gamemode' # Status indicator for GameMode
    'gnome-extensions-app'      # GNOME extensions manager
    'hydrapaper'                # Set different backgrounds on each monitor
    'enpass'                    # Password manager

    # Media & codecs
    'ffmpeg'
    'mediainfo'
    'mediainfo-gui'
    'mkvtoolnix-gui'
    'handbrake'
    'handbrake-gui'

    # Communication
    'discord'
    'telegram-desktop'

    # Dev
    'vagrant'
    'vagrant-libvirt'
    'virt-manager'
    'cmake'
    'gcc-c++'
    'libftdi'
    'libftdi-devel'
    'systemd-devel'
)

sudo dnf install -y "${PKGS[@]}"

# Remove unneeded packages
sudo dnf remove -y totem


#
# Install Flatpak apps
#

FLATHUB_PKGS=(
    'org.signal.Signal'         # Signal desktop client
    'com.valvesoftware.Steam'   # Steam
)

sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub "${FLATHUB_PKGS[@]}"



#
# Finish setup
#

# Set Vim as the default editor
grep -qxF 'EDITOR=vim' /etc/environment || sudo tee -a /etc/environment > /dev/null <<EOF
EDITOR=vim
EOF

# Detect hardware monitoring chips
sudo sensors-detect --auto

# Set GNOME defaults
./gnome-setup.sh

# Reboot to apply changes
echo "Please Reboot" && exit 0
