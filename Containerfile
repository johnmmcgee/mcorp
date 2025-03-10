FROM ghcr.io/ublue-os/bluefin:stable-daily

COPY build.sh /extras/* /tmp/

RUN mkdir -p /var/lib/alternatives && \
    chmod +x /tmp/*.sh && \
    /tmp/build.sh && \
    ostree container commit
    
