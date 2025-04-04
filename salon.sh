#!/bin/bash
# chmod +x salon.sh

# PSQL="psql -X --username=freecodecamp --dbname=salon --no-align --tuples-only -c"
PSQL="psql -X --username=postgres --dbname=salon --no-align --tuples-only -c"

# Display welcome message
echo -e "\n~~~~~ THE SALON ~~~~~\n"
echo -e "Welcome to the salon, which service would you like today?\n"

# Display services function
DISPLAY_SERVICES() {
    # if an argument is passed to this function, display it
    if [[ $1 ]]; then
        echo -e "\n$1"
    fi

    # Welcome the customer and display the available services
    # echo "Which service would you like today?"

    SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
    echo "$SERVICES" | while IFS="|" read SERVICE_ID SERVICE_NAME; do
        echo "$SERVICE_ID) $SERVICE_NAME"
    done

    # read the user's selection
    read SERVICE_ID_SELECTED

    # validate user's selection
    SERVICE_AVAILABILITY=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")

    if [[ -z $SERVICE_AVAILABILITY ]]; then
        DISPLAY_SERVICES "I could not find that service. What would you like today?"
    else
        GET_CUSTOMER_INFO
    fi

}

# Get customer info function
GET_CUSTOMER_INFO() {
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE

    # check if customer exists in database
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

    if [[ -z $CUSTOMER_NAME ]]; then
        echo -e "\nI don't have a record for that phone number, what's your name?"
        read CUSTOMER_NAME
        INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('CUSTOMER_NAME', 'CUSTOMER_PHONE')")
    fi

    # proceed to schedule the appointment
    SCHEDULE_APPOINTMENT

}

SCHEDULE_APPOINTMENT() {}

# Start the script by calling the display services function
DISPLAY_SERVICES
