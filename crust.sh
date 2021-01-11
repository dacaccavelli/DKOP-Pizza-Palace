#!/bin/bash

#---------------------
# Author: Daniel Caccavelli
# Date: 1/11/2021

# Description: The purpose of this script is to
# let the user select size and type of crust
# for each pizza.

#---------------------
# Script Body

size_arr=( Small Medium Large X-Large)
crust_arr=( Thin Regular Thick Stuffed)

size_prompt() {

echo "Please select a size from the list by using"
echo "the corresponding number. Enter zero (0) to"
echo "return to the previous menu."

counter=1
for size in ${size_arr[@]}; do
	echo "$counter. $size"
	((counter++))
done

read -p "Choose your size: " choice

case "$choice" in
0) exit;;
1 | 2 | 3 | 4) size=${size_arr[$choice-1]};;
*) 	echo "Answer not recognized."
	size_prompt
	;;
esac
}

crust_prompt() {

echo "Please select a crust type from the list by"
echo "using the corresponding number. Enter zero (0)"
echo "to return to the previous menu."

counter=1
for crust in ${crust_arr[@]}; do
	echo "$counter. $crust"
	((counter++))
done

read -p "Choose your crust: " choice

case "$choice" in
0) exit;;
1 | 2 | 3 | 4) crust=${crust_arr[$choice-1]};;
*) 	echo "Answer not recognized."
	crust_prompt
	;;
esac
}

clear

size_prompt
echo "You chose $size"

crust_prompt
echo "You chose $crust"

touch $temppizza
echo $size $crust < $temppizza
chmod 444 $temppizza

