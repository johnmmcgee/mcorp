#!/bin/bash

set -ouex pipefail

# fix /opt and /usr/local
if [[ ${IMAGE} =~ bluefin|bazzite ]]; then
    # ensure /opt and /usr/local are proper
    if [[ ! -h /opt ]]; then
        rm -fr /opt
	mkdir -p /var/opt
	ln -s /var/opt /opt
    fi
    if [[ ! -h /usr/local ]]; then
        rm -fr /usr/local
	ln -s /var/usrlocal /usr/local
    fi
fi

# this installs a package from fedora repos
dnf install -y \
    ansible \
    btop \
    ccache \
    fira-code-fonts \
    firefox \
    gh \
    git \
    libvirt \
    lm_sensors \
    lsd \
    make \
    netcat \
    nerd-fonts \
    nmap \
    papers \
    pipx \
    powerline-fonts \
    rclone \
    stow \
    strace \
    tmux \
    virt-manager

# Edge
rpm --import https://packages.microsoft.com/keys/microsoft.asc
# VSCode because it's still better for a lot of things
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

# Chezmoi
/tmp/github-release-install.sh twpayne/chezmoi x86_64

# enable stuff
systemctl enable dconf-update.service 
systemctl enable rpm-ostree-countme.timer
systemctl enable podman.socket 
