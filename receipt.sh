#!/bin/bash
source ./main.sh --source-only

customername=Daniel
date=$( date +"%x" | sed 's/\//\_/g'  )

receipt="$customername-$date-receipt.txt"
touch $receipt

day=$( date +"%x" )
time=$( date +"%X" )

echo "---------------------------------------------------------------"
echo "|                      DKOP-Pizza-Palace                      |"
echo "|                       191 Fayette St.                       |"
echo "|                   Martinsville, VA 24112                    |"
echo "|                    $day at $time                            |"

# ADD ECHO FOR DELIVERY OR TAKEOUT

echo "---------------------------------------------------------------"


display-current-order

# NEED SUBTOTAL AMOUNT, TAX AMOUNT, AND TOTAL HERE
echo "                                         Subtotal:             "
echo "                                              Tax:             "
echo "                                            Total:             "

echo "---------------------------------------------------------------"
echo "|               Thank you for ordering from us!               |"
echo "|                We hope to see you again soon!               |"
echo "---------------------------------------------------------------"
