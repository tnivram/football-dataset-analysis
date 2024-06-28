# Football Dataset Analysis⚽
## Questions and Answers


**1)** List the top 10 teams with the most total goals scored. 

````sql
SELECT 
    ts.team_id, ANY_VALUE(t.name) AS team_name, SUM(goals) AS total_goal
FROM 
    team_stats ts
JOIN 
    teams t 
ON 
    t.team_id = ts.team_id
GROUP BY 
    team_id
ORDER BY 
    total_goal DESC
LIMIT 10;
````

**Answer:** 

team_id | team_name | total_goal |
--------|-----------|------------|
148 | Barcelona	| 698 |
161	| Paris Saint Germain | 642
117	| Bayern Munich | 628
150	| Real Madrid | 628
88	| Manchester City | 620
105	| Napoli	| 542
98	| Juventus	| 533
87	| Liverpool	| 519
129	| Borussia Dortmund | 505
95	| Roma | 499



**2)** What is the most goal scored in a match? Mention the players, season, and the teams playing.
````sql
CREATE TEMPORARY TABLE get_matchup
SELECT 
    g.game_id, g.season, home_team.name AS home, away_team.name AS away
FROM 
    games g
JOIN 
    teams home_team ON home_team.team_id = g.home_team_id
JOIN 
    teams away_team ON away_team.team_id = g.away_team_id;

SELECT 
    pl.name, ap.goals AS 'goals scored in a game', mu.season, mu.home AS 'home team', mu.away AS 'away team'
FROM 
    appearances ap
JOIN 
    players pl ON ap.player_id = pl.player_id
JOIN 
    get_matchup mu ON ap.game_id = mu.game_id 
WHERE 
    ap.goals = (SELECT MAX(goals) from appearances)
ORDER BY 
    mu.season
;
````

**Answer:** 

name | goals scored in a game | season | home team | away team
--------|--------|--------|--------|--------|
Carlos Eduardo |5|	2014|	Guingamp|	Nice|
Cristiano Ronaldo|	5|	2014|	Real Madrid	| Granada |
Sergio Agüero|	5|	2015 |	Manchester City	| Newcastle United |
Robert Lewandowski|	5|	2015 | Bayern Munich |	Wolfsburg |
Cristiano Ronaldo|	5|	2015 | Espanyol	| Real Madrid |
Luka Jovic|	5|	2018|	Eintracht Frankfurt | Fortuna Duesseldorf |


**3)**  List the top 10 overall goal scorer and the amount of goals scored.
````sql
SELECT 
    ANY_VALUE(p.name) AS player, SUM(a.goals) AS total_goal
FROM 
    appearances a
JOIN 
    players p ON p.player_id = a.player_id
GROUP BY 
    a.player_id
ORDER BY 
    total_goal DESC
LIMIT 10;
````

**Answer:** 

player | total_goal
--------|--------|
Lionel Messi |	231
Cristiano Ronaldo |	215
Robert Lewandowski |	203
Luis Suárez |	168
Harry Kane |	163
Pierre-Emerick Aubameyang |	149
Ciro Immobile |	133
Edinson Cavani |	132
Sergio Agüero |	132
Mohamed Salah |	130

**4)** Who are the top goalscorer of each season?
````sql
WITH goals_per_season AS (
SELECT 
    ap.player_id, SUM(ap.goals) AS total_goals, g.season
FROM 
    appearances ap
JOIN 
    games g ON ap.game_id = g.game_id
GROUP BY 
    ap.player_id, g.season
ORDER BY 
    SUM(ap.goals) DESC
),
get_rank AS (
SELECT 
    *, ROW_NUMBER() OVER (PARTITION BY season ORDER BY total_goals DESC) AS rankings
FROM 
    goals_per_season
)

SELECT 
    pl.name, rk.total_goals, rk.season
FROM 
    get_rank rk
JOIN 
    players pl 
ON 
    rk.player_id = pl.player_id
WHERE 
    rankings = 1
ORDER BY 
    rk.season ASC;
````

**Answer:** 
name | total_goals | season |
--------|--------|--------|
Cristiano Ronaldo |	48 |	2014 |
Luis Suárez |	40 |	2015 |
Lionel Messi |	37 |	2016 |
Lionel Messi |	34 |	2017 |
Lionel Messi |	36 |	2018 |
Ciro Immobile |	36 |	2019 |
Robert Lewandowski |	41 |	2020 |


**5)**  Who are the top 10 goalscorer-assister? List the numbers of goals scored.
````sql
SELECT 
    ANY_VALUE(shooter.name) AS 'Goalscorer', ANY_VALUE(assister.name) AS 'Assister', COUNT(*) AS count
FROM 
    shots s
JOIN 
    players shooter ON shooter.player_id = s.shooter_id
JOIN 
    players assister ON assister.player_id = s.assister_id
WHERE 
    (s.assister_id IS NOT NULL) AND (s.shot_result = 'Goal')
GROUP BY 
    shooter_id, assister_id
ORDER BY 
    count DESC
LIMIT 10;
````

**Answer:** 

Goalscorer |Assister | Goals Scored
--------|--------|--------|
Lionel Messi |	Luis Suárez |	34
Robert Lewandowski	| Thomas Müller |	34
Luis Suárez	 | Lionel Messi	| 32
Sergio Agüero |	Kevin De Bruyne |	19
Harry Kane |	Son Heung-Min |	18
Harry Kane |	Christian Eriksen |	18
Edinson Cavani |	Ángel Di María |	17
Mauro Icardi |	Ivan Perisic |	16
Cristiano Ronaldo |	Karim Benzema |	16
Luis Suárez	| Sergi Roberto |	16


**6)**  Who are the top 10 freekick goalscorer?
````sql
SELECT 
    ANY_VALUE(p.name) AS player_name, COUNT(*) AS freekick_goal
FROM 
    shots s
JOIN 
    players p 
ON 
    p.player_id = s.shooter_id 
WHERE 
    situation = 'DirectFreekick' AND shot_result = 'Goal'
GROUP BY 
    shooter_id
ORDER BY 
    freekick_goal DESC
LIMIT 10;
````

**Answer:** 

player_name | freekick_goal
--------|--------|
Lionel Messi	| 28
Daniel Parejo	| 11
Miralem Pjanic	| 11
Aleksandar Kolarov	| 10
Hakan Calhanoglu	| 10
James Ward-Prowse	| 10
Paulo Dybala	| 10
Christian Eriksen	| 8
Iago Aspas	| 7
Antoine Griezmann	| 7



**7)** What are the percentage of freekicks scored?
````sql
SELECT 
    shot_result,
    CONCAT(COUNT(*), ' (', ROUND(100*COUNT(*)/(SUM(COUNT(*)) OVER ()), 2), '%)') AS count
FROM 
    shots 
WHERE 
    situation = 'DirectFreekick' 
GROUP BY 
    shot_result
LIMIT 10;
````

**Answer:** 

shot_result | count
--------|----------|
BlockedShot	| 4802 (33.23%) |
MissedShots	| 4876 (33.74%)|
Goal	| 868 (6.01%)|
SavedShot |	3459 (23.94%)|
ShotOnPost |	446 (3.09%)|



 To be continued....


