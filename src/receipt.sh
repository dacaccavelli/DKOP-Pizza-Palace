#!/bin/bash

#------------------------------------------------------
# Author: Daniel Caccavelli
# Date: 1/19/2021

# Description: The purpose of this script is to
# output a final receipt when the order is complete.
# The receipt contains:
#	1. the name of the restaurant,
#	2. the address of the restaurant,
#	3. the date and time the order was placed,
# 	4. the full order, and
#	5. the subtotal, total tax, and the grandtotal.

#-------------------------------------------------------
# Script Body

# Reads the date and outputs it in a format
# will work for the file name.
date=$( date +"%x" | sed 's/\//\_/g'  )

# If the receipts directory does not exist, it creates it.
if [ ! -d "receipts" ]; then
	mkdir receipts
fi
# Creates the receipt file is if does not exist.
touch $receipt

# Stores the formatted date and time.
day=$( date +"%x" )
time=$( date +"%X" )

# Header of the receipt
echo -e "\e[1;32m---------------------------------------------------------------" > $receipt
echo -e "\e[1;32m|                      DKOP-Pizza-Palace                      |" >> $receipt
echo -e "\e[1;32m|                       191 Fayette St.                       |" >> $receipt
echo -e "\e[1;32m|                   Martinsville, VA 24112                    |" >> $receipt
echo -e "\e[1;32m|                  $day at $time                  |" >> $receipt
echo "---------------------------------------------------------------" >> $receipt

# Displays the order from the $pizzafile in a similar way
# to the display-current-order function in main.sh (but
# the spacing is slightly different for presentation.)
echo -e "\e[1;32m ----------------------- Current Order ------------------------ \e[0m" >>$receipt
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
                        printf "\e[36m%-45.45s %19s \n" "$counter. $size, $tops topping $crust crust pizza" "$price" >> $receipt
                        (( counter++ ))
                done < $pizzafile
                if [[ "$counter" == '1' ]]; then
                        echo -e "\e[1;33m The order is currently empty \e[0m"  >> $receipt
                fi
                echo -e "\e[1;32m -------------------------------------------------------------- \e[0m" >> $receipt

# Subtotal, tax, and total amount are read from the $temppizza file.
# Reusing the file for simplicity.
subtotal=$(sed "1q;d" $temppizza)
tax=$(sed "2q;d" $temppizza)
grand=$(sed "3q;d" $temppizza)

# Displaying of the above variables and the footer.
printf "\e[1;32m%60s \n\e[m" "Subtotal: $subtotal" >> $receipt
printf "\e[1;32m%60s \n\e[m" "Tax: $tax" >> $receipt
printf "\e[1;32m%60s \n\e[m" "Total: $grand" >> $receipt

echo -e "\e[1;32m---------------------------------------------------------------" >> $receipt
echo -e "\e[1;32m|               Thank you for ordering from us!               |" >> $receipt
echo -e "\e[1;32m|                We hope to see you again soon!               |" >> $receipt
echo -e "\e[1;32m---------------------------------------------------------------" >> $receipt
