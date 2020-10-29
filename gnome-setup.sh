#!/bin/bash

if [ $(id -u) = 0 ]; then
    echo "This script changes your users gsettings and should thus not be run as root!"
    echo "You may need to enter your password multiple times!"
    exit 1
fi

#
# GNOME Options
#

# Touchpad settings
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
gsettings set org.gnome.desktop.peripherals.touchpad click-method 'fingers'
gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll true
gsettings set org.gnome.desktop.peripherals.touchpad speed 0.18

# Mouse settings
gsettings set org.gnome.desktop.peripherals.mouse accel-profile flat
gsettings set org.gnome.desktop.peripherals.mouse speed 0

# Improve usability
gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,close'

# Enable Night Light
gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true

# Better font smoothing
gsettings set org.gnome.settings-daemon.plugins.xsettings antialiasing 'rgba'

# Nautilus defaults
gsettings set org.gnome.nautilus.icon-view default-zoom-level 'standard'
gsettings set org.gnome.nautilus.list-view default-zoom-level 'small'
gsettings set org.gtk.Settings.FileChooser sort-directories-first true

# Dash to Dock settings
gsettings set org.gnome.shell.extensions.dash-to-dock intellihide-mode 'ALL_WINDOWS'
gsettings set org.gnome.shell.extensions.dash-to-dock running-indicator-style 'SEGMENTED'
gsettings set org.gnome.shell.extensions.dash-to-dock show-trash false

#
# GDM Options
#

# Touchpad settings
sudo -u gdm dbus-launch gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
sudo -u gdm dbus-launch gsettings set org.gnome.desktop.peripherals.touchpad speed 0.18

# Mouse settings
sudo -u gdm dbus-launch gsettings set org.gnome.desktop.peripherals.mouse accel-profile flat
sudo -u gdm dbus-launch gsettings set org.gnome.desktop.peripherals.mouse speed 0

# Enable Night Light
sudo -u gdm dbus-launch gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
