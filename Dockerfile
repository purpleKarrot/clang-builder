FROM ubuntu:24.04

RUN apt-get -qq update && \
    apt-get -qq install -y --no-install-recommends \
        apt-transport-https ca-certificates git ninja-build wget && \
    rm -rf /var/lib/apt/lists/*

RUN bash -c "$(wget -O - https://apt.kitware.com/kitware-archive.sh)" && \
    apt-get -qq update && \
    apt-get -qq install -y --no-install-recommends cmake && \
    rm -rf /var/lib/apt/lists/*

RUN echo "deb http://apt.llvm.org/noble/ llvm-toolchain-noble main" \
        > /etc/apt/sources.list.d/llvm.list && \
    wget -qO /etc/apt/trusted.gpg.d/llvm.asc \
        https://apt.llvm.org/llvm-snapshot.gpg.key && \
    apt-get -qq update && \
    apt-get -qq install -y --no-install-recommends -t llvm-toolchain-noble \
        clang clang-tidy clang-format lld libc++-dev libc++abi-dev && \
    for f in /usr/lib/llvm-*/bin/*; do ln -sf "$f" /usr/bin; done && \
    ln -sf clang /usr/bin/cc && \
    ln -sf clang /usr/bin/c89 && \
    ln -sf clang /usr/bin/c99 && \
    ln -sf clang++ /usr/bin/c++ && \
    ln -sf clang++ /usr/bin/g++ && \
    rm -rf /var/lib/apt/lists/*

# Those are build and test dependencies for CMake
RUN apt-get -qq update && \
    apt-get -qq install -y --no-install-recommends \
        dpkg-dev file libssl-dev make && \
    rm -rf /var/lib/apt/lists/*
