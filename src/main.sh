#!/bin/bash

#---------------------
# Author: Daniel Caccavelli
# Date: 12/29/2020

# Description: The purpose of this script is to
# compile the other shell files for ordering from
# our pizza place.

#---------------------
# Script Body

# Initial clearing of terminal
clear

# Setting up variables for the list of pizzas

# Creates the tmp directory if it does not exist.
if [ ! -d tmp ]; then 
	mkdir tmp
fi

# Exporting filenames as variables for
# the other files to use.
export pizzafile="tmp/running-order.txt"
export temppizza="tmp/temp-pizza.txt"
export customerinfo="tmp/cust-info.txt"

# Converts the date into a usable format
# for creating a filename.
date=$( date +"%x" | sed 's/\//\_/g'  )

# Flag initialization for different instances
# delivery - changes the ending message is the
#	user chose delivery
# order_finished - tells the main loop when
#	to end after the order is placed
# close_flag - tells the main loop to end when
#	ended before placing the order
delivery=false
order_finished=false
close_flag=false

# Sourcing functions from pricing.sh without actually running the file
source ./src/pricing.sh --source-only

#----------------------------------------------------------------
# Section 1 : Setting up the following functions:

#	welcoming: Welcomes the user and initializes the pizza file.

#	display-current-order: Reads the pizza file and displays
#		the pizzas that have been ordered.

#	header: Displays the header which contains the name of the
#		restaurant and the current order for quick reference.

# 	order-and-options: Uses the display-current-order function to
# 		display the current order, as well as the giving the users
# 		the option to  1) order a new pizza, 2) remove a pizza,
#		and 3) finish the order.

#	remove-pizza: Displays the current list of pizzas and lets the
#		user choose one to remove, or cancel the operation.

#	delivery-or-carryout: Lets user choose delivery or carryout
#		then redirects to the the proper file based on the choice.

#	close-program: Confirms that the user wants to close the program
#		from the main menu without placing an order.

#	main: Main function which contains all of the magic of combining the
#		other files, reading/writing from/to files, and handling
#		program closing conditions and file cleanup.

welcoming() {
# Function to welcome the new customer and initialize the pizza file.

	# While loop to  ensure a name is entered.
	while [ -z "$customername" ]; do

		clear

		# Welcoming the new customer
		echo " "
	        echo -e "\x1b[32mDKOP PIZZA   PALACE" | toilet -F border --gay
	        echo ""

		# Beautification package used for the entry and the header.
	        toilet -f term ......Welcome to DKOP Pizza Palace! Where dreams become reality !...... --gay
	        echo ""

		# Prompt to read the customer's name
		echo -en "\x1b[33m"
		read -p "What is your first name? " customername
	done

	# Initializing the table with column header
        echo -e "\e[1;36m Size Crust-Type Topping_Number Price Toppings \e[0m" > $pizzafile

	# Exporting the customername and receipt name for the other files.
	export customername
	export receipt="receipts/$customername-$date-receipt.txt"

	# Starting the program by letting the user start to make a pizza.
	./src/crust.sh
}


display-current-order() {
# Function to read the file containing the current order
# and print the pizzas that have been made.

	# Ensures you actually want to have the current order displayed
	if [ "$1" == "false" ]; then

		# Header line for the current order
		echo -e "\e[1;32m-------------------- Current Order ------------------------ \e[0m"

		# Loops through all lines of the $pizzafile to display all pizzas.
		counter=0
		while read line; do
			if [[ "$counter" == '0' ]]; then
				(( counter ++ ))
				continue
			fi

			# Cuts out the necessary information
			size=$(echo $line | cut -f1 -d ' ')
			crust=$(echo $line | cut -f2 -d ' ')
			tops=$(echo $line | cut -f3 -d ' ')
			price=$(echo $line | cut -f4 -d ' ')

			# Displays the information in its simple form
			echo -en "\x1b[36m"
			printf "%-45.45s %15s \n" "$counter. $size, $tops topping $crust crust pizza" "$price" 
			(( counter++ ))

		done < $pizzafile

		# If the $pizzafile is empty, then it prints the default line.
		if [[ "$counter" == '1' ]]; then
			echo -e "\e[1;33m The order is currently empty \e[0m"
		fi

		echo -e "\e[1;32m----------------------------------------------------------- \e[0m"
	fi
}

header() {
# Function that acts as a header for the other files

	# Pretty name of the restaurant.
	echo "-------------------- DKOP Pizza Palace --------------------" | toilet -f term -F border --gay

	# Call to function for displaying the order.
	display-current-order $1
}

order-and-options() {
# Function to display the current order and the main options.

	# Calls function to display running order.
	header false

	# Echoing prompt and the options for the user and grabs their choice.
	echo -e "\e[1;33m $customername, please select an option from the \e[0m"
	echo -e "\e[1;33m list below by using the corresponding number: \e[0m"
	echo -e "\e[1;32m ----------------------------------------------- \e[0m"
	echo -e "\e[1;36m To order a new pizza, enter 1. \e[0m"
	echo -e "\e[1;36m To remove a pizza from the order, enter 2. \e[0m"
	echo -e "\e[1;36m To see a detailed view of your order, enter 3. \e[0m"
	echo -e "\e[1;36m To finish your order, enter 4. \e[0m"
	echo -e "\e[1;36m To exit the program without placing an order, enter 5. \e[0m"
	read -p "Enter your choice..." choice
}

remove-pizza() {
# Function to allow the user to remove a pizza from the list.

	# Clears the CLI
	clear
	# Call to header function to add  current order
	# and the option to remove a pizza.
	header false
	echo -e "\e[1;33m ------------------ Removing a pizza ---------------------- \e[0m"
	echo "Choose pizza to remove (enter '0' to see a detailed view of"
	read -p "the pizzas or leave the line blank to cancel):" choice

	# Removes the specific pizza from the file. Does nothing if blank
	# and displays the detailed order if '0'.
	if [ -n "$choice" ]; then
		if [ "$choice" -ne '0' ]; then
			((choice++))
			sed -i -e "${choice}d" $pizzafile
		else
			./src/detailed-order.sh
			remove-pizza
		fi
	fi
}


delivery-or-carryout() {
# Function to either direct the user directly to the pricing, or
# to delivery.sh to collect their contact information.

	#Clears and displays the header/current order
	clear
	header false

	# Checks to make sure the order is not empty.
	# If it is, do not give the options to complete the order.
	linecount=$(wc -l < $pizzafile | cut -f1 -d ' ')
	if [ "$linecount" == "1" ]; then
		echo -e "\e[1;32m Your order is currently empty. \e[0m"
		read -p "Press any key to return to the main menu."
	else
	# Prompts user to choose between delivery or carryout, or
	# return to the main menu if accidental selection.

		echo -e "\e[1;32m $customername, will your order be delivery or carryout? \e[0m"
		echo -e "\e[1;31m ----------------------------------------------- \e[0m"
		echo -e "\e[1;32m To choose delivery, enter 1. \e[0m"
		echo -e "\e[1;32m To choose carryout, enter 2. \e[0m"
		echo -e "\e[1;32m To return to the main menu, enter 0. \e[0m"
		read -p "Enter your choice..." choice

		# Switch betwen delivery form for user info or just pricing.
		case $choice in
			0) continue;;
			1) delivery=true
			   ./src/delivery.sh
			   calculate-multiple-pizzas
			   order_finished=true;;
			2) calculate-multiple-pizzas
			   order_finished=true;;
		esac
	fi
}

close-program() {
# Function called when the user chooses to close the program
# without placing an order.

	# Displays the header/current order and the prompt to exit.
	# Changes the choice to lowercase for input parsing.
	header false
        echo -en "\x1b[35m"
        read -p "Are you sure you want to exit? (y/n): " choice
        choice=${choice,,}

	# Switch case to handle the results of leaving.
	# If yes, switch the close_flag which exits out of the main loop.
	# If no, proceed with the next loop of the program.
	# If ambiguous, run the close-program function again.
        case $choice in
                "yes" | "y")    clear
                                close_flag=true
                                ;;
                "no" | "n")     clear
                                echo "Let's try again...";;
                *)              clear
                                echo "Sorry, I did not understand..."
                                close-program;;
        esac

}


main() {
# First place visited after running the program.
# Includes all the welcoming function and the main loop
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

		# Makes sure this is not the first run of the program
		# because it does not want to double call the main.
		if [ "$first" == "false" ]; then
			# Gives the user the current order and options.
			order-and-options

			#Switch case for selecting what the user wants to do.
			# If 1, goes through crust.sh, toppings.sh, and pricing.sh
			#	to make a new pizza.
			# If 2, calls the remove-pizza function.
			# If 3, runs detailed-order.sh to show the order with
			#	size, crust, and list of toppings.
			# If 4, calls the delivery-or-carryout function.
			# If 5, calls the close-program function.
			case $choice in
				1) ./src/crust.sh;;
				2) remove-pizza;;
				3) ./src/detailed-order.sh;;
				4) delivery-or-carryout;;
				5) clear; close-program;;
			esac
		else
		# If it is the first loop, then switches the flag.
			first=false
		fi

		# Booleans switched from either the delivery-or-carryout
		# or close-program function that cause the main loop to break.
		[ "$order_finished" == "true" ] && break
		[ "$close_flag" == "true" ] && break

		# Adding the new pizza if all criteria for the pizza were met
		# (size, crust, and toppings). Criteria is stored on two lines if
		# the order was completed.

		# First, obtains the total line count of the $temppizaa file.
		# The expected lines are:
		#	1. Size and crust
		#	2-n. Toppings selected
		# If the $pizza_line_count == 1, then the pizza was not finished
		# and the process of adding it to the list is skipped.
		pizza_line_count=$(wc -l $temppizza | cut -f1 -d ' ')
		if [ "$pizza_line_count" -gt '1' ] ; then

			# The size, crust, and number of toppings are
			# pulled from the $temppizza.
			pizza_size=$(sed '1q;d' $temppizza | cut -f1 -d ' ')
			pizza_crust=$(sed '1q;d' $temppizza | cut -f2 -d ' ')
			no_topp_check=$(sed '2q;d' $temppizza)

			# If no toppings were selected,
			# set $pizza_topping_count to 0.
			# Else, set $pizza_topping_count to the
			# actual number of toppings.
			if [ "$no_topp_check" == "None" ]; then
				pizza_toppings_count=0
			else
				pizza_toppings_count=$(( $pizza_line_count - 1 ))
			fi

			# Convoluted line to add all toppings to a single string
			# delimited by a comma and space.
			pizza_toppings=$(sed "2,${pizza_line_count}!d" $temppizza | awk -v d=", " '{s=(NR==1?s:s d)$0}END{print s}')

			# Call to calculate-single-pizza function in pricing
			# and passing the necessary parameters.
			calculate-single-pizza $pizza_size $pizza_crust $pizza_toppings_count

			# The price is appended to the same document, so
			# we incrememnt the line count and pull the price
			# for display.
			((pizza_line_count++))
			pizza_price=$(sed "${pizza_line_count}q;d" $temppizza)

			# Adding all of the informationt to $pizzafile
			# which holds all of our pizzas.
			echo -e "\x1b[33m$pizza_size $pizza_crust $pizza_toppings_count $pizza_price : $pizza_toppings" >> $pizzafile
		fi

		# Once finished with the steps above,
		# we remove the temppizza file.
		rm $temppizza

	done
	# End of the main loop

	#----------------------------------------------------------------
	# Section 4: Closing statements and cleanup of the created files.

	# Checks if the program was closed by a completed order,
	# or early by the user.
	# If close_flag is true, it skips to the simple closing message.
	if [ "$close_flag" == "false" ]; then

		echo ""
		echo -e "\e[1;31m ------------------------------------------------- \e[0m"
		echo ""

		# Displays different information based on if
		# the order was delivery or carryout.
		if [ "$delivery" == "true" ]; then
			address=$(sed '2q;d' $customerinfo)
			phone=$(sed '3q;d' $customerinfo)
			echo -e "\x1b[32m$customername, expect your delivery to $address to arrive"
			echo -e "\x1b[32mwithin 30 minutes. If there are any issues,"
			echo -e "\x1b[32we will call you at $phone."
		else
			echo -e "\x1b[32mYour order will be ready in approximately 20 minutes."
			echo -e "\x1b[32mWe will see you soon!"
		fi

		# Calls the receipt file to create a receipt
		# of the users order in a formatted way.
		# Then lets the user know where they can find
		# the receipt.
		./src/receipt.sh
		echo -e "\x1b[32mYou can find your receipt saved in at this file location: $receipt"
	fi

	# Final cleanup of the temporary files and closing remark
	rm -r tmp
	echo "Thank you for visiting DKOP Pizza Palace. Have a good day! Press any Key to exit" | toilet -f term -F border --gay 
   	read
}

# Calling the main function.
# Needed to enable usage of the
# display-current-order function
# in receipt.sh and the header
# function in most other files
# without running the entire program.
if [ "${1}" != "--source-only" ]; then
	main
fi
