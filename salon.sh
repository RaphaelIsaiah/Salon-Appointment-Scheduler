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

    # Display main menu options
    echo -e "Welcome to the salon, how can I help you?\n"
    echo "These are the services we offer:"

    SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
    echo "$SERVICES" | while IFS="|" read SERVICE_ID SERVICE_NAME; do
        echo "$SERVICE_ID) $SERVICE_NAME"
    done
}

# Start the script by calling the main menu
DISPLAY_SERVICES
