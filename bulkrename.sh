#!/bin/sh
BNAME=$(date -u +%s)
VERIF="/tmp/v_$BNAME"
ONAME="/tmp/o_$BNAME"
BNAME="/tmp/$BNAME"

ls -d $@ > $BNAME
cp $BNAME $ONAME
$EDITOR $BNAME

a=$(wc -l $BNAME | awk '{print $1}')
b=$(wc -l $ONAME | awk '{print $1}')
c=$([ $a -lt $b ]  && echo "$a" || echo "$b")

echo "# Following command will be executed. Is everything ok ?" >> $VERIF

for line in $(seq $c); do
	a=$(head -n $line $ONAME | tail -1)
	b=$(head -n $line $BNAME | tail -1)
	if [ $a != $b ]; then
		echo "mv $a $b" >> $VERIF
	fi
done 

$EDITOR $VERIF

sh $VERIF

rm -f $VERIF $ONAME $BNAME
