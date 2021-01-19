#!/bin/bash

# Variable initialization
size_prices=(5.00 6.00 7.00 8.00)
crust_prices=(5.00 6.00 7.00 8.00)
price_per_topp=1

# Sourcing the main file to use the functions from within.
#source ./src/main.sh --source-only

calculate-single-pizza() {
# Function to calculate the price of a single pizza.

	# Variable initialization
	total=0
	size=$1
	crust=$2
	topp_count=$3

	# Changing variables to lowercase
	size=${size,,}
	crust=${crust,,}

	# Big conditional to select price based on the
	# size of the pizza.
	if [[ "$size" == "small" ]]; then
		pizza_size_price=${size_prices[0]}
	elif [[ "$size" == "medium" ]]; then
		pizza_size_price=${size_prices[1]}
	elif [[ "$size" == "large" ]]; then
		pizza_size_price=${size_prices[2]}
	elif [[ "$size" == "xlarge" ]]; then
		pizza_size_price=${size_prices[3]}
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

	# Calculating the price of the toppings.
	topp_price=$(( $topp_count * $price_per_topp ))

	# Calculating the total price.
	total=$(echo "scale=2; $pizza_size_price+$topp_price+$crust_price-0.01" | bc)

	# Storing variable if called as single pizza calculation
	# Will not run with call from calculate-multiple-pizzas
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

	# Loop for reading the inportant information
	# from each pizza.
	while read line; do
		if [[ "$counter" == '0' ]]; then
			(( counter ++))
			continue
		fi
		sz=$(echo $line | cut -f1 -d ' ')
		crt=$(echo $line | cut -f2 -d ' ')
		tps=$(echo $line | cut -f3 -d ' ')

		# Recalculates the price of each pizza without
		# appending them to the temppizza file
		calculate-single-pizza $sz $crt $tps

		# Add the calculated total to the running subtotal.
		subtotal=$(echo "scale=2; $subtotal+$total" | bc)
		(( counter++ ))
	done < $pizzafile

	# Displays the header from the main function
	header false

	echo -e "\e[1;32m"
	#echo  -e "\e[1;32m The Subtotal will be:	 \$$subtotal \e[0m"
	printf "The Subtotal will be: %5s$subtotal \n" "$"

	# Calculates and round the tax to two decimal places.
	tax=$( printf "%0.2f\n" $(echo "scale=2; $subtotal*0.053" | bc))
	#echo  -e "\e[1;32m The Tax will be:	 \$$tax \e[0m"
	printf "The Tax will be: %11s$tax \n" "$"

	# Calculates the grand total from the subtotal and tax.
	grand_total=$(echo "scale=2; $subtotal+$tax" | bc)
	#echo  -e "\e[1;32m The Grand Total will be:	 \$$grand_total" #\e[0m"
	printf "The Grand Total will be: %2s$grand_total \n" "$"

	# Used to save the values to print on the receipt.
	touch $temppizza
	echo $subtotal >> $temppizza
	echo $tax >> $temppizza
	echo $grand_total >> $temppizza
	read -p "Press any key to complete your order."
}
