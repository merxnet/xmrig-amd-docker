ARG UBUNTU_VERSION=18.04

FROM ubuntu:${UBUNTU_VERSION} AS build

ENV CMAKE_OPTS '-DCMAKE_C_COMPILER=gcc-7 -DCMAKE_CXX_COMPILER=g++-7 -DWITH_AEON=OFF -DWITH_HTTPD=OFF'

RUN apt-get -y update && apt-get -y upgrade
RUN apt-get -y install git build-essential cmake libuv1-dev libmicrohttpd-dev ocl-icd-opencl-dev

RUN git clone https://github.com/xmrig/xmrig-amd.git
RUN cd xmrig-amd && git checkout $(git describe --abbrev=0 --tags) && mkdir build

WORKDIR xmrig-amd/build
RUN cmake .. ${CMAKE_OPTS} && make


FROM ubuntu:${UBUNTU_VERSION}

LABEL maintainer='docker@merxnet.io'

ENV AMDGPU_VERSION 18.20-606296

RUN apt-get -y update && apt-get -y upgrade
RUN apt-get -y install ca-certificates curl xz-utils

RUN curl -L -O --referer https://support.amd.com \
    https://www2.ati.com/drivers/linux/ubuntu/18.04/amdgpu-pro-${AMDGPU_VERSION}.tar.xz \
    && tar -xvJf amdgpu-pro-${AMDGPU_VERSION}.tar.xz && rm amdgpu-pro-${AMDGPU_VERSION}.tar.xz

RUN ./amdgpu-pro-${AMDGPU_VERSION}/amdgpu-install -y --headless --opencl=legacy,rocm \
    && rm -r amdgpu-pro-${AMDGPU_VERSION}

RUN apt-get -y remove ca-certificates curl xz-utils
COPY --from=build /xmrig-amd/build/xmrig-amd /usr/local/bin/xmrig-amd

ENTRYPOINT ["xmrig-amd"]