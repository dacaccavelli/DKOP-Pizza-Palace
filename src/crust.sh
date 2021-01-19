#!/bin/bash

#---------------------
# Author: Daniel Caccavelli
# Date: 1/11/2021

# Description: The purpose of this script is to
# let the user select size and type of crust
# for each pizza.

#---------------------
# Script Body

# sourcing functions from main.sh without actually running the file
source ./src/main.sh --source-only

# Initializing arrays for sizes and crusts.
size_arr=( Small Medium Large XLarge)
crust_arr=( Thin Regular Thick Stuffed)
order_correct=false

size_prompt() {
# Function to prompt size choice and store the result.

	# Text prompt for the user.
	#echo -e "\x1b[35m Please select a size from the list by using"
	#echo -e "\x1b[35mthe corresponding number. Enter zero (0) to"
	#echo "return to the previous menu."
        #toilet -f term Please select a size from the list by using the corresponding number. --gay
        echo -e "\x1b[33m Please select a size from the list by using the corresponding number."
        #echo "Enter zero (0) to return to the previous menu." | toilet -f term -F border --gay
	# Displays the size with the matching choice number.
	counter=1
	echo -e "\x1b[36m0. Return to main menu"
	for size in ${size_arr[@]}; do
		echo -e "\x1b[36m$counter. $size"
		((counter++))
	done

	# Uses switch case to store the user's choice,
	# exit if the user wants to cancel, or catch errors
	# and reprompt.
	read -p "Choose your size: " choice
	case "$choice" in
	0) exit;;
	1 | 2 | 3 | 4) size=${size_arr[$choice-1]};;
	*) 	echo -e "\x1b[31m Answer not recognized."
		size_prompt
		;;
	esac
} 

crust_prompt() {
# Function to prompt pizza crust choice and store the result.

	# Initial prompt with user instructions
	#toilet -f term Please select a crust type from the list by using the corresponding number. --gay
        echo -e "\x1b[33m Please select a crust type from the list by using the corresponding number."
        #echo "Enter zero (0) to return to the previous menu." | toilet -f term -F border --gay

	# Displays the options for the crusts.
	echo -e "\x1b[36m0. Return to main menu"
	counter=1
	for crust in ${crust_arr[@]}; do
		echo -e "\x1b[36m$counter. $crust"
		((counter++))
	done

	# Uses switch case to store the user's choice,
	# exit if the user wants to cancel, or catch errors
	# and reprompt.
	read -p "Choose your crust: " choice
	case "$choice" in
	0) exit;;
	1 | 2 | 3 | 4) crust=${crust_arr[$choice-1]};;
	*) 	echo -e "\x1b[31m Answer not recognized."
		crust_prompt
		;;
	esac
}

user_prompts() {
# Function to run both prompts and print the results.

	# Prompts user to choose the size of the pizza
	# and prints their choice.
	size_prompt
	echo -e "\x1b[32m You chose $size"

	# Prompt user to choose their pizza crust
	# and prints their choice
	crust_prompt
}

confirmation() {

	read -p "You chose a $size, $crust crust pizza. Is this correct? (y/n): " choice
	case $choice in
	"yes" | "y") 	clear
			order_correct=true
			echo "Great! Now let's select the toppings."
			;;
	"no" | "n")	clear
			echo "Let's try again...";;
	*) 		clear
			echo " Sorry, I did not understand.. "
			confirmation;;
	esac

}
# Clears the CLI.
clear

while :; do
	header false

	user_prompts

	confirmation

	[ "$order_correct" == "true" ] && break

done
# Creating a file and storing the local variables in there
# because bash does not have a better way to pass to a
# parent process.
# File gets deleted in main.sh after adding the pizza
# to the running total.
touch $temppizza
echo "$size $crust" > $temppizza
./src/toppings.sh
