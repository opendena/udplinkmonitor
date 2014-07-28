#!/bin/bash

MYDIR=$(dirname $0)

for i in $(ls $MYDIR/hitScript.d)
do
 	bash $MYDIR/hitScript.d/$i "$@" 
done
