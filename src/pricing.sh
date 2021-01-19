#!/bin/bash

#-------------------------
# Author: Pushpa Munagala
# Date: 1/19/2021

# Description: The purpose of thie script is to
# hold the functions that will calculate the prices
# of either a single pizza or a list of pizzas
# from the main program.

#-------------------------
# Script Body

# Variable initialization of the prices of each of the
# components of the order.
size_prices=(5.00 6.00 7.00 8.00)
crust_prices=(5.00 6.00 7.00 8.00)
price_per_topp=1

calculate-single-pizza() {
# Function to calculate the price of a single pizza.

	# Variable initialization of the passed toppings
	total=0
	size=$1
	crust=$2
	topp_count=$3

	# Changing variables to lowercase
	size=${size,,}
	crust=${crust,,}

	# Big conditional to select price based on the
	# size of the pizza.
	if [[ "$size" =~ "small" ]]; then
		size_price=${size_prices[0]}
	elif [[ "$size" =~ "medium" ]]; then
		size_price=${size_prices[1]}
	elif [[ "$size" =~ "large" ]]; then
		size_price=${size_prices[2]}
	elif [[ "$size" =~ "xlarge" ]]; then
		size_price=${size_prices[3]}
	fi

	#--------------------------crust price---------------

	# Big conditional to select price based on the
	# crust of the pizza.
	if [[ "$crust" == "thin" ]]; then
		crust_price=${crust_prices[0]}
	elif [[ "$crust" == "regular" ]]; then
		crust_price=${crust_prices[1]}
	elif [[ "$crust" == "thick" ]]; then
		crust_price=${crust_prices[2]}
	elif [[ "$crust" == "stuffed" ]]; then
		crust_price=${crust_prices[3]}
	fi

	# Calculating the price of the toppings and total price.
	topp_price=$(( $topp_count * $price_per_topp ))
	total=$(echo "scale=2; $size_price+$topp_price+$crust_price-0.01" | bc)

	# Will store the total if called as single pizza calculation.
	# Will not echo with call from calculate-multiple-pizzas.
	if [ -f "$temppizza" ]; then
	        echo $total >> $temppizza
	fi
}


calculate-multiple-pizzas() {
# Calculates final order totals from the list of
# all pizzas.

	# Variable initialization
	subtotal=0
	counter=0

	clear

	# Loop for reading size, crust type, and
	# number of toppings from each pizza.
	# These are cut from the $pizzafile.
	while read line; do
		if [[ "$counter" == '0' ]]; then
			(( counter ++))
			continue
		fi
		sz=$(echo $line | cut -f1 -d ' ')
		crt=$(echo $line | cut -f2 -d ' ')
		tps=$(echo $line | cut -f3 -d ' ')

		# Recalculates the price of each pizza without
		# appending them to the temppizza file.
		calculate-single-pizza $sz $crt $tps

		# Add the calculated total to the running subtotal.
		subtotal=$(echo "scale=2; $subtotal+$total" | bc)
		(( counter++ ))
	done < $pizzafile

	# Displays the header from the main function
	header false

	# Displays the Subtotal calculated above.
	echo -e "\e[1;32m"
	printf "The Subtotal will be: %5s$subtotal \n" "$"

	# Calculates and round the tax to two decimal places.
	tax=$( printf "%0.2f\n" $(echo "scale=2; $subtotal*0.053" | bc))
	printf "The Tax will be: %11s$tax \n" "$"

	# Calculates the grand total from the subtotal and tax.
	grand_total=$(echo "scale=2; $subtotal+$tax" | bc)
	printf "The Grand Total will be: %2s$grand_total \n" "$"

	# Used to save the values to print on the receipt.
	touch $temppizza
	echo $subtotal >> $temppizza
	echo $tax >> $temppizza
	echo $grand_total >> $temppizza

	read -p "Press any key to complete your order."
}
