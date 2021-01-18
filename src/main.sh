#!/bin/bash

#---------------------
# Author: Daniel Caccavelli
# Date: 12/29/2020

# Description: The purpose of this script is to 
# compile the other shell files for ordering from
# our pizza place.

#---------------------
# Script Body

#source ./src/receipt.sh

# Initial clearing of terminal
clear

# Setting up variables for the list of pizzas

if [ ! -d tmp ]; then 
	mkdir tmp
fi

export pizzafile="tmp/running-order.txt"
export temppizza="tmp/temp-pizza.txt"
export customerinfo="tmp/cust-info.txt"

# sourcing functions from main.sh without actually running the file
source ./src/pricing.sh --source-only

#-------------------------------------------
#Testing



#----------------------------------------------------------------
# Section 1 : Setting up the following functions:

#	welcoming: Welcomes the user and initializes the pizza file.

#	display-current-order: Reads the pizza file and displays
#		the pizzas that have been ordered.

# 	order-and-options: Uses the display-current-order function to
# 		display the current order, as well as the giving the users
# 		the option to  1) order a new pizza, 2) remove a pizza,
#		and 3) finish the order.

#	remove-pizza: Displays the current list of pizzas and lets the
#		user choose one to remove, or cancel the operation.

#	delivery-or-carryout: Lets user choose delivery or carryout
#		then redirects to the the proper file based on the choice.


welcoming() {
# Function to welcome the new customer and initialize the pizza file.

	# Welcoming the new customer
	echo "----------------------------------------------------------"
	echo "Welcome to DKOP Pizza Palace! Where dreams become reality!"
	echo "----------------------------------------------------------"

	read -p "What is your name? " customername
	echo "Hello $customername. Thank you for coming to DKOP Pizza Palace!"

	# Initializing the table with column headers
	echo "Size Crust-Type Toppings" > $pizzafile

	# Preloading the order for testing
	echo "Medium regular 1 13.00 : Pepperoni" >> $pizzafile
	echo "Small thin 1 11.00 : Olives" >> $pizzafile
	echo "Xlarge thick 1 16.00 : Cheese" >> $pizzafile
	echo "Large stuffed 1 16.00 : Onions" >> $pizzafile

	# Exporting the customername for the other files.
	export customername
}


display-current-order() {
# Function to read the file containing the current order

	echo "------------------- Current Order ----------------------------------"
	echo ""
	counter=0
	while read line; do
		if [[ "$counter" == '0' ]]; then
			(( counter ++ ))
			continue
		fi
		size=$(echo $line | cut -f1 -d ' ')
		crust=$(echo $line | cut -f2 -d ' ')
		tops=$(echo $line | cut -f3 -d ' ')
		price=$(echo $line | cut -f4 -d ' ')
		echo "$counter. $size, $tops topping $crust crust pizza		$price"
		(( counter++ ))
	done < $pizzafile
	if [[ "$counter" == '1' ]]; then
		echo "The order is currently empty"
	fi
	echo ""
	echo "--------------------------------------------------------------------"
}


order-and-options() {
# Function to display the current order and the main options.

	# Calls function to display running order.
	display-current-order

	echo "$customername, please select an option from the"
	echo "list below by using the corresponding number:"
	echo "-----------------------------------------------"
	echo "To order a new pizza, enter 1."
	echo "To remove a pizza from the order, enter 2."
	echo "To finish your order, enter 3."
	read -p "Enter your choice..." choice
}

remove-pizza() {
# Function to allow the user to remove a pizza from the list.

	# Clears the CLI
	clear
	# Adds current order and option to remove a pizza
	echo "------------------ Removing a pizza ----------------------"
	display-current-order
	read -p "Choose pizza to remove (or select '0' to cancel):" choice

	# Removes the specific pizza from the file. Does nothing if '0'.
	if [ "$choice" -ne '0' ]; then
		((choice++))
		sed -i -e "${choice}d" $pizzafile
	fi
}


delivery-or-carryout() {
# Function to either direct the user directly to the pricing, or 
# to delivery.sh to collect their contact information.

	#Clears and shows current order
	clear
	display-current-order

	# Prompts user to choose between delivery or carryout.
	echo "$customername, will your order be delivery or carryout?"
	echo "-----------------------------------------------"
	echo "To choose delivery, enter 1."
	echo "To choose carryout, enter 2."
	read -p "Enter your choice..." choice

	# Switch betwen delivery form for user info or just pricing.
	case $choice in
	#1) echo "redirect to delivery form, then to pricing";;
	1)./src/delivery.sh;;
	esac

	#Calls pricing.sh to get final totals.
	calculate-multiple-pizzas
	#./src/pricing.sh
}


main() {
# Includes the welcoming and the main loop.
#----------------------------------------------------------------
# Section 2 : Prompting the user for their name if not known
# 	and giving them their current order and the list of options.

	# Only prompts on the initial run
	if [ -z ${customername+x} ]; then
	welcoming
	fi

	#----------------------------------------------------------------
	# Section 3: Main loop where the user will be continuously
	# 	prompted for what option they would like to perform.

	# Start of the main loop
	while :
	do

		# Clearing the CLI
		clear

		# Gives the user the current order and options.
		order-and-options

		#Switch case for selecting what the user wants to do.
		case $choice in
		#1) echo "this will take you to the size and toppings files";;
		1) ./src/crust.sh;;
		2) remove-pizza;;
		3) delivery-or-carryout;;
		#3) echo "this will take you to delivery/checkout choice and pricing file";;
		esac

		# Adding the new pizza if all criteria for the pizza were met
		# (size, crust, and toppings). Criteria is stored on two lines if 
		# the order was completed.

		pizza_line_count=$(wc -l $temppizza | cut -f1 -d ' ')
		if [ "$pizza_line_count" -gt '1' ] ; then

			pizza_size=$(sed '1q;d' $temppizza | cut -f1 -d ' ')
			pizza_crust=$(sed '1q;d' $temppizza | cut -f2 -d ' ')
			no_topp_check=$(sed '2q;d' $temppizza)

			if [ "$no_topp_check" == "None" ]; then
				pizza_toppings_count=0
			else
				pizza_toppings_count=$(( $pizza_line_count - 1 ))
			fi
			pizza_toppings=$(sed "2,${pizza_line_count}!d" $temppizza | awk -v d=", " '{s=(NR==1?s:s d)$0}END{print s}')

			calculate-single-pizza $pizza_size $pizza_crust $pizza_toppings_count
			((pizza_line_count++))
			pizza_price=$(sed "${pizza_line_count}q;d" $temppizza)

			echo "$pizza_size $pizza_crust $pizza_toppings_count $pizza_price : $pizza_toppings" >> $pizzafile
		fi

		rm $temppizza

		# Will need to have a way to check if the order has been finished
		# (aka finished with Pushpa's file) to stop rerunning the main file.

	done
	# End of the main loop

	#----------------------------------------------------------------
	# Section 4: Closing statements and cleanup of the created file.

	rm -r tmp
	echo "Thank you for visiting DKOP Pizza Palace"
	echo "Have a good day! Press any key to exit..."
	read
}

#Calling the main function
if [ "${1}" != "--source-only" ]; then
	main
fi
