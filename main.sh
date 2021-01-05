#!/bin/bash

#---------------------
# Author: Daniel Caccavelli
# Date: 12/29/2020

# Description: The purpose of this script is to 
# compile the other shell files for ordering from
# our pizza place.

#---------------------
# Script Body

# Clearing the CLI
clear

# Setting up variables for the list of pizzas

pizza_finished=false
pizzas=()
pizzafile="running-order.txt"

#-------------------------------------------
#Testing

#-----------------------------------------

# Function to welcome the new customer and initialize the pizza file.

function welcoming {
# Welcoming the new customer
echo "----------------------------------------------------------"
echo "Welcome to DKOP Pizza Palace! Where dreams become reality!"
echo "----------------------------------------------------------"

read -p "What is your name? " customername
echo "Hello $customername. Thank you for coming to DKOP Pizza Palace!"

# Initializing the table with column headers
echo "Size Crust-Type Toppings" > $pizzafile
# Testing adding to order
echo "Medium regular pepperoni" >> $pizzafile
echo "Small thin olives" >> $pizzafile
echo "Xlarge thick cheese" >> $pizzafile
echo "Large stuffed onions" >> $pizzafile

}

# Function to read the file containing the current order

function display-current-order {
echo "------------------- Current Order ------------------------"
echo ""
counter=0
while read line; do
	if [[ "$counter" == '0' ]]; then
		(( counter ++ ))
		continue
	fi
	size=$(echo $line | cut -f1 -d ' ')
	crust=$(echo $line | cut -f2 -d ' ')
	tops=$(echo $line | cut -f3 -d ' ')
	echo "$counter. $size, $crust crust pizza with $tops"
	(( counter++ ))
done < $pizzafile
echo ""
echo "----------------------------------------------------------"
}

# Function to display the current order and the main options.

function order-and-options {
# Listed here are all of the pizzas that have been ordered.
display-current-order
echo "Please select an option from the list below"
echo "by using the corresponding number:"
echo "-----------------------------------------------"
echo "To order a new pizza, enter 1."
echo "To remove a pizza from the order, enter 2."
echo "To finish your order, enter 3."
read -p "Enter your choice..." choice
}

# Function to allow the user to remove a pizza from the list.

function remove-pizza {
clear
echo "Removing a pizza..."
echo "-------------------"
display-current-order
read -p "Choose pizza to remove (or select '0' to cancel):" choice
if [ "$choice" -ne '0' ]; then
	((choice++))
	sed -i -e "${choice}d" $pizzafile
fi
}


#----------------------------------------------------------------
# Section __ : Prompting the user for their name if not known
# and giving them their current order and the list of options.

# Only prompts on the initial run
if [ -z ${customername+x} ]; then
welcoming
fi

# Gives the routine each time
order-and-options

#----------------------------------------------------------------

# Exporting the variables for the other scripts to use
export pizza_finished
export customername

# Calling the pizza script for the crust sizes and types.

#1) need to add Keaira's sizes file which will redirect to Omer's toppings file
#./sizes.sh
#./topping.sh;;
#2)finished and working

case $choice in
1) echo "this will take you to Keaira's and Omer's files";;
2) remove-pizza;;
3) echo "this will take you to Pushpa's file";;
esac

# Adding order to the csv if the pizza all criteria for the pizza were met.
if [ "$pizza_finished" = true ] ; then
	echo "$pizza_size, $pizza_crust, $pizza_toppings" >> $pizzafile
fi

# Will need to have a way to check if the order has been finished
# (aka finished with Pushpa's file) to stop rerunning the main file.

# MUST DO: change to a while loop (probably) instead of recalling file
# to prevent  multiple instances opening without closing the prior.
./main.sh
