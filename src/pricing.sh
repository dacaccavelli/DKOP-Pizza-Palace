#!/bin/bash

size_prices=(5.00 6.00 7.00 8.00)
crust_prices=(5.00 6.00 7.00 8.00)
price_per_topp=1

#--------------------------------size-----------------
calculate-single-pizza()
{
sz=$1
sz=${sz,,}
crust=$2
crust=${crust,,}
topp_count=$3

if [[ "$sz" == "small" ]]; then
 pizza_size_price=${size_prices[0]}

elif [[ "$sz" == "medium" ]]; then
pizza_size_price=${size_prices[1]}

elif [[ "$sz" == "large" ]]; then
pizza_size_price=${size_prices[2]}

elif
 [[ "$sz" == "xlarge" ]]; then
pizza_size_price=${size_prices[3]}

fi
#echo "$pizza_size_price"
#--------------------------toppings price------------
#if [[ "$tps" == "pepperoni" ]]; then
#tp=1.00
#
#elif [[ "$tps" == "olives" ]]; then
#tp=1.00
#
#elif [[ "$tps" == "onions" ]]; then
#tp=1.00
#
#fi
##echo "$tp"
#--------------------------crust price---------------

if [[ "$crust" == "thin" ]]; then
crust_price=${crust_prices[0]}

elif [[ "$crust" == "regular" ]]; then
crust_price=${crust_prices[1]}

elif [[ "$crust" == "thick" ]]; then
crust_price=${crust_prices[2]}

elif [[ "$crust" == "stuffed" ]]; then
crust_price=${crust_prices[3]}
fi
#echo "$crust_price"

tp=$(( $topp_count * $price_per_topp ))
total=$(echo "scale=2; $pizza_size_price+$tp+$crust_price" | bc)

# Storing variable if called as single pizza calculation
if [ ! -z "${1}" ]; then
        echo $total >> $temppizza
fi

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
