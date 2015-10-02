#!/usr/bin/env bash

now=$(date +%Y.%m.%d-%H.%M.%S)
echo now is $now 

outfile=router-$now.html
echo output file with router info is $outfile

curl -k -sSSL  https://192.168.1.254 > $outfile

count_known=$(grep col2 $outfile | wc -l)                    # known connections
count_activ=$(grep col2 $outfile | grep '>on<' | wc -l)      # active connections
count_inact=$(grep col2 $outfile | grep '>off<' | wc -l)     # inactive connections
count_ether=$(grep col2 $outfile | grep '>Ethernet' | wc -l) # hard-wire connections
count_wi_fi=$(grep col2 $outfile | grep '>Wireless' | wc -l) # wf-fi connections

check_total=$(expr $count_activ + $count_inact)
echo check_total = $check_total
[[ $count_known == $check_total ]] && check_known_flag='OK' || check_known_flag='BAD'

check_total=$(expr $count_ether + $count_wi_fi)
echo check_total = $check_total
[[ $count_known == $check_total ]] && check_types_flag='OK' || check_types_flag='BAD'

echo
echo The results are in:
echo
echo '*' $count_known known connections  [$check_known_flag] [$check_types_flag]
echo
echo '*' $count_activ active connections
echo '*' $count_inact inactive connections
echo
echo '*' $count_ether hard-wire connections
echo '*' $count_wi_fi wf-fi connections
echo
