ARG UBUNTU_VERSION=18.04
ARG APLINE_VERSION=3.7


FROM ubuntu:${UBUNTU_VERSION} AS build

RUN apt-get -y update && apt-get -y upgrade
RUN apt-get -y install git build-essential cmake libuv1-dev libmicrohttpd ocl-icd-opencl-dev

RUN git clone https://github.com/xmrig/xmrig-amd.git
RUN cd xmrig && git checkout $(git describe --abbrev=0 --tags) && mkdir build

WORKDIR xmrig/build
ENV CMAKE_OPTS '-DCMAKE_C_COMPILER=gcc-7 -DCMAKE_CXX_COMPILER=g++-7 -DWITH_AEON=OFF -DWITH_HTTPD=OFF'
RUN cmake .. ${CMAKE_OPTS} && make


FROM frolvlad/alpine-glibc:alpine-${ALPINE_VERSSION}

LABEL maintainer='docker@merxnet.io'
RUN apk add xf86-video-amdgpu
COPY --from=build /xmrig/build/xmrig /usr/local/bin/xmrig

ENTRYPOINT ["xmrig"]
