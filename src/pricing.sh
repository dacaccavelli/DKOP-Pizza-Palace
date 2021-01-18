#!/bin/bash

size_price=(1.00 2.00 3.00 4.00)
crust=(0.50 1.00 2.00)

pizzafile="running-order.txt"

#--------------------------------size-----------------
calculate-single-pizza()
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
#echo "$pizza_size_price"
#--------------------------toppings price------------
if [[ "$tps" == "pepperoni" ]]; then
tp=1.00

elif [[ "$tps" == "olives" ]]; then
tp=1.00

elif [[ "$tps" == "onions" ]]; then
tp=1.00

fi
#echo "$tp"
#--------------------------crust price---------------

if [[ "$crt" == "regular" ]]; then
crust_price=${crust[0]}

elif [[ "$crt" == "thin" ]]; then
crust_price=${crust[1]}

elif [[ "$crt" == "stuffed" ]]; then
crust_price=${crust[2]}
fi
#echo "$crust_price"
total=$(echo "scale=2; $pizza_size_price+$tp+$crust_price" | bc)
}


calculate-multiple-pizzas()
{

subtotal=0
counter=0
while read line; do
          if [[ "$counter" == '0' ]]; then
            (( counter ++))
             continue
          fi
           sz=$(echo $line | cut -f1 -d ' ')
           crt=$(echo $line | cut -f2 -d ' ')
           tps=$(echo $line | cut -f2 -d ':')
echo "$sz $crt $tps "

calculate-single-pizza
echo $total

subtotal=$(echo "scale=2; $subtotal+$total" | bc)
(( counter++ ))
done < $pizzafile

echo " "
echo  -e "\e[1;32m The subtotal will be: $subtotal \e[0m"

echo " "
tax=$(echo "scale=2; ($subtotal*0.05)" | bc)
echo  -e "\e[1;32m The Tax will be: $tax \e[0m"
grand_total=$(echo "scale=2; $subtotal+$tax" | bc)
echo  -e "\e[1;32m The Grand Total will be: $grand_total \e[0m"
read
}
