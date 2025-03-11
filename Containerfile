ARG BASE_IMAGE="bluefin"
ARG IMAGE="bluefin"
ARG TAG_VERSION="stable-daily"

FROM scratch AS ctx
COPY / /

FROM ghcr.io/ublue-os/${BASE_IMAGE}:${TAG_VERSION}

RUN --mount=type=bind,from=ctx,src=/,dst=/ctx \
    mkdir -p /var/lib/alternatives && \
    sh /ctx/build.sh && \
    ostree container commit
    
