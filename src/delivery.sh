#!/bin/bash

# sourcing functions from main.sh without actually running the file
source ./src/main.sh --source-only

info_correct=false

gather-info() {
read -p "Please enter your last name: " lname
read -p "Please enter your address: " address
read -p "Please enter your phone number: " phone

}

confirmation() {
echo -e "\x1b[35m Your information:"
echo -e "\x1b[32m-----------------"
echo -e "\x1b[35m Name: $customername $lname"
echo -e "\x1b[35m Address: $address"
echo -e "\x1b[35m Phone number: $phone"
read -p "Is the above information correct? (y/n)  " choice

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

while :; do
clear

header false

echo -e "\x1b[33m Hi $customername, we need a little more information for your delivery..."

gather-info

confirmation

[ "$info_correct" == "true" ] && break

done
