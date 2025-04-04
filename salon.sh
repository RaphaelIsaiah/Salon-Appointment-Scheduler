#!/bin/bash
# chmod +x salon.sh

# PSQL="psql -X --username=freecodecamp --dbname=salon --no-align --tuples-only -c"
PSQL="psql -X --username=postgres --dbname=salon --no-align --tuples-only -c"

# Display welcome message
echo -e "\n~~~~~ THE SALON ~~~~~\n"
echo -e "Welcome to the salon, which service would you like today?\n"

# Display services function
MAIN_MENU() {
    # if an argument is passed to this function, display it
    if [[ $1 ]]; then
        echo -e "\n$1"
    fi

    SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
    echo "$SERVICES" | while IFS="|" read SERVICE_ID SERVICE_NAME; do
        echo "$SERVICE_ID) $SERVICE_NAME"
    done

    # Add an exit option
    echo "0) Exit"

    # read the user's selection
    read SERVICE_ID_SELECTED

    # Validate service selection or handle exit
    if [[ $SERVICE_ID_SELECTED -eq 0 ]]; then
        EXIT
    else
        SELECTED_SERVICE=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
        if [[ -z $SELECTED_SERVICE ]]; then
            DISPLAY_SERVICES "I could not find that service. What would you like today?"
        else
            GET_CUSTOMER_INFO
        fi
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
        INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
    fi

    # get customer id
    CUSTOMER_ID=$($PSQL "SELECT customer_id from customers WHERE phone = '$CUSTOMER_PHONE'")

    # proceed to schedule the appointment
    SCHEDULE_APPOINTMENT

}

# schedule appointment function
SCHEDULE_APPOINTMENT() {
    echo -e "\nWhat time would you like your $SELECTED_SERVICE, $CUSTOMER_NAME?"
    read SERVICE_TIME

    # insert appointment to the database
    INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(time, service_id, customer_id) VALUES('$SERVICE_TIME', $SERVICE_ID_SELECTED, $CUSTOMER_ID)")

    # confirm the booking
    echo -e "\nI have put you down for a $SELECTED_SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."

    # Reset variables
    SERVICE_TIME=""
    SERVICE_ID_SELECTED=""
    SELECTED_SERVICE=""
    CUSTOMER_NAME=""
    CUSTOMER_PHONE=""
    CUSTOMER_ID=""

    # Redirect to main menu
    MAIN_MENU "Would you like to book another service?"
}

EXIT() {
    echo -e "\nThank you for visiting the salon. Have a great day!\n"
    exit 0 # This exits the script successfully with status code 0
}

# Start the script by calling the display services function
MAIN_MENU
