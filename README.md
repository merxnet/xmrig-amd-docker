# Dockerized XMRig (AMD GPU) Monero miner

[![GitHub Release](https://img.shields.io/github/release/merxnet/xmrig-amd-docker/all.svg)](https://github.com/merxnet/xmrig-amd-docker/releases)
[![GitHub Release Date](https://img.shields.io/github/release-date-pre/merxnet/xmrig-amd-docker.svg)](https://github.com/merxnet/xmrig-amd-docker/releases)
[![Docker Pulls](https://img.shields.io/docker/pulls/merxnet/xmrig-amd.svg)](https://hub.docker.com/r/merxnet/xmrig-amd/)

The goal for this code is to create a modular and easy-to-use Docker image of the popular XMRig (AMD) Monero miner. Discover and support the source code [here](https://github.com/xmrig/xmrig-amd). There are also code repositories for "Dockerized" versions of the [CPU](https://github.com/merxnet/xmrig-cpu-docker) and [NVIDIA GPU](https://github.com/merxnet/xmrig-nvidia-docker) miners as well.

## Quickstart
The Docker image created by this code is conveniently available on [Docker Hub](https://hub.docker.com/r/merxnet/xmrig-amd/).
```
docker pull merxnet/xmrig-amd
```
To get started, install the AMD drivers (see the [Host Configuration](#Host-Configuration) section below). Once complete, all you need is a [wallet](https://getmonero.org/resources/user-guides/create_wallet.html) and a [mining pool](https://monero.org/services/mining-pools/) of your choice, such as [Moria](https://moriaxmr.com/). This information can be provided on the command line at run time:
```
docker run --device /dev/dri merxnet/xmrig-amd -o ${POOL} -u ${WALLET}
```
To get the most out of mining, be sure to check out the sections below as well as the documentation at the [source code's GitHub page](https://github.com/xmrig/xmrig-amd#usage).

## Usage
This Docker image can be treated just like the binary -- that is, you can provide any and all command line options directly. For example:
```
docker run -d --env-file /etc/xmrig-amd.env --device /dev/dri merxnet/xmrig-amd \
  -k \
  -a cryptonight \
  -o us.moriaxmr.com:7777 \
  -u ${WALLET} \
  --donate-level 1
```
On the other hand, if using a configuration file is more convenient, you can provide this at runtime to the container at the default location, such as:
```
docker run -d --device /dev/dri -v my_config.json:/usr/local/bin/config.json:ro merxnet/xmrig-amd
```
To help create an XMRig config file, use [this](https://config.xmrig.com/) website.

## Host Configuration
For AMD GPU mining, the host machine (i.e., the machine running `dockerd`) **MUST** have AMD drivers installed. This most often means AMDGPU or AMDGPU-PRO, but supposedly both the open source ATI drivers and the proprietary Catalyst drivers work as well. Check out [this Arch Linux Wiki page](https://wiki.archlinux.org/index.php/Xorg#AMD) for information on which driver to use. Most Linux distributions will have AMD drivers available in their corresponding package repositories; otherwise, refer to the [AMD Download Drivers](https://support.amd.com/en-us/download) site.

If not using the AMDGPU-PRO drivers, insure that you have the proper [OpenCL runtime](https://wiki.archlinux.org/index.php/GPGPU#OpenCL_Runtime) installed as well. This is pre-packed with the AMDGPU-PRO drivers only.

Note that you must pass the proper device to the Docker container at runtime -- in this case, that means using the `--device` flag to pass through the AMD card (most often `/dev/dri`).

If you encounter an error such as `CL_OUT_OF_HOST_MEMORY`, some environment variables may be required to run properly. Trying using some or all of the variables below:
```
GPU_FORCE_64BIT_PTR=1
GPU_USE_SYNC_OBJECTS=1
GPU_MAX_ALLOC_PERCENT=100
GPU_SINGLE_ALLOC_PERCENT=100
GPU_MAX_HEAP_SIZE=100
```

## Support
Feel free to fork and create pull requests or create issues. Feedback is always welcomed. One can also send donatations to the Monero wallet below.
```
43txUsLN5h3LUKpQFGsFsnRLCpCW7BvT2ZKacsfuqYpUAvt6Po8HseJPwY9ubwXVjySe5SmxVstLfcV8hM8tHg8UTVB14Tk
```
Thank you.
