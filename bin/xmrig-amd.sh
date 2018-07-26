#!/usr/bin/env bash

CRYPTO=cryptonight
POOL=
WALLET=

docker run -d \
  --device /dev/kfd \
#  --device /dev/dri \
#  --env-file /etc/xmrig-amd.vars \
  --name xmrig-amd calvintam236/xmrig-amd:amd \
  -k \
  -a ${CRYPTO} \
  -o ${POOL} \
  -u ${WALLET}
