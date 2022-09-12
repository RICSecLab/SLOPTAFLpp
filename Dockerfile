FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN dpkg --add-architecture i386 &&\
    apt update -y &&\
    apt install -y libgsl-dev \
    git curl wget vim gdb silversearcher-ag unzip \
    libglib2.0-dev libpixman-1-dev libssl1.1 \
    python3 python3-dev python3-setuptools python3-pip python-is-python3 \
    zlib1g zlib1g:i386 \
    gcc-10 g++-10 gcc-10-plugin-dev gcc-10-multilib \
    automake ninja-build bison flex build-essential &&\
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 0 &&\
    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-10 0 &&\
    apt install -y lld-11 llvm-11 llvm-11-dev clang-11 libc++-11-dev libc++abi-11-dev &&\
    apt install -y gcc-$(gcc --version|head -n1|sed 's/.* //'|sed 's/\..*//')-plugin-dev \
                   libstdc++-$(gcc --version|head -n1|sed 's/.* //'|sed 's/\..*//')-dev

ENV LLVM_CONFIG=llvm-config-11

# build (patched) AFL++
RUN cd / && git clone --depth 1 --branch havoc_mab https://github.com/RICSecLab/SLOPTAFLpp &&\
    cd /SLOPTAFLpp &&\
    export CC=gcc-10 &&\
    export CXX=g++-10 &&\
    make clean && \
    make source-only -j$(nproc) && make install && make clean &&\
    cd / &&\
    which afl-fuzz &&\
    mv /SLOPTAFLpp/PUTs /FuzzbenchPUTs
WORKDIR /FuzzbenchPUTs
