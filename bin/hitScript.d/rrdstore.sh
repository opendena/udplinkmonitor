#!/bin/bash
DATASTORE=$1

if [ ! -d $DATASTORE/$2 ] ; then
	mkdir -p $DATASTORE/$2 
fi

FILENAME=$DATASTORE/$2/$1.rrd

if [ ! -f $FILENAME ] ; then 
	rrdtool create $FILENAME \
        	--start $(date +%s) \
	        --step 5 \
        	DS:packetok:GAUGE:10:0:100 \
	        DS:latency:GAUGE:10:0:3600 \
        	RRA:LAST:0.5:1:6307200
fi

rrdtool update $FILENAME N:$2:$3
