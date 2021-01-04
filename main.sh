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

# Initializing the csv
echo "Size, Crust-Type, Toppings" >> $pizzafile

# Creating a single pizza hash table.
declare -A pizzaA
pizzaA=(["size"]="medium" ["crust"]="thin" ["toppings"]="1")

#-------------------------------------------
#Testing
#pizzas+=($pizzaA)

#for pizza in "${pizzas[@]}"
#do
#for choice in "${!pizza[@]}"; do
#echo "$choice - ${pizza[$choice]}"
#done
#done

# Pushpa will need for the pricing
#for choice in "${!pizzas[@]}"; do
#echo "$choice - ${pizzas[$choice]}"
#done
#-----------------------------------------

function welcoming {
# Welcoming the new customer
echo "----------------------------------------------------------"
echo "Welcome to DKOP Pizza Palace! Where dreams become reality!"
echo "----------------------------------------------------------"

read -p "What is your name? " customername
echo "Hello $customername. Thank you for coming to DKOP Pizza Palace!"
}

# Need to finish the function to display the current order
function display-current-order {
echo "needs work"
}

function order-and-options {
# Listed here are all of the pizzas that have been ordered.
echo "------------------- Current Order ------------------------"
echo ""

echo ""
echo "----------------------------------------------------------"
echo "Please selection an option from the list below"
echo "by using the corresponding number:"
echo "-----------------------------------------------"
echo "To order a new pizza, enter 1."
echo "To remove a pizza from the order, enter 2."
echo "To finish your order, enter 3."
read -p "Enter your choice..." choice
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

#./main.sh

# Calling the pizza script for the crust sizes and types.

#case $choice in
#1) need to add Keaira's sizes file which will redirect to Omer's toppings file
#./sizes.sh
#./topping.sh;;
#2) need to add taking away from the csv;;
#3) pass to the pricing for the final pricing;;
#esac

# Adding order to the csv if the pizza all criteria for the pizza were met.
if [ "$pizza_finished" = true ] ; then
	echo "$pizza_size, $pizza_crust, $pizza_toppings" >> $pizzafile
fi

