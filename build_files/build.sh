#!/bin/bash

set -ouex pipefail

# Copy Files to Container
cp -avf "/ctx/system_files/shared"/. /

# make root's home
mkdir -p /var/roothome

rpm-ostree install dnf5-plugins

dnf5 -y copr enable ublue-os/packages
dnf5 -y install ublue-os-just ublue-os-luks ublue-os-signing ublue-os-udev-rules ublue-os-update-services
dnf5 -y copr disable ublue-os/packages

# Remove Fedora Flatpak and related packages
dnf5 remove -y fedora-flathub-remote

### Install packages

# Replace podman provided policy.json with ublue-os one.
mv /usr/etc/containers/policy.json /etc/containers/policy.json

# Add Flathub to the image for eventual application
mkdir -p /etc/flatpak/remotes.d/
curl --retry 3 -Lo /etc/flatpak/remotes.d/flathub.flatpakrepo https://dl.flathub.org/repo/flathub.flatpakrepo

# Fedora Flatpak service is a part of the flatpak package, ensure it's overridden by moving to replace it at the end of the build.
mv -f /usr/lib/systemd/system/flatpak-add-flathub-repos.service /usr/lib/systemd/system/flatpak-add-fedora-repos.service

dnf5 config-manager setopt fedora-cisco-openh264.enabled=0

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1
dnf5 -y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
dnf5 -y install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
# this installs a package from fedora repos
dnf5 install -y --setopt=install_weak_deps=false niri qt6ct sddm nautilus gnome-disk-utility waybar network-manager-applet nwg-launchers pipewire lshw wpa_supplicant NetworkManager-wifi mako swaybg swayidle swaylock gvfs-fuse pavucontrol-qt xfce-polkit mpd mpc mpdris2 qqc2-breeze-style xdg-user-dirs xdg-utils rsms-inter-vf-fonts google-crosextra-caladea-fonts wireplumber pipewire-pulse gnome-keyring xdg-desktop-portal-gnome xdg-desktop-portal-gtk git systemd-container
dnf5 install -y blueman

/ctx/github-release-install.sh sigstore/cosign x86_64

CSFG=/usr/lib/systemd/system-generators/coreos-sulogin-force-generator
curl -sSLo ${CSFG} https://raw.githubusercontent.com/coreos/fedora-coreos-config/refs/heads/stable/overlay.d/05core/usr/lib/systemd/system-generators/coreos-sulogin-force-generator
chmod +x ${CSFG}

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

dnf5 -y copr enable sed4906/candela
dnf5 -y install wscreensaver swaylock-plugin quester gram systemcontrol uupd
dnf5 -y copr disable sed4906/candela

#dnf5 -y copr enable ublue-os/packages
#dnf5 install -y uupd
#dnf5 -y copr disable ublue-os/packages

dnf5 -y copr enable peterwu/iosevka
dnf5 install -y iosevka-fonts
dnf5 -y copr disable peterwu/iosevka

dnf5 -y copr enable wezfurlong/wezterm-nightly
dnf5 install -y wezterm
dnf5 -y copr disable wezfurlong/wezterm-nightly

echo "application/vnd.flatpak.ref=io.github.kolunmi.Bazaar.desktop" >> /usr/share/applications/mimeapps.list

#### Example for enabling a System Unit File
systemctl enable podman.socket

systemctl enable brew-setup.service
systemctl enable flatpak-preinstall.service
systemctl enable firefox-copy-policies.service
systemctl enable flatpak-nuke-fedora.service
systemctl enable uupd.timer
systemctl disable flatpak-add-fedora-repos.service

systemctl --global enable mpd.service
systemctl --global enable mpDris2.service

systemctl --global add-wants niri.service mako.service
systemctl --global add-wants niri.service waybar.service
systemctl --global add-wants niri.service swaybg.service
systemctl --global add-wants niri.service swayidle.service

dnf5 -y install pcsc-lite

# Copy Files to Container
cp -avf "/ctx/system_files/overwrites"/. /

IMAGE_PRETTY_NAME="Candela"
VERSION="$(date -u +%Y%m%d)"
CODE_NAME="International System of Units"

sed -i "s|^PRETTY_NAME=.*|PRETTY_NAME=\"${IMAGE_PRETTY_NAME} (${VERSION})\"|" /usr/lib/os-release
sed -i "s|^NAME=.*|NAME=\"$IMAGE_PRETTY_NAME\"|" /usr/lib/os-release
sed -i "s|^VERSION_CODENAME=.*|VERSION_CODENAME=\"$CODE_NAME\"|" /usr/lib/os-release

KERNEL_VERSION=$(rpm -q --queryformat="%{evr}.%{arch}" kernel-core)

# Ensure Initramfs is generated
export DRACUT_NO_XATTR=1
/usr/bin/dracut --no-hostonly --kver "${KERNEL_VERSION}" --reproducible -v --add "ostree fido2 tpm2-tss pkcs11 pcsc" -f "/lib/modules/${KERNEL_VERSION}/initramfs.img"
chmod 0600 "/lib/modules/${KERNEL_VERSION}/initramfs.img"

mkdir /nix

rm -rf /usr/etc
