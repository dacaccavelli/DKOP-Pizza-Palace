#!/bin/bash

size_price=(1.00 2.00 3.00 4.00)
crust=(0.50 1.00 2.00)
toppings=1.00

#--------------------------------size-----------------

clear

read -p "Please enter the pizza size small / medium / large / extra_large: " size
if [[ $size == small ]]; then
 pizza_size_price=${size_price[0]}
echo -e "\e[1;32m The $size pizza will be : USD $pizza_size_price \e[0m"

elif [[ $size == medium ]]; then
pizza_size_price=${size_price[1]}
echo -e "\e[1;32m The $size pizza will be : USD $pizza_size_price \e[0m"

elif [[ $size == large ]]; then
pizza_size_price=${size_price[2]}
echo  -e "\e[1;32m The $size pizza will be : USD $pizza_size_price \e[0m"

elif
 [[ $size == extra_large ]]; then
pizza_size_price=${size_price[3]}
echo -e "\e[1;32m The $size pizza will be : USD $pizza_size_price \e[0m" 
fi

#--------------------------toppings price------------

read -p "How many toppings would you like to have on your pizza :  " tp
tp_price=$(( $tp * 1 ))
echo -e "\e[1;32m The topping price will be :USD $tp_price \e[0m"

#--------------------------crust price---------------

read -p "What tipe of crust would you like to have regular / thin / thick:  " crst
if [[ $crst == regular ]]; then
crust_price=${crust[0]}
echo -e "\e[1;32m  The price for $crst crust is : USD $crust_price \e[0m"

elif [[ $crst == thin ]]; then
crust_price=${crust[1]}
echo -e "\e[1;32m The price for $crst crust is : USD $crust_price \e[0m"

elif [[ $crst == thick ]]; then
crust_price=${crust[2]}
echo -e "\e[1;32m  The price for $crst crust is : USD $crust_price \e[0m"
fi

#--------------------------total----------

total=$(echo "scale=2; $pizza_size_price+$tp_price+$crust_price" | bc)
echo " "
echo  -e "\e[1;32m The total will be: $total \e[0m"
echo " "

#"{size[@]}
#size='medium'
#crust='thin'
#toppings='pepperoni'

