# DKOP-Pizza-Palace

The purpose of this project is to create a pizza place in Linux.
  Customers are able to:
      1. Decide pizza size,
      2. Decide pizza crust type,
      3. Decide pizza toppings,
      4. Decide carryout or delivery,
      5. View the order summary including:
          1. Subtotal,
          2. Tax, and
          3. Grand total, and
      6. Place the order

## Getting Started

Clone this repo into your Bash environment and run the "dkop-pizza-palace.sh" file

### Prerequisites

You will need the following modules:

```
toilet
```
## Usage

Follow the on screen prompts to place your order.

## Authors

* **Daniel Caccavelli** - [dacaccavelli](https://github.com/dacaccavelli)
* **Pushpa Munagala** - [pushpaAWS](https://github.com/pushpaAWS)
* **Omer Bayrakdar** - [omerbayrakdar](https://github.com/omerbayrakdar)

#--------------------------------------------------------------------
# Project Overview:

The user runs dkop-pizza-project.sh to launch the program. This file contains
  the information client requests, project overview, and
	a call to the main.sh file to begin the bulk of the program.

dkop-pizza-project.sh: Launching point for the program with
	the name of the restaurant for user clarity

main.sh: Majority of the functions that tie the program together.
	 Contains the main loop which prompts the user for their
	 desired choice at the time, whether it be:
			1. Adding a new pizza,
			2. Removing a pizza from the list,
			3. Showing a detailed listing of the pizzas,
			4. Finishing the order, or
			5. Closing the program without placing an order.

	When the user chooses to add a new pizza, crust.sh, toppings.sh, and pricing.sh run.
		All information selected by the user in these files is stored in a
		temporary text file for preservation between files.

	crust.sh: Contains the prompts for both size selection and crust selection along with
		appropriate error checking.

	toppings.sh: Contains the prompts for choosing any number of toppings from the available
		list, or no toppings, along with appropriate error checking.

	pricing.sh: Contains functions to which either calculates the price of a single pizza
		or the entire list of pizzas. The latter also calculates the subtotal, tax, and
		grand total.

	The user can choose to display the detailed listing of the pizzas either from the main
		menu or from the pizza removal menu to ensure they are choosing the right pizza.

	detailed-order.sh: Lists the pizzas in a longer format than the main page, which includes
 		the size of the pizza, crust type, and each individual topping (truncated at a point).

	When the order has been placed, the user chooses between delivery and carryout. If delivery
		is chosen, the user must give the pertinent information before continuing to the final
		pricing.

	delivery.sh: File which prompts the user for the information needed for the delivery.
		This information includes:
			1. Last name (first name was already given),
			2. Address, and
			3. Phone number.

	After the order has been completed, the user is given a closing remark from main.sh,
		a receipt is saved which shows their order details, and the program closes.

	receipt.sh: File which creates the receipt for the user.
		Contains:
			1. Header with the:
				1. Name of the restaurant,
				2. Address of the restaurant, and
				3. Date and time the order was placed,
			2. The order in simple form with the price per item,
			3. Subtotal, tax, and grand total, and
			4. Footer with closing remarks.
