#!/bin/bash

# Run it as ROOT user!

modprobe zram zram_num_devices=2

# size in MiB
SIZE=1536
SIZE_BYTES=$(( SIZE * 1024 * 1024 ))

echo ${SIZE_BYTES} > /sys/block/zram0/disksize
echo ${SIZE_BYTES} > /sys/block/zram1/disksize

mkswap /dev/zram0
mkswap /dev/zram1

swapon /dev/zram0 --priority 10 --discard
swapon /dev/zram1 --priority 10 --discard

