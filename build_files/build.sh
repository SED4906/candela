#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf5 install -y sddm niri alacritty fuzzel waybar mako xwayland-satellite swaybg swayidle swaylock network-manager-applet

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

cat > /usr/lib/sddm/sddm.conf.d/00-hide-nix-build-users.conf << EOF
[Users]
MaximumUid=1999
EOF

#### Example for enabling a System Unit File

systemctl enable podman.socket

mkdir /nix
