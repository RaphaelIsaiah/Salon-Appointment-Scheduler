#!/bin/bash
# chmod +x salon.sh

# PSQL="psql -X --username=freecodecamp --dbname=salon --no-align --tuples-only -c"
PSQL="psql -X --username=postgres --dbname=salon --no-align --tuples-only -c"

# Display welcome message
echo -e "\n~~~~~ THE SALON ~~~~~\n"

# The main menu function
DISPLAY_SERVICES() {
    # if an argument is passed to this function, display it
    if [[ $1 ]]; then
        echo -e "\n$1"
    fi

    # Welcome the customer and display the available services
    echo -e "Welcome to the salon, how can I help you?\n"
    echo "Which service would you like today?"

    SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
    echo "$SERVICES" | while IFS="|" read SERVICE_ID SERVICE_NAME; do
        echo "$SERVICE_ID) $SERVICE_NAME"
    done

    # read the user's selection
    read SERVICE_ID_SELECTED

    # validate user's selection
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")

    if [[ -z $SERVICE_NAME ]]; then
        DISPLAY_SERVICES "I could not find that service. What would you like today?"
    else
        GET_CUSTOMER_INFO
    fi

}

# Start the script by calling the display services function
DISPLAY_SERVICES
