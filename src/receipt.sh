#!/bin/bash

# sourcing functions from main.sh without actually running the file
source ./src/main.sh --source-only

date=$( date +"%x" | sed 's/\//\_/g'  )

#receipt="receipts/$customername-$date-receipt.txt"
touch $receipt

day=$( date +"%x" )
time=$( date +"%X" )

echo "---------------------------------------------------------------" > $receipt
echo "|                      DKOP-Pizza-Palace                      |" >> $receipt
echo "|                       191 Fayette St.                       |" >> $receipt
echo "|                   Martinsville, VA 24112                    |" >> $receipt
echo "|                    $day at $time                |" >> $receipt

# ADD ECHO FOR DELIVERY OR TAKEOUT

echo "---------------------------------------------------------------" >> $receipt

# Using the function from main.sh to output the current order.
display-current-order

# NEED SUBTOTAL AMOUNT, TAX AMOUNT, AND TOTAL HERE
linecount=$(wc -l $pizzafile | cut -f1 -d ' ')
subtotal=$(( $linecount - 2 ))
tax=$(( $linecount - 1 ))

subtotal=$(sed "$subtotalq;d" $pizzafile)
tax=$(sed "$taxq;d" $pizzafile)
grand=$(sed "$linecountq;d" $pizzafile)

echo "                                         Subtotal: $subtotal" >> $receipt
echo "                                              Tax: $tax" >> $receipt
echo "                                            Total: $grand" >> $receipt

echo "---------------------------------------------------------------" >> $receipt
echo "|               Thank you for ordering from us!               |" >> $receipt
echo "|                We hope to see you again soon!               |" >> $receipt
echo "---------------------------------------------------------------" >> $receipt
