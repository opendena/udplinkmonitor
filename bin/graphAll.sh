
for i in $(ls $1/*.rrd)
do
	FILENAME=$(basename $i)
	
	FULLNAME=$1/$(basename $i)
	rrdtool graph $FULLNAME.png  \
	    --title "From $(echo $FILENAME | sed 's/.rrd//') to $(hostname)" \
	    --start $(date +"%s" -d "1 hour ago") 		\
	    --end $(date +"%s") 						\
		--color MGRID#80C080				  		\
		--color GRID#808020				  			\
		--color FRAME#808080				  		\
		--color ARROW#FFFFFF				  		\
		--color SHADEA#404040				  		\
		--color SHADEB#404040				  		\
		HRULE:100#444444 							\
		DEF:packetok=$FULLNAME:packetok:LAST  		\
	        DEF:latency=$FULLNAME:latency:LAST  	\
	        CDEF:ok=packetok,99,GT,packetok,0,IF    \
		CDEF:nok=packetok,99,GT,0,packetok,IF       \
		AREA:ok#33AA33:"OK"               			\
		AREA:nok#FF0000:"NOK"        				\
		LINE1:latency#0000FF:"Latency"

done

cp /tmp/*.png /vagrant/www/

exit 0
