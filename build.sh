#!/bin/bash

set -ouex pipefail

# fix /opt and /usr/local
if [[ ! -h /opt ]]; then
    rm -fr /opt
    mkdir -p /var/opt
    ln -s /var/opt /opt
fi
if [[ ! -h /usr/local ]]; then
    rm -fr /usr/local
	ln -s /var/usrlocal /usr/local
fi

# ublue-os copr packages
#dnf -y copr enable ublue-os/staging

# MS Repo key
rpm --import https://packages.microsoft.com/keys/microsoft.asc

# Edge
mkdir -p /var/opt/microsoft
tee /etc/yum.repos.d/vscode.repo <<'EOF'
[edge]
name=Edge Browser
baseurl=https://packages.microsoft.com/yumrepos/edge
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF
dnf install -y microsoft-edge-stable

# VSCode
tee /etc/yum.repos.d/vscode.repo <<'EOF'
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF
dnf install -y code

# this installs a package from fedora repos
dnf install -y \
    ansible \
    btop \
    ccache \
    gnome-shell-extension-no-overview \
    guestfs-tools \
    firefox \
    gh \
    git \
    libvirt \
    lm_sensors \
    lsd \
    make \
    netcat \
    nmap \
    papers \
    pipx \
    qemu-img \
    qemu-kvm \
    rclone \
    stow \
    strace \
    tmux \
    virt-manager \
    xorriso

# Chezmoi
/tmp/github-release-install.sh twpayne/chezmoi x86_64

# Nerd fonts
/tmp/nerd-font-installer.sh BitstreamVeraSansMono
/tmp/nerd-font-installer.sh CascadiaCode
/tmp/nerd-font-installer.sh Hack
/tmp/nerd-font-installer.sh IntelOneMono
/tmp/nerd-font-installer.sh JetBrainsMono
/tmp/nerd-font-installer.sh Meslo
/tmp/nerd-font-installer.sh Terminus
/tmp/nerd-font-installer.sh UbuntuMono

# enable stuff
systemctl enable dconf-update.service 
systemctl enable rpm-ostree-countme.timer
systemctl enable podman.socket 
