#!/bin/bash

set -ouex pipefail

# Copy Files to Container
rsync -rvKl /ctx/system_files/shared/ /

### Install packages

# use negativo17 for 3rd party packages with higher priority than default
if ! grep -q fedora-multimedia <(dnf5 repolist); then
    # Enable or Install Repofile
    dnf5 config-manager setopt fedora-multimedia.enabled=1 ||
        dnf5 config-manager addrepo --from-repofile="https://negativo17.org/repos/fedora-multimedia.repo"
fi
# Set higher priority
dnf5 config-manager setopt fedora-multimedia.priority=90

# Add Flathub to the image for eventual application
mkdir -p /etc/flatpak/remotes.d/
curl --retry 3 -Lo /etc/flatpak/remotes.d/flathub.flatpakrepo https://dl.flathub.org/repo/flathub.flatpakrepo

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1
dnf5 -y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
dnf5 -y install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
# this installs a package from fedora repos
dnf5 install -y --setopt=install_weak_deps=false niri
dnf5 install -y sddm nwg-launchers waybar mako xwayland-satellite swaybg swayidle swaylock network-manager-applet nautilus gvfs gvfs-fuse pavucontrol gnome-disk-utility xfce-polkit blueman mpd mpc mpdris2 kvantum qqc2-breeze-style qt6ct kwin xdg-user-dirs rsms-inter-vf-fonts google-crosextra-caladea-fonts wireplumber gnome-keyring xdg-desktop-portal-gnome xdg-desktop-portal-gtk

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

dnf5 -y copr enable sed4906/candela
dnf5 -y install wscreensaver swaylock-plugin quester atychia gram systemcontrol
dnf5 -y copr disable sed4906/candela

dnf5 -y copr enable ublue-os/packages
dnf5 install -y uupd
dnf5 -y copr disable ublue-os/packages

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
systemctl enable flatpak-nuke-fedora.service
systemctl enable uupd.timer
systemctl disable flatpak-add-fedora-repos.service

systemctl --global enable atychiad.service
systemctl --global enable mpd.service
systemctl --global enable mpDris2.service

# Copy Files to Container
rsync -rvKl /ctx/system_files/overwrites/ /

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
