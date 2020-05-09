#!/bin/bash
$mailbox="insertmailboxhere"
dfpercentage=$(df | awk '{split($0, a, " "); print a[5]}'| sed 's/%//g')
dfpercentage=($dfpercentage)
dfname=$(df | awk '{split($0, a, " "); print a[1]}')
length=$(echo $dfname | wc -w)
dfname=($dfname)
counter=1
while [ $counter -le $length ]
do
	name=${dfname[$counter]}
	percentage=${dfpercentage[$counter]}
	if [ $(($percentage)) -gt 90 ]
	then
		logger Excessive disk space is being used on $name
		mail -s "Excessive Disk space used on $name" $mailbox < diskusage.txt
	fi
	((counter++))
done
