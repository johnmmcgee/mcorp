FROM ghcr.io/ublue-os/bluefin:latest

COPY build.sh github-release-install.sh /tmp/

RUN mkdir -p /var/lib/alternatives && \
    chmod +x /tmp/build.sh && \
    chmod +x /tmp/github-release-install.sh && \
    /tmp/build.sh && \
    ostree container commit
    
