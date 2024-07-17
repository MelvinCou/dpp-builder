# dpp-builder

Docker builder for [dpp library](https://github.com/brainboxdotcc/DPP).

How tags works: `{VERSION}-{LINUX}[-{VOICE_SUPPORT}]`, some examples:

- `master-ubuntu`: master branch (built weekly) on ubuntu
- `10.0.29-alpine-no-voice`: built from tag 10.0.29 for alpine without voice support

Simple usage:

## Ubuntu

```dockerfile
ARG DPP_VERSION=10.0.29
FROM hadeath/dpp-builder:$DPP_VERSION-ubuntu as builder

COPY . .

RUN gcc main.cpp -ldpp -I/usr/local/include

FROM ubuntu
ARG DPP_VERSION

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
```

## Alpine

```dockerfile
ARG DPP_VERSION=10.0.29
FROM hadeath/dpp-builder:$DPP_VERSION-alpine as builder

COPY . .

RUN gcc main.cpp -ldpp -I/usr/local/include

FROM alpine
ARG DPP_VERSION

RUN apk add -U --no-cache \
        ca-certificates \
        openssl \
        libsodium \
        libstdc++ \
        opus \
        zlib

COPY --from=builder /a.out /a.out
COPY --from=builder /usr/local/lib/libdpp.so.* /usr/lib
```
