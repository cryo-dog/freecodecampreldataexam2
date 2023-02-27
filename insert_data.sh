#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "truncate teams, games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    # Add winner
    # Get winner name
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    #echo -e "Winner ID is $WINNER_ID"
    # If not existing
    if [[ -z $WINNER_ID ]]
    then
      # Add winner
      INSERT_WINNER=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      #if [[ $INSERT_WINNER == "INSERT 0 1" ]]
      #then
      #  echo Inserted Winner $WINNER
      #fi
      # Get new winner ID
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi 

    # Same for adding the opp.
    # Get opp name
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    #echo -e "OPPONENT ID is $OPPONENT_ID"
    # If not existing
    if [[ -z $OPPONENT_ID ]]
    then
      # Add opp
      INSERT_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      #if [[ $INSERT_OPPONENT == "INSERT 0 1" ]]
      #then
      #  echo Inserted opponent $OPPONENT
      #fi
      # Get new opp ID
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi
    

    # Add game
    # Add all data at ones using winner_id and opponent_id
    INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    # Echo full line and show that added
    
    #if [[ $INSERT_GAME == "INSERT 0 1" ]]
    #then
    
    #  echo Inserted games: $YEAR, $ROUND, $WINNER_ID:$WINNER, $OPPONENT_ID:$OPPONENT, $WINNER_GOALS, $OPPONENT_GOALS

    #fi





  fi

done