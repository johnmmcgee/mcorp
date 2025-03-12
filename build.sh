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

mv /var/opt/microsoft /usr/lib/microsoft

tee /usr/lib/tmpfiles.d/microsoft.conf <<'EOF'
L  /opt/microsoft  -  -  -  -  /usr/lib/microsoft
EOF

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
sh /ctx/build_files/github-release-install.sh twpayne/chezmoi x86_64

# Nerd fonts
sh /ctx/build_files/nerd-font-installer.sh \
    Hack,\
    Inconsolata,\
    RobotoMono,\
    SourceCodePro

# Hacky manual stuff
rsync -rvKL /ctx/system_files/ /
fc-cache -f /usr/share/fonts/inputmono 

# enable stuff
systemctl enable dconf-update.service 
systemctl enable rpm-ostree-countme.timer
systemctl enable podman.socket 
