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

# Exporting the variables for the other scripts to use
export pizza_finished

# Welcoming the new customer
echo "----------------------------------------------------------"
echo "Welcome to DKOP Pizza Palace! Where dreams become reality!"
echo "----------------------------------------------------------"

read -p "What is your name? " customername
echo "Hello $customername."
export customername

echo "------------------- Current Order ------------------------"



echo "Please selection an option from the list below"
echo "by using the corresponding number."
echo "To order a new pizza, enter 1."
echo "To remove a pizza from the order, enter 2."
echo "To finish your order, enter 3."
read -p "Enter your choice..."
