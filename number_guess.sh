#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess --tuples-only -c"

  if $PSQL "CREATE TABLE IF NOT EXISTS users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(23) NOT NULL UNIQUE);"
  then
    echo "New Table created or existing Table used"
  else
    echo "Error creating a new Table"
    exit 1
  fi

  if $PSQL "CREATE TABLE IF NOT EXISTS games (
    game_id SERIAL PRIMARY KEY,
    number_guesses INT NOT NULL,
    user_id INT REFERENCES users(user_id)
    );"
  then
    echo "Game table created or using existing"
  else
    echo "Error creating game Table"
    exit 1
  fi

  #request user input.
  echo "Enter your username:"
  read USERNAME

  USERNAME_AVAIL=$($PSQL "SELECT username FROM users WHERE username='$USERNAME'")
  GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM users INNER JOIN games USING (user_id) WHERE username='$USERNAME'")
  BEST_GAME=$($PSQL "SELECT MIN(number_guesses) FROM users INNER JOIN games USING (user_id) WHERE username='$USERNAME'")

  if [[ -z $USERNAME_AVAIL ]]
    then
      INSERT_USER=$($PSQL "INSERT INTO users (username) VALUES ('$USERNAME')")
      echo "Welcome, $USERNAME! It looks like this is your first time here."
    else
      echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  fi

  RANDOM_NUM=$((1 + $RANDOM % 1000))
  echo Random number is $RANDOM_NUM
  GUESS=1
  echo "Guess the secret number between 1 and 1000:"

    while read NUM
    do
      if [[ ! $NUM =~ ^[0-9]+$ ]]
        then
        echo "That is not an integer, guess again:"
        else
          if [[ $NUM -eq $RANDOM_NUM ]]
          then
          break;
          else
            if [[ $NUM -gt $RANDOM_NUM ]]
            then
              echo -n "It's higher than that, guess again:"
            elif [[ $NUM -lt $RANDOM_NUM ]]
            then
              echo -n "It's lower than that, guess again:"
            fi
          fi
      fi
      GUESS=$(( $GUESS + 1 ))
    done 

    if [[ $GUESS == 1 ]]
      then
        echo "You guessed it in $GUESS tries. The secret number was $RANDOM_NUM. Nice job!"
      else
        echo "You guessed it in $GUESS tries. The secret number was $RANDOM_NUM. Nice job!"
    fi
USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")
INSERT_GAME=$($PSQL "INSERT INTO games(number_guesses, user_id) VALUES ('$GUESS', '$USER_ID')")


#   C_USERNAME=$($PSQL "SELECT username FROM users WHERE username='$USERNAME'" | sed -E 's/^ *| *$//g')
#   USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'" | sed -E 's/^ *| *$//g')
#   BEST_GAME=$($PSQL "SELECT best_game FROM users WHERE username='$USERNAME'" | sed -E 's/^ *| *$//g')
#   GAMES_PLAYED=$($PSQL "SELECT games_played FROM users WHERE username='$USERNAME'" | sed -E 's/^ *| *$//g')

#   if [[ -z $C_USERNAME ]]
#     then 
#       echo "Welcome, $USERNAME! It looks like this is your first time here."
#       NEW_USER=$($PSQL "INSERT INTO users (username) VALUES ('$USERNAME')")
#       if [[ $NEW_USER == 'INSERT 0 1' ]]
#         then 
#           echo "$USERNAME added to Database"
#       fi
#   else
#     echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
#   fi
#   RUN_GAME
# }

# RUN_GAME() {
#   #generate random number
#   RANDOM_NUMBER=$(((RANDOM % 1000) + 1))
#   echo $RANDOM_NUMBER

#   #initialize number of guess
#   NUMBER_OF_GUESSES=0


#   echo -e "\nGuess the secret number between 1 and 1000:"
#   while true
#     do
#       read SECRET_NUMBER

#       if [[ ! $SECRET_NUMBER =~ ^[0-9]+$ ]]
#         then
#           echo "That is not an integer, guess again:"
#           continue
#       fi

#       #increment number of guesses
#       NUMBER_OF_GUESSES=$((NUMBER_OF_GUESSES + 1))

#       #check the guesses
#       if (( SECRET_NUMBER < RANDOM_NUMBER ))
#         then
#           echo "It's lower than that, guess again:"
#       elif (( SECRET_NUMBER > RANDOM_NUMBER ))
#         then
#           echo "It's higher than that, guess again:"
#       else
#         echo You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $RANDOM_NUMBER. Nice job!\

#         if [[ -z $USER_ID ]]
#           then
#             $PSQL "update users set games_played=1, best_game=$NUMBER_OF_GUESSES where username='$USERNAME'"
#           else
#             GAMES_PLAYED=$((GAMES_PLAYED + 1))
#             if [[ $GAMES_PLAYED -eq 0 || $NUMBER_OF_GUESSES -lt $BEST_GAME ]]
#             then
#               BEST_GAME=$NUMBER_OF_GUESSES
#             fi
#             $PSQL "UPDATE users SET games_played='$GAMES_PLAYED', best_game='$BEST_GAME' where user_id='$USER_ID'"
#         fi
#         break
#       fi
#   done
# }

# DISPLAY

# with $USERNAME being a users name from the database, $GAMES_PLAYED being the total number of games that user has played, and $BEST_GAME being the fewest number of guesses it took that user to win the game

#USER_INFO=$($PSQL "SELECT user_id, games_played, best_game FROM users WHERE username='$USERNAME'")
#USER_INFO=$(echo "$USER_INFO" | sed -E 's/^ *| *$//g')
#USER_INFO=${USER_INFO//|/ }

#IFS=" " read USER_ID GAMES_PLAYED BEST_GAME <<< "$USER_INFO"
#GAMES_PLAYED=${GAMES_PLAYED:-0}
#BEST_GAME=${BEST_GAME:-0}



  #USER_ID=$1
  #USERNAME=$2
  #GAMES_PLAYED=$3
  #BEST_GAME=$4



# DISPLAY() {
#   CREATE_TABLE
#   echo Enter your username:
#   read USERNAME

#   CHECK_USERNAME=$($PSQL "SELECT username FROM users WHERE username='$USERNAME'")
#   GAMES_PLAYED=$($PSQL "SELECT games_played FROM users WHERE username='$USERNAME'")
#   BEST_GAME=$($PSQL "SELECT best_game FROM users WHERE username='$USERNAME'")
#   USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")

#   if [[ -z $CHECK_USERNAME ]]
#     then
#       echo Welcome, $USERNAME! It looks like this is your first time here.
#       NEW_USER=$($PSQL "INSERT INTO users (username) VALUES ('$USERNAME')")
#       if [[ $NEW_USER == 'INSERT 0 1' ]]
#         then 
#           echo "$USERNAME added to Database"
#       fi
#     else
#       echo Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses.
#   fi
# }

# DISPLAY