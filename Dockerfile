ARG UBUNTU_VERSION=bionic-20181112

FROM ubuntu:${UBUNTU_VERSION} AS build

ENV VERSION 'v2.8.6'
ENV CMAKE_OPTS '-DCMAKE_C_COMPILER=gcc-7 -DCMAKE_CXX_COMPILER=g++-7 -DWITH_AEON=OFF -DWITH_HTTPD=OFF'

RUN apt-get -y update && apt-get -y upgrade
RUN apt-get -y install git build-essential cmake libuv1-dev libmicrohttpd-dev ocl-icd-opencl-dev libssl-dev

RUN git clone https://github.com/xmrig/xmrig-amd.git
RUN cd xmrig-amd && git checkout ${VERSION} && mkdir build

WORKDIR xmrig-amd/build
RUN cmake .. ${CMAKE_OPTS} && make


FROM ubuntu:${UBUNTU_VERSION}

LABEL maintainer='docker@merxnet.io'

ENV UBUNTU=18.04
ENV AMDGPU_VERSION=18.20-606296

RUN apt-get -y update && apt-get -y upgrade && \
    apt-get -y install --no-install-recommends ca-certificates curl libssl1.1 xz-utils && \
    curl -L -O --referer https://support.amd.com https://www2.ati.com/drivers/linux/ubuntu/${UBUNTU}/amdgpu-pro-${AMDGPU_VERSION}.tar.xz && \
    tar -xvJf amdgpu-pro-${AMDGPU_VERSION}.tar.xz && \
    rm amdgpu-pro-${AMDGPU_VERSION}.tar.xz && \
    SUDO_FORCE_REMOVE=yes apt-get -y remove --purge ca-certificates curl xz-utils $(apt-mark showauto) && \
    ./amdgpu-pro-${AMDGPU_VERSION}/amdgpu-install -y --no-install-recommends --headless --opencl=legacy,rocm && \
    rm -r amdgpu-pro-${AMDGPU_VERSION} && \
    rm -rf /var/lib/apt/lists/* /usr/src/amdgpu-${AMDGPU_VERSION}/ /var/opt/amdgpu-pro-local/

COPY --from=build /xmrig-amd/build/xmrig-amd /usr/local/bin/xmrig-amd

ENTRYPOINT ["xmrig-amd"]
