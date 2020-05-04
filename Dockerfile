FROM ubuntu:bionic

# Used for tzdata, otherwise tzdata will block until we answer (default: UTC, is fine as a timezone)
ARG DEBIAN_FRONTEND=noninteractive

# Set the workdir
WORKDIR /root

RUN apt-get update && apt-get install -q -y tzdata git lsb-core sudo python openjdk-8-jdk-headless libncurses5

RUN update-java-alternatives --set java-1.8.0-openjdk-amd64

RUN git clone --depth 1 https://github.com/kiwibrowser/src

RUN git clone --depth 1 https://github.com/kiwibrowser/dependencies .cipd

RUN cp .cipd/.gclient .

RUN cp .cipd/.gclient_entries .

WORKDIR /root/src

RUN bash install-build-deps.sh --no-chromeos-fonts

RUN build/linux/sysroot_scripts/install-sysroot.py --arch=i386

RUN build/linux/sysroot_scripts/install-sysroot.py --arch=amd64

WORKDIR /root

RUN git clone --single-branch --depth 1 https://chromium.googlesource.com/chromium/tools/depot_tools.git

RUN PATH=/root/depot_tools:$PATH gclient runhooks
