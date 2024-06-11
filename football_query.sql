USE football;


-- TOP 10 TEAMS WITH MOST TOTAL GOALS FROM 2014-2020
SELECT ts.team_id, ANY_VALUE(t.name) AS team_name, SUM(goals) AS total_goal
FROM team_stats ts
JOIN teams t ON t.team_id = ts.team_id
GROUP BY team_id
ORDER BY total_goal DESC
LIMIT 10;




-- PLAYER WITH THE MOST GOAL IN ONE MATCH
-- Make temporary table to store game id and each respective home and away team
CREATE TEMPORARY TABLE get_matchup
SELECT g.game_id, g.season, home_team.name AS home, away_team.name AS away
FROM games g
JOIN teams home_team ON home_team.team_id = g.home_team_id
JOIN teams away_team ON away_team.team_id = g.away_team_id;

SELECT pl.name, ap.goals AS 'goals scored in a game', mu.season, mu.home AS 'home team', mu.away AS 'away team'
FROM appearances ap
JOIN players pl ON ap.player_id = pl.player_id
JOIN get_matchup mu ON ap.game_id = mu.game_id 
WHERE ap.goals = (SELECT MAX(goals) from appearances)
ORDER BY mu.season
;

-- OVERALL TOP GOALSCORER
SELECT ANY_VALUE(p.name) AS player, SUM(a.goals) AS total_goal
FROM appearances a
JOIN players p ON p.player_id = a.player_id
GROUP BY a.player_id
ORDER BY total_goal DESC
LIMIT 10;

-- TOP GOALSCORER OF EACH SEASON
WITH goals_per_season AS (
SELECT ap.player_id, SUM(ap.goals) AS total_goals, g.season
FROM appearances ap
JOIN games g ON ap.game_id = g.game_id
GROUP BY ap.player_id, g.season
ORDER BY SUM(ap.goals) DESC
),
get_rank AS (
SELECT *,
ROW_NUMBER() OVER (PARTITION BY season ORDER BY total_goals DESC) AS rankings
FROM goals_per_season
)
SELECT pl.name, rk.total_goals, rk.season
FROM get_rank rk
JOIN players pl ON rk.player_id = pl.player_id
WHERE rankings = 1
ORDER BY rk.season ASC;

-- TOP 10 GOALSCORER-ASSISTER
SELECT ANY_VALUE(shooter.name) AS 'Goalscorer', ANY_VALUE(assister.name) AS 'Assister', COUNT(*) AS count
FROM shots s
JOIN players shooter ON shooter.player_id = s.shooter_id
JOIN players assister ON assister.player_id = s.assister_id
WHERE (s.assister_id IS NOT NULL) AND (s.shot_result = 'Goal')
GROUP BY shooter_id, assister_id -- shooter.name, assister.name
ORDER BY count DESC
LIMIT 10;

-- TOP 10 FREEKICK SCORER
SELECT ANY_VALUE(p.name) AS player_name, COUNT(*) AS freekick_goal
FROM shots s
JOIN players p ON p.player_id = s.shooter_id 
WHERE situation = 'DirectFreekick' AND shot_result = 'Goal'
GROUP BY shooter_id
ORDER BY freekick_goal DESC
LIMIT 10;

-- PERCENTAGE OF FREEKICK
SELECT shot_result,
CONCAT(COUNT(*), ' (', ROUND(100*COUNT(*)/(SUM(COUNT(*)) OVER ()), 2), '%)') AS count
FROM shots 
WHERE situation = 'DirectFreekick' 
GROUP BY shot_result
LIMIT 10;
