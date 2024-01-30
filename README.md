# dpp-builder

Unofficial docker builder for [dpp library](https://github.com/brainboxdotcc/DPP)

Simple usage:

```dockerfile
ARG DPP_VERSION=10.0.29
FROM hadeath/dpp-builder:$DPP_VERSION as builder

COPY . .

RUN gcc main.cpp -ldpp -I/usr/local/include

FROM ubuntu
ARG DPP_VERSION

COPY --from=builder /a.out /a.out
COPY --from=builder /usr/local/lib/libdpp.so.$DPP_VERSION /usr/local/lib/libdpp.so.$DPP_VERSION
```
