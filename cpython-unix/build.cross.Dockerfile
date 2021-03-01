# Debian Stretch.
FROM debian@sha256:d0b7b71db141cedc48e1c2807d12b199ffd7ffe75baf272a34c37480dc2159d1
MAINTAINER Gregory Szorc <gregory.szorc@gmail.com>

RUN groupadd -g 1000 build && \
    useradd -u 1000 -g 1000 -d /build -s /bin/bash -m build && \
    mkdir /tools && \
    chown -R build:build /build /tools

ENV HOME=/build \
    SHELL=/bin/bash \
    USER=build \
    LOGNAME=build \
    HOSTNAME=builder \
    DEBIAN_FRONTEND=noninteractive

CMD ["/bin/bash", "--login"]
WORKDIR '/build'

RUN for s in debian_stretch debian_stretch-updates debian-security_stretch/updates; do \
      echo "deb http://snapshot.debian.org/archive/${s%_*}/20210223T023121Z/ ${s#*_} main"; \
    done > /etc/apt/sources.list && \
    ( echo 'quiet "true";'; \
      echo 'APT::Get::Assume-Yes "true";'; \
      echo 'APT::Install-Recommends "false";'; \
      echo 'Acquire::Check-Valid-Until "false";'; \
      echo 'Acquire::Retries "5";'; \
    ) > /etc/apt/apt.conf.d/99cpython-portable

RUN apt-get update

# Host building.
RUN apt-get install \
    gcc \
    libc6-dev \
    libffi-dev \
    make \
    patch \
    patchelf \
    perl \
    pkg-config \
    tar \
    xz-utils \
    unzip \
    zlib1g-dev

# Cross-building.
RUN apt-get install \
    gcc-aarch64-linux-gnu \
    gcc-arm-linux-gnueabi \
    gcc-arm-linux-gnueabihf \
    libc6-dev-arm64-cross \
    libc6-dev-armel-cross \
    libc6-dev-armhf-cross