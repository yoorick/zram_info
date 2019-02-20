#!/bin/bash

sum_compr=0
sum_orig=0

function to_mib() {
    local size_in_bytes=$1
    echo "$(( size_in_bytes / (1024 * 1024) ))"
}

devices=$( ls /sys/block/ | grep zram )

echo 'Device: Compressed Size / Original Size / Max Size   (Compression Ratio)'

for i in ${devices} ; do

    compr=$(< /sys/block/${i}/compr_data_size )
    orig=$(< /sys/block/${i}/orig_data_size )
    max=$(< /sys/block/${i}/disksize )

    (( sum_compr += compr ))
    (( sum_orig += orig ))

    compr_mib=$( to_mib "${compr}" )
    orig_mib=$( to_mib "${orig}" )
    max_mib=$( to_mib "${max}" )

    (( orig > 0 )) && ratio=$(( 100 * compr / orig )) || ratio='N/A'

    echo "${i}: ${compr_mib} MiB / ${orig_mib} MiB / ${max_mib} MiB   (${ratio} %)";

done

sum_compr_mib=$( to_mib "${sum_compr}" )
sum_orig_mib=$( to_mib "${sum_orig}" )

echo "Total: ${sum_compr_mib} MiB / ${sum_orig_mib} MiB"

swap=( $( free -m | grep "^Swap:" ) )
mem=( $(free -m | grep "^-/+\sbuff") )

echo "Swap: ${swap[2]} MiB"
echo "Memory: ${mem[2]} MiB used + ${mem[3]} MiB free"




