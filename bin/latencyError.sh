#!/bin/bash

echo $1 $2
if [ "$2" != "100" ] ;
then
 STATUS=NOK
else
 STATUS=OK
fi
/usr/bin/curl http://localhost:3000/udplinkmonitor/linkSetInfo?id=$1\&status=$STATUS\&reason=$2
