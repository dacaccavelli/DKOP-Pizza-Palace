#!/bin/bash

read -p " Please Choose Your Pizza Size:" Size
echo "You have selected $Size size Pizza"
case $Size in
Small)echo  "The Price for $Size size Pizza will be USD 8.99";;
Medium) echo "The price for $Size size Pizza will be USD 10.99";;
Large) echo  "The price for $Size size Pizza will be USD 12.99";;
Extra_Large) echo "The price for $Size size Pizza will be USD 14.99";;
Thin_Crust) echo  "The price for $Size size Pizza will be USD 11.99";;
Large_Stuffed) echo  "The price for $Size size Pizza will be USD 13.99";;

esac

