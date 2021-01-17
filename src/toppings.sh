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

	echo  "You chose the following toppings: ${selectedTopps[@]}."
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
pizzaToppings=(Tomatoes Onion Pepperoni "Extra Cheese" Mushroom Jalapeno Olives Cucumber "Red Pepper" Sausage)

while :; do
echo ""
echo ""
echo -e "\e[1;31m      ---- PIZZA TOPPINGS ------
\e[0m"
echo ""

counter=1
for t in "${pizzaToppings[@]}"
do
echo "$counter  $t"
((counter++))
done
echo ""

dupe_flag=false
topp_arr=()

read -p "Please Enter multiple Toppings numbers separated by space: " selection
echo ""
echo ""
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
         [0-9] | 10) add-topping $i;;
         *) echo "Entry $i is not recognized";;
         esac
         dupe_flag=false
 done
selectedTopps=()

for i in "${topp_arr[@]}" ; do
	# echo "${pizzaToppings[$i]}"
	selectedTopps+=("${pizzaToppings[$i]}")
done

confirmation 

if [ "$order_correct" == "true" ]; then

	echo "${selectedTopps[@]}" >> $temppizza

	break
fi

done
