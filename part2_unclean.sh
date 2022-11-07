#!/bin/bash
#	N 1. read all files that have been created in a loop
#	N 2. read through the file and separate useful information
#	N 3. create central CSV file to write in
#	N 4. append the central file with the useful information from each file
#	N 5. reformat the USD format back into integer format

#part 2

#echo first line into csv file
echo "Card Type Code,Card Type Full Name,Issuing Bank,Card Number,Card Holder's Name,CVV/CVV2,Issue Date,Expiry Date,Billing Date,Card PIN,Credit Limit">>"task2.csv"

#initial setup
line_num=0
csv_values=()
csv_line=""
directory=/home/mt-accolite/assignment
#Loop to iterate over all files

shopt -s globstar
for file in $directory/**/*.*
do
	echo "file is: $file"

	while read line
	do
		#getting the part of the string that is important to us
		echo "start ifs"
		IFS=":"
		strings=($line)
		echo "echoing strings 1${strings[1]}"
		IFS=$IFS_standard
		strings[1]=$(echo ${strings[1]} | cut -c 2-)
		echo "end ifs"
		echo "line string part 1: ${strings[0]}"
		echo "line string part 2: ${strings[1]}"

		#checking for line with USD formatting
		echo "starting line check"
		echo "line number is: $line_num"
		if [ $line_num -eq 10 ]
		then
			#this is the line that needs unformatting
			echo "hit formatted line, unformatting"
			unformatted_line=${strings[1]}
			echo "current format is: $unformatted_line"
			#formatted_line= $(echo "${unformatted_line//[!0-9]/}")
			#formatted_line= $(echo | sed '$formatted_line/[^0-9]*//g')
			#formatted_line= ${${formatted_line}//[[:digit:]]/}
			#formatted_line=$(echo ${strings[1]} | cut -c 2-)
			formatted_line=$(echo "$unformatted_line" | tr -dc '0-9')
			echo "new format is: $formatted_line"
			csv_values[$line_num]=${formatted_line}
		else
			csv_values[$line_num]=${strings[1]}
		fi
		##increasing use of line for
		line_num=$(($line_num+1))
	done < $file
	
	#for loop to concatenate string into CSV format	
	helper=0
	for i in ${csv_values[@]}
	do
		echo "i value is $i"
		echo "helper number is: $helper"
		if [ $helper -eq 10 ];then
			csv_line=$csv_line$i
		else
			csv_line=$csv_line$i","
		fi
		
		helper=$(($helper+1))
	done
	helper=0

	echo "full line is: $csv_line"
		
	echo $csv_line>>"task2.csv"

	#reset for next file
	line_num=0
	csv_line=""
done
