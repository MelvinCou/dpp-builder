# dpp-builder

Docker builder for [dpp library](https://github.com/brainboxdotcc/DPP).

How tags works: `{VERSION}-{LINUX}[-{VOICE_SUPPORT}]`, some examples:

- `master-ubuntu`: master branch (built weekly) on ubuntu
- `10.0.29-alpine-no-voice`: built from tag 10.0.29 for alpine without voice support

## Purposes of this repository

1. Bring lighter images than the one provided by dpp

```
REPOSITORY            TAG             IMAGE ID       CREATED          SIZE
hadeath/dpp-builder   master-alpine   5d28a621691c   22 minutes ago   298MB
hadeath/dpp-builder   master-ubuntu   fc94c80e5a5a   31 minutes ago   535MB
brainboxdotcc/dpp     latest          4ebe87ba8578   11 hours ago     1.01GB
```

2. Support several pleteforms (currently ubuntu and alpine)

3. Bring tagged versions

## Ubuntu

```dockerfile
FROM hadeath/dpp-builder:10.0.29-ubuntu as builder

COPY . .

RUN gcc main.cpp -ldpp -I/usr/local/include

FROM ubuntu:24.04

RUN apt-get -qqy update && \
    apt-get install --no-install-recommends -qqy \
        ca-certificates \
        libssl3 \
        zlib1g \
        libsodium23 \
        libopus0 && \
    rm -rf /var/lib/apt/lists

COPY --from=builder /a.out /a.out
COPY --from=builder /usr/local/lib/libdpp.so.* /usr/lib

CMD /a.out
```

## Alpine

### From scratch with GCC

```dockerfile
FROM hadeath/dpp-builder:master-alpine as builder

COPY . .

RUN gcc main.cpp -ldpp -I/usr/local/include

FROM alpine:3.20

RUN apk add -U --no-cache \
        ca-certificates \
        openssl \
        libsodium \
        libstdc++ \
        opus \
        zlib

COPY --from=builder /a.out /a.out
COPY --from=builder /usr/local/lib/libdpp.so.* /usr/lib

CMD /a.out
```

### With CMake

```dockerfile
FROM hadeath/dpp-builder:master-alpine AS builder

COPY . .

# Build
WORKDIR /build
RUN cmake -DCMAKE_BUILD_TYPE=Release .. && \
    make -j$(nproc)

FROM alpine:3.20

RUN apk add -U --no-cache \
        ca-certificates \
        openssl \
        libsodium \
        libstdc++ \
        opus \
        zlib

# Copy files (modify path consedering the executable name)
COPY --from=builder /build/YOUR_PROJECT_NAME /YOUR_PROJECT_NAME
COPY --from=builder /usr/local/lib/libdpp.so.* /usr/lib

# Run
CMD /YOUR_PROJECT_NAME
```
