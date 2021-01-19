#!/bin/bash
#Pizza Project
# 12/29/2020
# Omer Bayrakdar

# sourcing functions from main.sh without actually running the file
source ./src/main.sh --source-only

clear

dupe-topping() {

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

confirmation() {
# Function to check if the selected toppings are correct.

	printf -v joined '%s, ' "${selectedTopps[@]}"
	echo -e "\x1b[35m You chose the following toppings: ${joined}"
        read -p "Is this correct? (y/n): " choice

	# Changes input to lowercase
	choice=${choice,,}
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


order_correct=false
pizzaToppings=("Extra Cheese" Pepperoni Sausage Tomatoes Onion Mushroom Jalapeno Olives Cucumber "Red Pepper")

while :; do

	# Sourced header function from main runs.
	header

	echo -e "\e[1;31m      ---- PIZZA TOPPINGS ------
	\e[0m"
	echo ""

	# Prints out the options
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

	echo -e "\x1b[33m Please enter the numbers for as many toppings as you would like, separated"
	read -p "by spaces (leave it blank to cancel the current pizza order): " selection
	echo ""

	# Checking to see if selection is blank
	# If it is blank, return to the main menu.
	if [ -n "$selection" ]; then
		echo -e "\e[1;32m      ---- ADDED TOPPINGS ------
		\e[0m"
		echo ""

		# Internal field separator - tells program how to separate words within the string
		IFS=' '

		# Splits the individual entries into the array
		read -a numarr <<< "$selection"

		for i in "${numarr[@]}" ; do
		# If something is not in the array (not a number, number too big, or not an integer)
		# it does not try to add it to the toppings list

			(( i-- ))
		        case "$i" in
			        -1 | [0-9] | 10) dupe-topping $i;;
			        *) echo "Entry $i is not recognized";;
		        esac
			# Resets the dupe flag for each entry
		        dupe_flag=false
		done

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
