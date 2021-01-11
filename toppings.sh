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

toppings=(TOMATOES ONION PEPPERONI CHEESE MUSHROOM JALAPENO OLIVES CUCUMBER SAUSAGE CHICKEN SPINACH)
counter=1
for t in ${toppings[@]}
do
echo "$counter  $t"
((counter++))
done
echo ""

read -p "Please add 1st topping [1-11] >> " selection
echo ""
echo ""
echo -e "\e[1;32m      ---- ADDED TOPPINGS ------
\e[0m"
echo ""
echo "${toppings[$selection-1]}"
echo ""
echo "--------------------------------------------------"
echo ""
 
y=1
n=2
yes=yes
no=no
read -p "Do you Want yo add more toppings? (yes or no)  >> "
while [ $1 -e $yes ]
do
read -p "Please add 2nd topping [1-11] >> " selection2
done

echo ""
echo -e "\e[1;32m      ---- ADDED TOPPINGS ------
\e[0m"

echo ""
echo "${toppings[$selection2-1]}" 
echo ""
