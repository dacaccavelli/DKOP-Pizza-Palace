#!/bin/bash


info_correct=false

gather-info() {
read -p "Please enter your last name: " lname
read -p "Please enter your address: " address
read -p "Please enter your phone number: " phone

}

confirmation() {
echo "Your information:"
echo "-----------------"
echo "Name: $customername $lname"
echo "Address: $address"
echo "Phone number: $phone"
read -p "Is the above information correct? (y/n)  " choice

case $choice in 
"yes" | "y") 	echo "Great! Thank you!"
		touch $customerinfo
		echo "$customername $lname" >> $customerinfo
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

echo "Hi $customername, we need a little more information for your delivery..."

gather-info

confirmation

[ "$info_correct" == "true" ] && break

done
