#!/bin/bash

topp_arr=()
dupe_flag=false

add-topping() {

	#if there are duplicate numbers
	for j in "${topp_arr[@]}" ; do
		if [ "$1" -eq "$j" ]; then
			dupe_flag=true
		fi
	done
	if [ "$dupe_flag" != "true" ]; then
		topp_arr+=($1)
	fi

}

read -p "Enter multiple numbers separated by space: " entry
echo $entry

IFS=' '
#here-string
read -a numarr <<< "$entry"
for i in "${numarr[@]}" ; do

# if something is not in the array (either number too big, or not an integer)
	case "$i" in
	[1-9] | 10) add-topping $i;;
	*) echo "Entry $i is not recognized";;
	esac
	dupe_flag=false
done

echo ${topp_arr[*]}
