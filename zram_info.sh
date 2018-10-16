#!/bin/bash

sum_compr=0
sum_orig=0

divisor=$(( 1024 * 1024 ))

devices=$( ls /sys/block/ | grep zram )

for i in ${devices} ; do
    compr=$( cat /sys/block/${i}/compr_data_size )
    orig=$( cat /sys/block/${i}/orig_data_size )
    max=$( cat /sys/block/${i}/disksize )
    
    (( sum_compr += compr ))
    (( sum_orig += orig ))
    
    echo "${i}: $(( compr / divisor )) MiB / $(( orig / divisor )) MiB / $(( max / divisor )) MiB   (${compr} / ${orig})";
done

echo "total: $(( sum_compr / divisor )) MiB / $(( sum_orig / divisor )) MiB"

swap=( $( free -m | grep "^Swap:" ) )
mem=( $(free -m | grep "^-/+\sbuff") )

echo "swap: ${swap[2]} MiB"
echo "mem: ${mem[2]} MiB used + ${mem[3]} MiB free"




