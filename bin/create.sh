FILENAME=/tmp/ulms
rrdtool create $FILENAME.rrd \
        --start $(date +%s) \
        --step 5 \
        DS:packetok:GAUGE:10:0:100 \
        DS:latency:GAUGE:10:0:3600 \
        RRA:LAST:0.5:1:6307200

