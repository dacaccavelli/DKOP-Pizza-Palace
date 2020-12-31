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

# 	Creating a single pizza hash table.
declare -A pizzaA
pizzaA=(["size"]="medium" ["crust"]="thin" ["toppings"]="1")


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

# Welcoming the new customer
echo "----------------------------------------------------------"
echo "Welcome to DKOP Pizza Palace! Where dreams become reality!"
echo "----------------------------------------------------------"

read -p "What is your name? " customername
echo "Hello $customername. Thank you for coming to DKOP Pizza Palace!"

# Listed here are all of the pizzas that have been ordered.
echo "------------------- Current Order ------------------------"
echo ""

echo "----------------------------------------------------------"
echo "Please selection an option from the list below"
echo "by using the corresponding number:"
echo "-----------------------------------------------"
echo "To order a new pizza, enter 1."
echo "To remove a pizza from the order, enter 2."
echo "To finish your order, enter 3."
read -p "Enter your choice..."


# Exporting the variables for the other scripts to use
export pizza_finished
export customername

# Calling the pizza script for the crust sizes and types.

