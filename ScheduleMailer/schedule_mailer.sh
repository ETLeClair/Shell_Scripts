#!/bin/bash

#Get run directory
wd="$(pwd)/"
wdd="$(pwd)"
wdate=$(date +"%Y%m%d")

#Eval for proper mail address

mailregexbool=False
mailregexboolf=False
luregexbool=False
ltregexbool=False

function emailregex {
mregex="^[a-z0-9!#\$%&'*+/=?^_\`{|}~-]+(\.[a-z0-9!#$%&'*+/=?^_\`{|}~-]+)*@([a-z0-9]([a-z0-9-]*[a-z0-9])?\.)+[a-z0-9]([a-z0-9-]*[a-z0-9])?\$"
if [[ $mailaddress =~ $mregex ]] ; then
	mailregexbool=True
else
	mailregexbool=False
fi
}

function emailregexf {
mregex="^[a-z0-9!#\$%&'*+/=?^_\`{|}~-]+(\.[a-z0-9!#$%&'*+/=?^_\`{|}~-]+)*@([a-z0-9]([a-z0-9-]*[a-z0-9])?\.)+[a-z0-9]([a-z0-9-]*[a-z0-9])?\$"
if [[ $mailaddressf =~ $mregex ]] ; then
	mailregexboolf=True
else
	mailregexboolf=False
fi
}

#Eval for proper lengthtype

function evallt {
ltregex='\b[YMD]+\b'
if [[ $lengthtype =~ $ltregex ]] ; then
	ltregexbool=True
else
	ltregexbool=False
fi
}


#Eval for proper lengthunits
function evallu {
luregex='^[0-9]+$'
if [[ $lengthunits =~ $luregex ]] ; then
	luregexbool=True
else
	luregexbool=False
fi
}

#Eval for Proper date length
function evaldl {
if [ $lengthunits -gt 1 ] ; then
	plural=True
else
	plural=False
fi

if [ $lengthtype == "M" ] ; then
	if [ $plural == "True" ] ; then
		length="+ ${lengthunits} months"
	else
		length="+ 1 month"
	fi
elif [ $lengthtype == "Y" ] ; then
	if [ $plural == "True" ] ; then
		length="+ ${lengthunits} years"
	else
		length="+ 1 year"
	fi
elif [ $lengthtype == "D" ] ; then
	if [ $plural == "True" ] ; then
		length="+ ${lengthunits} days"
	else
		length="+ 1 day"
	fi
else
	echo "BAIL"
	exit 10
fi	
}

#Add Mail to queue
function addmail {
echo "$wdd/schedule_mailer.sh s $wdir/$udate"body.txt" $mailaddressf $mailaddress" >> $wdir/$udate.job
at now $length -f $wdir/$udate".job"
}


#Sending Mail
#function smail {

#}


#Main Functionality
if [ "$1" == "a" ]; then
	addmail
	echo "adding new mail to queue"
	exit 1
elif [ "$1" == "s" ]; then
	sendmail -f "$3" $4 < $2
	echo "Sending mail"
	exit 1
else
	udate=$(date +%s)
	echo "Welcome to the mail scheduler. Please let me know who I should mail"
	while [ $mailregexbool == False ]
	do
		read mailaddress
		emailregex
		if [ $mailregexbool == False ]; then
			echo "Not a valid mail address please enter a valid mail address"
		else
			echo "valid mail address"
		fi
	done
	echo "Who should this mail originate from? (From Address"
	while [ $mailregexboolf == False ]
	do
		read mailaddressf
		emailregexf
		if [ $mailregexboolf == False ]; then
			echo "Not a valid mail address please enter a valid mail address"
		else
			echo "valid mail address"
		fi
	done
	echo "What is the subject?"
	read subject
	echo "What should the message contain"
	read mailbody
	wdir=$wd$wdate
	mkdir $wdir
	cd $wdir
	echo "From: $mailaddressf" >> $udate"body.txt"
	echo "To: $mailaddress" >> $udate"body.txt"
	echo "Subject: $subject" >> $udate"body.txt"
	echo "" >> $udate"body.txt"
	echo $mailbody >> $udate"body.txt"
	echo 'What length of time when you want this to sent out. Have your answer be (Y)ears (M)onths (D)ays'
	while [ $ltregexbool == False ] 
	do
		read lengthtype
		evallt
		if [ $ltregexbool == False ]; then
			echo "Not a Valid length type. Have your answer be (Y)ears (M)onths (D)ays"
		else
			echo "valid length type"
		fi
	done
	echo "How many units of that date/time would you want. Please use an integer"
	while [ $luregexbool == False ]
	do
		read lengthunits
		evallu
		if [ $luregexbool == False ]; then
			echo "Not a Valid Length Unit. Please use an integer"
		else
			echo "Valid Length Unit"
		fi
	done
	evaldl
	addmail
	echo "We have added this mail to the queue"
	exit 0
fi
