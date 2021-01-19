#!/bin/bash

#------------------
# Author: Daniel Caccavelli
# Date: 1/19/2021

# Description: The purpose of this script is to
# display the details of each pizza if requested.
# The details include the size, the crust, the
# names of the chosen toppings, and the price,
# which gets truncated to fit the screen.

#---------------------------------
# Script Body


display-details() {
# Function which displays the size, crust,
# list of toppings, and price for each pizza.

	# Header which matches the one from the main file.
	echo "-------------------- DKOP Pizza Palace --------------------" | toilet -f term -F border --gay
        echo -e "\e[1;32m ------------------- Current Order ------------------------ \e[0m"

	# While loop for each line in the file.
        counter=0
        while read line; do

		# Skips the header line
                if [[ "$counter" == '0' ]]; then
                        (( counter ++ ))
                        continue
                fi

		# Cuts each line to get the desired portion.
                size=$(echo $line | cut -f1 -d ' ')
                crust=$(echo $line | cut -f2 -d ' ')
                tops=$(echo $line | cut -f3 -d ' ')
                price=$(echo $line | cut -f4 -d ' ')
		tops_list=$(echo $line | cut -f2 -d ':')

		# Displays the desired information to the set character amount.
                echo  -en "\x1b[35m"
		printf "%-64.64s\n" "$counter. $size, $crust w/ $tops_list"
                (( counter++ ))
        done < $pizzafile

	# If the counter remains at one, there are no pizzas and
	# and the default echo will appear.
        if [[ "$counter" == '1' ]]; then
                echo -e "\e[1;31m The order is currently empty \e[0m"
        fi

        echo -e "\e[1;32m ---------------------------------------------------------- \e[0m"
}

clear

# Function to display the details and wait for a key
# press to exit.
display-details
read -p "Press any key to return to the previous menu"
