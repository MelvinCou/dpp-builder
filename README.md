# dpp-builder

Unofficial docker builder for [dpp library](https://github.com/brainboxdotcc/DPP)

Simple usage:

```dockerfile
FROM hadeath/dpp-builder:10.0.29

COPY . .

RUN gcc main.cpp -ldpp -I/usr/local/include
```
