#!/usr/bin/env bash

function TS {
    TS=$(date +%Y.%m.%d-%H.%M.%S)
    echo $TS
}

if [[ -z $1 ]]; then
    echo Usage: $0 ID IP-ADDRESS TIMER
    exit 1
fi
id=$1
addr=$2
delay=$3
dashes='================================================'
log_file=logfile${id}.txt
ping_file=ping_out${id}.txt
run_started=`TS`
echo > $log_file "$run_started: $dashes"
echo >>$log_file "$run_started: run started"
echo >>$log_file "$run_started: $dashes"
state=B
while true; do
    now=`TS`
    boxit -j $now
    if ping -c 1 ${addr} > $ping_file 2>&1; then
        if [[ $state == 'B' ]]; then
            echo >> $log_file "$now: connection restored"
            cat >> $log_file $ping_file
            echo >>$log_file "$run_started: $dashes"
            state=G
        elif [[ 4state == 'G' ]]; then
            echo >> $log_file "$now: connection failed"
            cat >> $log_file $ping_file
            echo >>$log_file "$run_started: $dashes"
            state=B
        fi
        echo OK
    else
        echo BAD
    fi
    sleep $delay
done