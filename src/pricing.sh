#!/bin/bash

size_price=(1.00 2.00 3.00 4.00)
crust=(0.50 1.00 2.00)
GrandTotal=0

pizzafile="running-order.txt"

#--------------------------------size-----------------
calculate_single_pizza()
{

if [[ "$sz" == "Small" ]]; then
 pizza_size_price=${size_price[0]}

elif [[ "$sz" == "Medium" ]]; then
pizza_size_price=${size_price[1]}

elif [[ "$sz" == "Large" ]]; then
pizza_size_price=${size_price[2]}

elif
 [[ "$sz" == "Xlarge" ]]; then
pizza_size_price=${size_price[3]}

fi
echo "$pizza_size_price"
#--------------------------toppings price------------
if [[ "$tps" == "pepperoni" ]]; then
tp=1.00

elif [[ "$tps" == "olives" ]]; then
tp=1.00

elif [[ "$tps" == "onions" ]]; then
tp=1.00

fi
echo "$tp"
#--------------------------crust price---------------

if [[ "$crt" == "regular" ]]; then
crust_price=${crust[0]}

elif [[ "$crt" == "thin" ]]; then
crust_price=${crust[1]}

elif [[ "$crt" == "stuffed" ]]; then
crust_price=${crust[2]}
fi
echo "$crust_price"
total=$(echo "scale=2; $pizza_size_price+$tp+$crust_price" | bc)
GrandTotal=$(echo "scale=2; $GrandTotal+$total" | bc)
echo " "
echo  -e "\e[1;32m The total will be: $total \e[0m"

echo " "
}


calculate_mupltiple_pizza()
{
counter=0
while read line; do
          if [[ "$counter" == '0' ]]; then
            (( counter ++))
             continue
          fi
           sz=$(echo $line | cut -f1 -d ' ')
           crt=$(echo $line | cut -f2 -d ' ')
           tps=$(echo $line | cut -f3 -d ' ')
echo "$sz $crt $tps "

calculate_single_pizza

(( counter++ ))
done < $pizzafile

}
calculate_mupltiple_pizza

Tax=$(echo "scale=2; ($total*0.025)" | bc)
echo  -e "\e[1;32m The Tax will be: $Tax \e[0m"
echo  -e "\e[1;32m The Grand Total will be: $GrandTotal \e[0m"









