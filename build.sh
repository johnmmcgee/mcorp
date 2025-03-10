#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf install -y \
    ansible \
    btop \
    fira-code-fonts \
    firefox \
    gh \
    lsd \
    netcat \
    nmap \
    papers \
    rclone \
    stow \
    strace

# Edge Stuff
rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[edge-yum]\nname=edge-yum\nbaseurl=https://packages.microsoft.com/yumrepos/edge\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | tee /etc/yum.repos.d/edge.repo
dnf install -y microsoft-edge-stable



# enable stuff
systemctl enable dconf-update.service 
systemctl enable rpm-ostree-countme.timer
systemctl enable podman.socket 
