#!/bin/bash

#----------------------------------------------------
# Author: Daniel Caccavelli
# Date: 1/19/2021

# Description: The purpose of this script is to
# gather the user's information needed for delivery.

#----------------------------------------------------
# Script Body

# sourcing functions from main.sh without actually running the file
source ./src/main.sh --source-only

info_correct=false

gather-info() {
# Function to gather the delivery information from the user.

	read -p "Please enter your last name: " lname
	read -p "Please enter your address: " address
	read -p "Please enter your phone number: " phone
}

confirmation() {
# Function to confirm the information from the delivery.
# If yes, stores all of the information for later use.
# If no, runs the gather-info function again.
# If ambiguous, runs the confirmation function again.

	echo -e "\x1b[35m Your information:"
	echo -e "\x1b[32m-----------------"
	echo -e "\x1b[35m Name: $customername $lname"
	echo -e "\x1b[35m Address: $address"
	echo -e "\x1b[35m Phone number: $phone"
	read -p "Is the above information correct? (y/n)  " choice
	choice=$(choice,,)

	case $choice in
	"yes" | "y") 	echo "Great! Thank you!"
			touch $customerinfo
			echo "$customername $lname" > $customerinfo
			echo "$address" >> $customerinfo
			echo "$phone" >> $customerinfo
			info_correct=true;;
	"no" | "n") 	echo "Let's try that again...";;
	*)		echo "Sorry, I did not understand. Let's try again"
			confirmation;;
	esac
}

# Main loop
while :; do

	clear

	# Sourced function from main.sh which displays the header
	header false

	# Initial prompt.
	echo -e "\x1b[33m Hi $customername, we need a little more information for your delivery..."

	# Functions to gather the information, then check if it is correct.
	gather-info
	confirmation

	# If the information is correct, break out of the loop.
	[ "$info_correct" == "true" ] && break

done
