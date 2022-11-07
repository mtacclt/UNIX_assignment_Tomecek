#!/bin/bash
#echo first line into csv file
echo "Card Type Code,Card Type Full Name,Issuing Bank,Card Number,Card Holder's Name,CVV/CVV2,Issue Date,Expiry Date,Billing Date,Card PIN,Credit Limit">>"task2.csv"

#initial setup
line_num=0
csv_values=()
csv_line=""
directory=/home/mt-accolite/assignment

#looping through all files to get data
shopt -s globstar
for file in $directory/**/*.*
do
	if [ ! -d $file ]
	then
		while read line
		do
			#getting the part of the string that is important to us
			IFS=":"
			strings=($line)
			IFS=$IFS_standard
			strings[1]=$(echo ${strings[1]} | cut -c 2-)
			if [ $line_num -eq 10 ]
			then
				unformatted_line=${strings[1]}
				formatted_line=$(echo "$unformatted_line" | tr -dc '0-9')
				csv_values[$line_num]=${formatted_line}
			else
				csv_values[$line_num]=${strings[1]}
			fi
			line_num=$(($line_num+1))
		done < $file
	fi
	
	#putting together string and echoing into CSV file
	helper=0
	for i in ${csv_values[@]}
	do
		if [ $helper -eq 10 ];then
			csv_line=$csv_line$i
		else
			csv_line=$csv_line$i","
		fi
		
		helper=$(($helper+1))
	done
	helper=0
	echo $csv_line>>"task2.csv"

	#reset for next file
	line_num=0
	csv_line=""
done
