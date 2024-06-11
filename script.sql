CREATE DATABASE IF NOT EXISTS football;

USE football;

-- TEAMS
DROP TABLE teams;
CREATE TABLE IF NOT EXISTS teams(
team_id INT,
name TEXT
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/teams.csv'
INTO TABLE teams
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- LEAGUES
CREATE TABLE IF NOT EXISTS leagues(
id INT,
name TEXT,
notation TEXT
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/leagues.csv'
INTO TABLE leagues
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- PLAYERS
DROP TABLE players;
CREATE TABLE IF NOT EXISTS players(
player_id INT,
name TEXT
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/players.csv'
INTO TABLE players
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- APPEARANCES
DROP TABLE appearances;
CREATE TABLE IF NOT EXISTS appearances(
game_id INT,
player_id INT,
goals INT,
ownGoals INT,
shots INT,
xg DOUBLE,
xgchain DOUBLE,
xgbuildup DOUBLE,
assists INT,
key_passes INT,
xassists DOUBLE,
position TEXT,
position_order INT,
yellow_card INT,  
red_card INT,
time INT,
substitute_in INT,
substitute_out INT,
league_id INT
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/appearances.csv'
INTO TABLE appearances
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- SHOTS 
DROP TABLE shots;
CREATE TABLE IF NOT EXISTS shots(
game_id INT,
shooter_id INT,
assister_id INT,
minute INT,
situation TEXT,
last_action TEXT,
shot_type TEXT,
shot_result TEXT,
xg DOUBLE,
position_x DOUBLE,
position_y DOUBLE
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/shots.csv'
INTO TABLE shots
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- GAMES 
DROP TABLE games;
CREATE TABLE IF NOT EXISTS games(
game_id INT,
league_id INT,
season INT,
date DATETIME,
home_team_id INT,
away_team_id INT,
home_goals INT,
away_goals INT,
home_prob DOUBLE,
draw_prob DOUBLE,
away_prob DOUBLE,
home_goal_ht INT,
away_goal_ht INT
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/games.csv'
INTO TABLE games
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- TEAMSTATS
DROP TABLE team_stats;
CREATE TABLE IF NOT EXISTS team_stats(
game_id INT,
team_id INT,
season INT,
date DATETIME,
location VARCHAR(1),
goals INT,
xg DOUBLE,
shots INT,
shots_on_target INT,
deep INT,
ppda DOUBLE,
fouls INT,
corners INT,
yellow_cards INT,
red_cards INT,
result VARCHAR(1)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/teamstats.csv'
INTO TABLE team_stats
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;