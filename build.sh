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

mv /var/opt/microsoft /usr/share/factory/microsoft

tee /usr/lib/tmpfiles.d/microsoft.conf <<'EOF'
L  /opt/microsoft  -  -  -  -  /usr/share/factory/microsoft
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
    keepassxc \
    kitty \
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
sh /ctx/build_files/github-release-install.sh filips123/PWAsForFirefox x86_64

# Nerd fonts
sh /ctx/build_files/nerd-font-installer.sh \
    Hack,\
    Inconsolata,\
    Monaspace,\
    RobotoMono,\
    SourceCodePro

# dnf remove packages
dnf remove -y \
    gnome-shell-extension-dash-to-dock \
    gnome-shell-extension-gsconnect \
    gnome-shell-extension-tailscale-gnome-qs \
    nautilus-gsconnect \
    tailscale \
    thunderbird

# Hacky manual stuff
rsync -rvKL /ctx/system_files/ /
fc-cache -f /usr/share/fonts/inputmono 


# disable all but fedora repos
sed -i "s@enabled=1@enabled=0@g" /etc/yum.repos.d/*.repo

# enable stuff
systemctl enable dconf-update.service 
systemctl enable rpm-ostree-countme.timer
systemctl enable podman.socket 
