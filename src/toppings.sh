#!/bin/bash

#-----------------------------------------------
# Author: Omer Bayrakdar
# Date: 12/29/2020

# Description: The purpose of this script is to
# allow the users to select as many toppings
# as they want for their pizza and save that
# information for use in main.sh.

#-----------------------------------------------
# Script Body

# sourcing functions from main.sh without actually running the file
source ./src/main.sh --source-only

clear

dupe-topping() {
# Function to check if there are duplicate numbers
# from the user entry.
# If there are, it only appends each number once.

	# Loops through all values currently in the
	# toppings array to see if the number has
	# already occurred.
        for j in "${topp_arr[@]}" ; do
                if [ "$1" -eq "$j" ]; then
                        dupe_flag=true
                fi
        done

	# If the number is not already in the list,
	# append it.
        if [ "$dupe_flag" != "true" ]; then
                topp_arr+=($1)
        fi
 }

confirmation() {
# Function to check if the selected toppings are correct.

	# Appends all selected toppings to one string for organized
	# printing with a set delimiter. Then reads if the toppings
	# are correct from the user.
	printf -v joined '%s, ' "${selectedTopps[@]}"
	echo -e "\x1b[35m You chose the following toppings: ${joined:0:-2}"
        read -p "Is this correct? (y/n): " choice

	# Changes input to lowercase
	choice=${choice,,}

	# Switch case to see if the toppings are correct.
	# If yes, change the boolean to exit out of the loop.
	# If no, do nothing and let the next iteration of the
	#	loop reprompt.
	# If ambiguous, rerun the confirmation function.
        case $choice in
	        "yes" | "y")    clear
	                        order_correct=true
	                        echo "Great! Your pizza has been added to the order."
	                        ;;
	        "no" | "n")     clear
	                        echo "Let's try again...";;
	        *)              clear
	                        echo "Sorry, I did not understand..."
	                        confirmation;;
        esac
}


# Initialization of variables
# order_correct is the flag used to determine when the
#	the selected toppings are correct.
# pizzaToppings is the array which holds all avaialable
#	toppings.
order_correct=false
pizzaToppings=("Extra Cheese" Pepperoni Sausage Tomatoes Onion Mushroom Jalapeno Olives Cucumbers Peppers)

# Main loop of the function - syntax means it is always tru.
while :; do

	# Sourced header function from main.sh runs.
	header false

	echo -e "\e[1;31m ---- Pizza Toppings ------\e[0m"
	echo ""

	# Prints out the all topping options and the corresponding
	# number. Also adds the "0" option for no toppings.
	counter=1
	echo -e "\x1b[36m0.	No toppings"
	for t in "${pizzaToppings[@]}"; do
		echo -e "\x1b[36m$counter.	$t"
		((counter++))
	done
	echo ""

	# Variables used in dupe-topping function for storing the selected toppings
	dupe_flag=false
	topp_arr=()

	# Main prompt which asks the user which toppings they want.
	echo -e "\x1b[33m Please enter the numbers for as many toppings as you would like, separated"
	read -p "by spaces (leave it blank to cancel the current pizza order): " selection
	echo ""

	# Checking to see if selection is blank
	# If it is blank, return to the main menu.
	if [ -n "$selection" ]; then

		echo -e "\e[1;32m---- Chosen Toppings ------\e[0m"
		echo ""

		# Internal field separator - tells program how to separate words within the string
		IFS=' '

		# Splits the individual entries into the array
		read -a numarr <<< "$selection"

		for i in "${numarr[@]}" ; do
		# Switch case within the loop to check all numbers.
		# If something is not in the array (not a number, number
		# too big, or not an integer) it does not try to add it
		# to the toppings list. Prints each entry which is not
		# recognized.

		        case "$i" in
			        [0-9] | 10)(( i-- )); dupe-topping $i;;
			        *) echo "Entry $i is not recognized";;
		        esac

			# Resets the dupe flag for each entry
		        dupe_flag=false
		done

		# If selected toppings array is empty after checking for
		# invalid entries, use "continue" to go through the
		# loop again.
		if [ ${#topp_arr[@]} -eq 0 ]; then
			echo "There were no recognized entries."
			read -p "Press any button to try again..."
			clear
			continue
		fi

		# Array for the toppings chosen by the user
		selectedTopps=()

		# Checks to see if the user requested no toppings
		if [[ "${topp_arr[@]}" =~ "-1" ]]; then
			selectedTopps=("None")
		else
		# If there is a topping selected, add all actual topping names
		# to the selectedTopps array

			for i in "${topp_arr[@]}" ; do
				selectedTopps+=("${pizzaToppings[$i]}")
			done
		fi

		# Runs the confirmation function to see if the entered toppings are correct.
		confirmation

		# If the selected toppings are correct, then the conditional will pass
		if [ "$order_correct" == "true" ]; then

			# Adds all toppings to temporary pizza file for
			# further processing in main.
			for i in "${selectedTopps[@]}" ; do
				echo "$i" >> $temppizza
			done
			break
		fi
	else
	# If the topping selection was null (topping selection left blank), return to main menu.

		break
	fi

done
