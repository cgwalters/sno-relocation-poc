#!/bin/bash

if [ -z ${IMAGE+x} ]; then
	echo "Please set IMAGE"
	exit 1
fi

if [ -z ${VM_NAME+x} ]; then
	echo "Please set the VM_NAME"
	exit 1
fi

if [ -z ${NET_NAME+x} ]; then
	echo "Please set the NET_NAME"
	exit 1
fi

if [ -z ${SITE_CONFIG+x} ]; then
	echo "Please set the SITE_CONFIG"
	exit 1
fi

OS_VARIANT="rhel8.1"
RAM_MB="${RAM_MB:-16384}"
DISK_GB="${DISK_GB:-35}"
CPU_CORE="${CPU_CORE:-6}"

rm nohup.out
nohup virt-install \
    --connect qemu:///system \
    -n "${VM_NAME}" \
    -r "${RAM_MB}" \
    --vcpus "${CPU_CORE}" \
    --os-variant="${OS_VARIANT}" \
    --import \
    --network=network:${NET_NAME},mac=52:54:00:ee:42:e1 \
    --graphics=none \
    --disk "size=${DISK_GB},backing_store=${IMAGE}" \
    --cdrom "${SITE_CONFIG}" \
    --events on_reboot=restart \
    --boot hd,cdrom \
    --noautoconsole \
    --wait=-1 &

