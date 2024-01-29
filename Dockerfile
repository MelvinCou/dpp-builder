FROM ubuntu:24.04
ARG BUILD_VOICE_SUPPORT=ON
ARG CMAKE_BUILD_TYPE=Release
ARG DPP_VERSION

# Install dependencies
RUN apt-get -qqy update && \
    apt-get install --no-install-recommends -qqy \
        ca-certificates \
        libssl-dev \
        zlib1g-dev \
        libsodium-dev \
        libopus-dev \
        cmake \
        pkg-config \
        g++ \
        gcc \
        git\
        make 1>/dev/null && \
    rm -rf /var/lib/apt/lists && \
    git clone https://github.com/brainboxdotcc/DPP.git
# Build dpp
WORKDIR /DPP/build
RUN git checkout tags/v${DPP_VERSION} && \
    cmake .. -DDPP_BUILD_TEST=OFF -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DBUILD_VOICE_SUPPORT=${BUILD_VOICE_SUPPORT} && \
    make -j$(nproc) && \
    make install && \
# Sources are now useless
    rm -rf /DPP
