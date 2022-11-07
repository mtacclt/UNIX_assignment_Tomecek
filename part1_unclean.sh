#!/bin/bash
#	Y 1. read file in a loop
#	Y 2. need to check the strings for special characters and replace them
#	Y 3. create directories for the files
#	Y 4. check whether the card is expired
#	Y 5. create file using touch
#	Y 6. append file using touch
#	Y 6.1 make sure the USD format is used
#Part1

#recoding
#recode win1252..utf-8 "100 CC Records.csv"
IFS_standard="$IFS"

function thousands {
	    sed -re ' :restart ; s/([0-9])([0-9]{3})($|[^0-9])/\1,\2\3/ ; t restart '
    }

while read line
do
	echo "starting new loop"
	echo ""
	#set variables from line
	IFS=","
	collumns=($line)
	IFS=$IFS_standard


	#check for special characters in directory names and replace them with underscore TODO
	
	echo "collumn 1 is: ${collumns[1]}"
	checkstring_dir1=${collumns[1]}
	#checkstring=$(echo $checkstring | tr -d -c [:graph:])
	substring=" "
	checkstring_dir1=${checkstring_dir1//$substring/_}
	echo "modified directory string 1 is: $checkstring_dir1"
	#collumns[1]=$modified
	#echo "modified collumn 2 is:${collumns[1]}"
	
	echo "collumn 2 is: ${collumns[2]}"
	checkstring_dir2=${collumns[2]}
	#checkstring=$(echo $checkstring | tr -d -c [:graph:])
	substring=" "
	checkstring_dir2=${checkstring_dir2//$substring/_}
	echo "modified directory string 2 is: $checkstring_dir2"
	#collumns[2]=$modified
	#echo "modified collumn 2 is:${collumns[2]}"

	#create directories if they do not already exist 
	mkdir -p "assignment/$checkstring_dir1/$checkstring_dir2"
	

	#create filename based on checking if the card is expired/active
	suffixExpired=".expired"
	suffixActive=".active"
	
	IFS="/"
	yearmontharr=(${collumns[7]})
	IFS=$IFS_standard
	#echo "date is: ${yearmontharr[0]} and ${yearmontharr[1]}"
	
	if [ ${yearmontharr[1]} -ge 2022 ]
	then
		#echo "active year"
		fileName=${collumns[3]}$suffixActive
	elif [ ${yearmontharr[1]} -ge 2022 -a ${yearmontharr[0]} -ge 11 ]
	then
		#echo "card active year n month"
		fileName=${collumns[3]}$suffixActive
	else
		#echo "card expired"
		fileName=${collumns[3]}$suffixExpired
	fi
	
		#echo "is touching causing this"
	touch "assignment/$checkstring_dir1/$checkstring_dir2/$fileName"
		#echo "after touch"

	#create USD format
	oldformat=${collumns[10]}
	#echo "old format was: $oldformat"
	newformat=$(echo $oldformat | thousands)
	#echo "new format is: $newformat"
	collumns[10]="$""$newformat USD"
	#echo "collumns 10 is ${collumns[10]}"


	#append file with information
	filePath=assignment/"$checkstring_dir1"/"$checkstring_dir2"/"$fileName"
		#echo "file path is: $filePath"
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

	echo "ending loop"
	echo ""
done < <(tail -n +2 '100 CC Records.csv')
