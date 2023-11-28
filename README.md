# qemu-user-static

Inspired by [multiarch/qemu-user-static](https://github.com/multiarch/qemu-user-static/tree/master).

It is a docker image that contains the qemu-user-static binary, based on ubuntu.

Support host architectures not only x86_64, show as below:

- x86_64
- armhf
- aarch64
- riscv64

Here are examples with Docker

## Get Started

```
$ uname -m
aarch64

$ docker run --rm -it xfan1024/openeuler:23.03-riscv64 uname -m
exec /usr/bin/uname: exec format error
libcontainer: container start initialization failed: exec /usr/bin/uname: exec format error

$ docker run --rm --privileged xfan1024/qemu-user-static

$ docker run --rm -it xfan1024/openeuler:23.03-riscv64 uname -m
riscv64
```
