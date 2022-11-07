#!/bin/bash

#recoding
#recode win1252..utf-8 "100 CC Records.csv"
IFS_standard="$IFS"

function thousands {
	    sed -re ' :restart ; s/([0-9])([0-9]{3})($|[^0-9])/\1,\2\3/ ; t restart '
    }

while read line
do
	#set variables from line
	IFS=","
	collumns=($line)
	IFS=$IFS_standard


	#format directory string and make directories
	checkstring_dir1=${collumns[1]}
	substring=" "
	checkstring_dir1=${checkstring_dir1//$substring/_}
	checkstring_dir2=${collumns[2]}
	substring=" "
	checkstring_dir2=${checkstring_dir2//$substring/_}
	mkdir -p "assignment/$checkstring_dir1/$checkstring_dir2"
	
	#create filename based on checking if the card is expired/active
	suffixExpired=".expired"
	suffixActive=".active"
	
	IFS="/"
	yearmontharr=(${collumns[7]})
	IFS=$IFS_standard
	
	if [ ${yearmontharr[1]} -ge 2022 ]
	then
		fileName=${collumns[3]}$suffixActive
	elif [ ${yearmontharr[1]} -ge 2022 -a ${yearmontharr[0]} -ge 11 ]
	then
		fileName=${collumns[3]}$suffixActive
	else
		fileName=${collumns[3]}$suffixExpired
	fi
	
	touch "assignment/$checkstring_dir1/$checkstring_dir2/$fileName"

	#create USD format
	oldformat=${collumns[10]}
	newformat=$(echo $oldformat | thousands)
	collumns[10]="$""$newformat USD"

	#append file with information
	filePath=assignment/"$checkstring_dir1"/"$checkstring_dir2"/"$fileName"
	echo "Card Type Code: ${collumns[0]}">>"$filePath"
	echo "Card Type Full Name: ${collumns[1]}">>"$filePath"
	echo "Issuing Bank: ${collumns[2]}">>"$filePath"
	echo "Card Number: ${collumns[3]}">>"$filePath"
	echo "Card Holder's Name: ${collumns[4]}">>"$filePath"
	echo "CVV/CVV2: ${collumns[5]}">>"$filePath"
	echo "Issue Date: ${collumns[6]}">>"$filePath"
	echo "Expiry Date: ${collumns[7]}">>"$filePath"
	echo "Billing Date: ${collumns[8]}">>"$filePath"
	echo "Card PIN: ${collumns[9]}">>"$filePath"
	echo "Credit Limit: ${collumns[10]}">>"$filePath"
done < <(tail -n +2 '100 CC Records.csv')
