#! /bin/bash
if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE games, teams;")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    # Checking Winner_ID
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")        
    # if not found
    if [[ -z $WINNER_ID ]]
    then
      # insert Winner_ID
      INSERT_WINNER_ID_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      
      if [[ $INSERT_WINNER_ID_RESULT == "INSERT 0 1" ]]
      then
        echo "Inserted into Teams, $WINNER"
      fi
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi

    # Checking Now Opponent
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")    
    if [[ -z $OPPONENT_ID ]]
    then
      # insert OPPONENT_ID
      INSERT_OPPONENT_ID_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")      
      if [[ $INSERT_OPPONENT_ID_RESULT == "INSERT 0 1" ]]
      then
        echo "Inserted into Teams, $OPPONENT"
      fi
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")      
    fi
    INSERT_GAMES_RESULT=$($PSQL "INSERT INTO games(year,round,winner_goals,opponent_goals,opponent_id,winner_id) VALUES('$YEAR','$ROUND','$WINNER_GOALS','$OPPONENT_GOALS','$OPPONENT_ID','$WINNER_ID')")
    if [[ $INSERT_GAMES_RESULT == "INSERT 0 1" ]]
    then
      echo "Inserted into Games, $YEAR ,$ROUND, $WINNER_GOALS, $OPPONENT_GOALS"
    fi
  fi  
done

# while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
# do
#     # Skip the header line
#     if [[ $YEAR != "year" ]]; then
#         # Checking if the winner exists in teams table
#         WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
        
#         # If winner does not exist, insert into teams table
#         if [[ -z $WINNER_ID ]]; then
#             # Insert winner into teams table
#             $PSQL "INSERT INTO teams(name) VALUES ('$WINNER')"
#             echo "Inserted into Teams: $WINNER"
#             # Retrieve the winner's ID
#             WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
#         fi
        
#         # Checking if the opponent exists in teams table
#         OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
        
#         # If opponent does not exist, insert into teams table
#         if [[ -z $OPPONENT_ID ]]; then
#             # Insert opponent into teams table
#             $PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')"
#             echo "Inserted into Teams: $OPPONENT"
#             # Retrieve the opponent's ID
#             OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
#         fi
        
#         # Insert game data into games table
#         $PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)"
#         echo "Inserted into Games: $YEAR, $ROUND, $WINNER vs $OPPONENT"
#     fi
# done < games.csv