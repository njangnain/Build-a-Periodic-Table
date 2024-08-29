#!/bin/bash

# Set PSQL variable for querying the database
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Check if an argument is provided
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  # Check if the argument is a number (atomic_number)
  if [[ $1 =~ ^[0-9]+$ ]]; then
    QUERY_CONDITION="elements.atomic_number = $1"
  else
    # If it's not a number, it could be a symbol or name
    QUERY_CONDITION="elements.symbol = '$1' OR elements.name = '$1'"
  fi
  
  # Query to fetch element details
  ELEMENT_INFO=$($PSQL "SELECT elements.atomic_number, elements.name, elements.symbol, types.type, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius FROM elements JOIN properties ON elements.atomic_number = properties.atomic_number JOIN types ON properties.type_id = types.type_id WHERE $QUERY_CONDITION;")

  # Check if ELEMENT_INFO is not empty
  if [[ -z $ELEMENT_INFO ]]
  then
    echo "I could not find that element in the database."
  else
    echo "$ELEMENT_INFO" | while IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi
fi

