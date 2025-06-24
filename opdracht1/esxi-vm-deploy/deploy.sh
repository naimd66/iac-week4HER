#!/bin/bash

OVA_PATH="/home/student/focal-server-cloudimg-amd64.ova"
ESXI_HOST="192.168.100.2"
ESXI_USER="root"
ESXI_PASS="Welkom01!"
DATASTORE="datastore1"
NETWORK="VM Network"

echo "[INFO] Deploying webvm..."
ovftool \
--acceptAllEulas \
--noSSLVerify \
--name=webvm \
--datastore="$DATASTORE" \
--net:"VM Network"="$NETWORK" \
--prop:hostname=webvm \
--prop:ip=192.168.100.31 \
--prop:gateway=192.168.100.1 \
--prop:netmask=255.255.255.0 \
--prop:dns=8.8.8.8 \
--prop:user-data="$(base64 -w 0 cloud-init-web.yaml)" \
"$OVA_PATH" \
"vi://$ESXI_USER:$ESXI_PASS@$ESXI_HOST"

echo "[INFO] Deploying dbvm..."
ovftool \
--acceptAllEulas \
--noSSLVerify \
--name=dbvm \
--datastore="$DATASTORE" \
--net:"VM Network"="$NETWORK" \
--prop:hostname=dbvm \
--prop:ip=192.168.100.32 \
--prop:gateway=192.168.100.1 \
--prop:netmask=255.255.255.0 \
--prop:dns=8.8.8.8 \
--prop:user-data="$(base64 -w 0 cloud-init-db.yaml)" \
"$OVA_PATH" \
"vi://$ESXI_USER:$ESXI_PASS@$ESXI_HOST"