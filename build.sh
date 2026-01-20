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

# ghostty
dnf copr -y enable scottames/ghostty
dnf install -y ghostty
dnf copr -y disable scottames/gghostty

dnf copr -y enable dejan/lazygit
dnf install -y lazygit
dnf copr -y disable dejan/lazygit

dnf copr -y enable varlad/zellij
dnf install -y zellij
dnf copr -y disable varlad/zellij

# dnf remove packages
dnf remove -y \
    gnome-shell-extension-dash-to-dock \
    gnome-shell-extension-gsconnect \
    gnome-shell-extension-tailscale-gnome-qs \
    nano-default-editor \
    nautilus-gsconnect \
    tailscale \
    thunderbird

# MS Repo key
rpm --import https://packages.microsoft.com/keys/microsoft.asc

# Edge
mkdir -p /var/opt/microsoft

tee /etc/yum.repos.d/edge.repo <<'EOF'
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

dnf install -y code-1.101.2-1750797987.el8


# this installs a package from fedora repos
dnf install -y \
    ansible \
    ansible-lint \
    btop \
    ccache \
	direnv \
    gnome-shell-extension-no-overview \
    gnupg-pkcs11-scd \
    guestfs-tools \
    firefox \
    gh \
    intel-compute-runtime \
    intel-gpu-tools \
    keepassxc \
    kitty \
    libreoffice-icon-theme-papirus \
    libvirt \
    libvirt-daemon-kvm \
    libvirt-ssh-proxy \
    libvirt-nss \
    lsd \
    moby-engine \
    netcat \
    nmap \
    nss-tools \
    papers \
    papirus-icon-theme \
    pipx \
    podman-compose \
    qemu-img \
    qemu-kvm \
    stow \
    strace \
    trivy \
    vim-default-editor \
    virt-manager \
    xorriso \
	uv \
    yq

# Chezmoi
#sh /ctx/build_files/github-release-install.sh twpayne/chezmoi x86_64

# Nerd fonts
sh /ctx/build_files/nerd-font-installer.sh \
    CascadiaCode,\
    CascadiaMono,\
    Hack,\
    Monaspace

# Hacky manual stuff
rsync -rvKL /ctx/system_files/ /
fc-cache -f /usr/share/fonts/inputmono


# disable repos
repos=()
mapfile -t repos <<<"$(find /etc/yum.repos.d/*.repo)"
for repo in "${repos[@]}"; do
    [ "$repo" != "/etc/yum.repos.d/fedora.repo" ] && \
    sed -i 's@enabled=1@enabled=0@g' "$repo"
done

dnf clean all
rm -rf /tmp/*
rm -rf /var/*
mkdir -p /tmp
mkdir -p /var/tmp && chmod -R 1777 /var/tmp

# enable stuff
systemctl enable dconf-update.service
systemctl enable rpm-ostree-countme.timer
systemctl enable podman.socket
