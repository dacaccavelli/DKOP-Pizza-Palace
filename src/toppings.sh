#!/bin/bash
#Pizza Project
# 12/29/2020
# Omer Bayrakdar

clear

add-topping() {

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

	printf -v joined '%s, ' "${selectedTopps[@]}"
	echo "You chose the following toppings: ${joined}"
	#echo  "You chose the following toppings: ${selectedTopps[@]}."
        read -p "Is this correct? (y/n): " choice
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
echo ""
echo ""
echo -e "\e[1;31m      ---- PIZZA TOPPINGS ------
\e[0m"
echo ""

counter=1
for t in "${pizzaToppings[@]}"
do
echo "$counter.  $t"
((counter++))
done
echo ""

dupe_flag=false
topp_arr=()


echo "Please enter the numbers for as many toppings as you would like, separated"
echo "by spaces (enter zero (0) for no toppings or leave it blank to cancel the"
read -p "current pizza order): " selection
echo ""
echo ""

if [ -n "$selection" ]; then
	echo -e "\e[1;32m      ---- ADDED TOPPINGS ------
	\e[0m"
	echo ""
	IFS=' '
	#here-string
	read -a numarr <<< "$selection"
	for i in "${numarr[@]}" ; do

	# if something is not in the array (not a number, number too big, or not an integer)
	# it does not try to add it to the topping list
	        (( i-- ))
	        case "$i" in
	        -1 | [0-9] | 10) add-topping $i;;
	        *) echo "Entry $i is not recognized";;
	        esac
	        dupe_flag=false
	done
	selectedTopps=()

	if [[ "${topp_arr[@]}" =~ "-1" ]]; then
		selectedTopps=("None")
	else
		for i in "${topp_arr[@]}" ; do
			selectedTopps+=("${pizzaToppings[$i]}")
		done
	fi
	confirmation 

	if [ "$order_correct" == "true" ]; then

		for i in "${selectedTopps[@]}" ; do
			echo "$i" >> $temppizza
		done
		break
	fi
else
	break
fi
done
