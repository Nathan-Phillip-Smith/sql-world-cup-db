#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

#Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE TABLE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != "winner" ]]
        then
          # get team name
          WINNER_TEAM_NAME=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
            #if not found include new team
            if [[ -z $WINNER_TEAM_NAME ]]
              then
              #insert team
              INSERT_WINNER_TEAM_NAME= $($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
                if [[ $INSERT_WINNER_TEAM_NAME == "INSERT 0 1" ]]
                  then
                    echo Inserted $WINNER 
                fi
            fi
      fi

    # GET OPPONENT TEAM NAME

      if [[ $OPPONENT != "opponent" ]]
        then
          # get team name
          OPPONENT_TEAM_NAME=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
            #if not found include new team 
            if [[ -z $OPPONENT_TEAM_NAME ]]
              then
              #insert team
              INSERT_OPPONENT_TEAM_NAME= $($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
                if [[ $INSERT_OPPONENT_TEAM_NAME == "INSERT 0 1" ]]
                  then
                    echo Inserted $OPPONENT
                fi
            fi
      fi

  if [[ $YEAR != "year" ]]
  then
    # get winner_id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    # get opponent_id
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    
      # insert GAME
      INSERT_GAME_RESULT= $($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$YEAR', '$ROUND','$WINNER_ID','$OPPONENT_ID','$WINNER_GOALS', '$OPPONENT_GOALS')")
      if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into games, $YEAR : $ROUND
      fi

      # get new game_id
      GAME_ID=$($PSQL "SELECT game_id FROM games WHERE year='$YEAR'")
    
    fi
    done