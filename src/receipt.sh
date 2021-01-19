#!/bin/bash

# sourcing functions from main.sh without actually running the file
#source ./src/main.sh --source-only

date=$( date +"%x" | sed 's/\//\_/g'  )

#receipt="receipts/$customername-$date-receipt.txt"
touch $receipt

day=$( date +"%x" )
time=$( date +"%X" )

echo -e "\e[1;32m---------------------------------------------------------------" > $receipt
echo -e "\e[1;32m|                      DKOP-Pizza-Palace                      |" >> $receipt
echo -e "\e[1;32m|                       191 Fayette St.                       |" >> $receipt
echo -e "\e[1;32m|                   Martinsville, VA 24112                    |" >> $receipt
echo -e "\e[1;32m|                  $day at $time                  |" >> $receipt

# ADD ECHO FOR DELIVERY OR TAKEOUT

echo "---------------------------------------------------------------" >> $receipt

# Using the function from main.sh to output the current order.
#display-current-order
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

# NEED SUBTOTAL AMOUNT, TAX AMOUNT, AND TOTAL HERE
subtotal=$(sed "1q;d" $temppizza)
tax=$(sed "2q;d" $temppizza)
grand=$(sed "3q;d" $temppizza)
echo -en ""
printf "\e[1;32m%60s \n\e[m" "Subtotal: $subtotal" >> $receipt
printf "\e[1;32m%60s \n\e[m" "Tax: $tax" >> $receipt
printf "\e[1;32m%60s \n\e[m" "Total: $grand" >> $receipt

echo -e "\e[1;32m---------------------------------------------------------------" >> $receipt
echo -e "\e[1;32m|               Thank you for ordering from us!               |" >> $receipt
echo -e "\e[1;32m|                We hope to see you again soon!               |" >> $receipt
echo -e "\e[1;32m---------------------------------------------------------------" >> $receipt
