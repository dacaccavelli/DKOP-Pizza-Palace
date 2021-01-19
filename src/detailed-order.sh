#!/bin/bash

# Will display the details of each pizza if requested

# sourcing functions from main.sh without actually running the file
source ./src/main.sh --source-only

display-details() {
# Displays the size, crust, list of toppings, and price for each pizza

	echo "------------------- DKOP Pizza Palace -------------------" | toilet -f term -F border --gay
        echo -e "\e[1;32m ------------------- Current Order ------------------------ \e[0m"
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
		tops_list=$(echo $line | cut -f2 -d ':')
                echo  -en "\x1b[35m"
		printf "%-64.64s\n" "$counter. $size, $crust w/ $tops_list"
                (( counter++ ))
        done < $pizzafile
        if [[ "$counter" == '1' ]]; then
                echo -e "\e[1;31m The order is currently empty \e[0m"
        fi
        echo -e "\e[1;32m ---------------------------------------------------------- \e[0m"

}
clear

display-details
read -p "Press any key to return to the previous menu"
