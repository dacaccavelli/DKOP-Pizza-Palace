#!/bin/bash

#Pizza Project
# 12/29/2020
# Omer Bayrakdar

clear

echo ""
echo ""
echo -e "\e[1;31m      ---- PIZZA TOPPINGS ------
\e[0m"
echo ""

pizzaToppings=(TOMATOES ONION PEPPERONI CHEESE MUSHROOM JALAPENO OLIVES CUCUMBE>
counter=1
for t in ${pizzaToppings[@]}
do
echo "$counter  $t"
((counter++))
done
echo ""
dupe_flag=false
topp_arr=()
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

# if something is not in the array (either number too big, or not an integer)
         (( i-- ))
         case "$i" in
         [0-9] | 1[0-1]) add-topping $i;;
         *) echo "Entry $i is not recognized";;
         esac
         dupe_flag=false
 done
selectedTopp=()

for i in "${topp_arr[@]}" ; do
echo "${pizzaToppings[$i]}"
selectedTopp+=("${pizzaToppings[$i]}")
done
echo "${selectedTopp[@]}"

