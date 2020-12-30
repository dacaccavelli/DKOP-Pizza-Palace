#!/bin/bash

#-------------------------
#Author: Pushpa
#Date: 12/29/2020

clear
echo "        ----------PIZZA CRUST-OPTIONS----------------                                 
  "

echo "1. Thin crust pizza
2. Thick crust pizza
3. Regular pizza
4. Handcrafted Specialty pizza
"


read -p " Please select and enter your Pizza type option from the abouve options: " ptype
case $ptype in
1) echo  "You have selected option $ptype"
echo "The price for Small Pizza is USD 8.99
The price for Medium Pizza is USD 10.99
The price for Large Pizza is USD 12.99
The price for Extra Large Pizza is USD 13.99";;
2) echo "You have selected option $ptype "
echo "The price for Small Pizza is USD 7.99
The price for Medium Pizza is USD 9.99
The price for Large Pizza is USD 11.99
The price for Extra Large Pizza is USD 12.99";;
3) echo "You have selected option $ptype "
echo "The price for Small Pizza is USD 6.99
The price for Medium Pizza is USD 8.99
The price for Large Pizza is USD 10.99
The price for Extra Large Pizza is USD 12.99";;
4) echo "You have selected option $ptype "
echo "The price for Small Pizza is USD 8.99
The price for Medium Pizza is USD 10.99
The price for Large Pizza is USD 12.99
The price for Extra Large Pizza is USD 13.99";;
esac
echo "               "
echo "        -------------PIZZA SIZE OPTIONS---------------            "

echo "1. Small
2. Medium
3. Large
4. Extra Large
 "

read -p " Now please select and enter your Pizza size option from the abouve options: " psize
echo "           "
case $psize in 
1)  echo " You have selected Small size pizza.";;
2) echo "You have selected Medium size pizza.";;
3) echo "You have selected Large sie pizza";;
4) echo "You have selected Extra Large pizza";;
esac
echo "         "
#pizza crust type
#price before tax
#price after tax











#read -p " Please Choose Your Pizza Size:" Size
#echo "You have selected $Size size Pizza"
#case $Size in
#Small)echo  "The Price for $Size size Pizza will be USD 8.99";;
#Medium) echo "The price for $Size size Pizza will be USD 10.99";;
#Large) echo  "The price for $Size size Pizza will be USD 12.99";;
#Extra_Large) echo "The price for $Size size Pizza will be USD 14.99";;
#Thin_Crust) echo  "The price for $Size size Pizza will be USD 11.99";;
#Large_Stuffed) echo  "The price for $Size size Pizza will be USD 13.99";;
#esac

