FILENAME=/tmp/$1.rrd
rrdtool graph /tmp/$1.png  \
	--title 'Max value for graph is' \
        --start $(date --date "2013-08-22 15:20:00" +%s) \
        --end $(date --date "2013-08-22 15:30:00" +%s) \
		--color MGRID#80C080				  \
		--color GRID#808020				  \
		--color FRAME#808080				  \
		--color ARROW#FFFFFF				  \
		--color SHADEA#404040				  \
		--color SHADEB#404040				  \
	HRULE:100#444444 \
	DEF:packetok=$FILENAME:packetok:LAST  \
        DEF:latency=$FILENAME:latency:LAST  \
        CDEF:ok=packetok,99,GT,packetok,0,IF                 \
	CDEF:nok=packetok,99,GT,0,packetok,IF                  \
	AREA:ok#33AA33:"OK"               \
	AREA:nok#FF0000:"NOK"        	\
	LINE1:latency#0000FF:"Latency"


cp /tmp/$1.png /vagrant/www

