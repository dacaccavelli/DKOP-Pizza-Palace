#!/bin/bash
 
clear
echo ""
echo ""
echo "---- PIZZA TOPPINGS ------"
echo ""
toppings=(TOMATOES ONIONS PEPPERONI CHEESE MUSHROOM JALAPENO OLIVES CUCUMBER)


counter=1
for t in ${toppings[@]}
do
echo "$counter  $t"
((counter++))
done
echo ""
read -p "Add toppings [1-8] >>  " selection
echo ""
echo "---- ADDED TOPPINGS ------"
echo ""
echo "${toppings[$selection-1]}"
echo "" 
