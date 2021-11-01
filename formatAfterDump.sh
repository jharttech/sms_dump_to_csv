#!/bin/bash

##############################################
# Script to convert a sms_dump by meterpreter
# into a csv file for data sorting
# AWK strings were given major finesse by
# Richard Nelson (unixabg)
##############################################
# Set Global Variable
_Datestamp=$(date +%Y%m%d)
_Timestamp=$(date +%Y%m%d_%H%M%S)
_Report=report-"$_timestamp".csv
_Exit="Enjoy and Thank You!  -Jhart"
##############################################

while true; do
	read -p "Please enter the filename (include path if needed) of sms dump: " _DumpFile
	echo "You set the dump file as "$_DumpFile""
	read -p "Is this correct? y/n " _Yn
	if ([ "$_Yn" == "y" ] || [ "$_Yn" == "Y" ]);
	then
		# Convert the dump from binary data to utf-8
		cat $_DumpFile | tr -d '\0' > fullDump.txt
		# Create full CSV format of sms dump
		#cp header.txt "$_report" && tail +10 fullDump.txt | awk -v RS='\n\n' '{printf "%s\n",$0}' | awk -v RS='#' '{gsub("\n", ":"); print}' | awk -F: '{print $1","$3","$5":"$6":"$7","$9","$13}' | sed  's/, /,/g' >> "$_report"
		cp header.txt "$_Report" && tail +10 fullDump.txt | awk -v RS='\n\n' '{printf "%s\n",$0}' | awk -v RS='#' '{gsub("\n", ":"); print}' | awk -F: '{print $1"###"$3"###"$5":"$6":"$7"###"$9"###"$13}' | sed  's/### /#/g' >> "$_Report"
		rm fullDump.txt
		read -p "Your new csv version of the sms dump named '"$_Report"' has been created. Would you like to sort the dump by a phone number? y/n " _YesNo
		if ([ "$_YesNo" == "y" ] || [ "$_YesNo" == "Y" ]);
		then
			while true; do
				read -p "Please enter the phone number (ex. 5555555555) you would like to sort into a new file: " _PhoneNumber
				cat "$_Report" | grep "$_PhoneNumber" > sortedReport-"$_Datestamp"-"$_PhoneNumber".csv
				read -p "Your new sorted file has been created and named 'sortedReport-"$_Datestamp"-"$_PhoneNumber"'. Would you like to sort by a different phone number? y/n " _SortAgain
				if ([ "$_SortAgain" == "n" ] || [ "$_SortAgain" == "N" ]);
				then
					echo "$_exit"
					sleep 3
					exit
				fi
			done
		else
			break
		fi
	fi
done
echo "$_Exit"
sleep 3
exit
