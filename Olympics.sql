CREATE DATABASE olympics;
USE olympics;


SELECT *
FROM athlete_events
Order by year;

-- listing the total games held

SELECT year, season, city 
FROM athlete_events
GROUP BY year, season, city
ORDER BY year DESC;

-- counting the total number of olympic games held
SELECT count(distinct games) as total_games
FROM athlete_events;


-- finding the average age of players on each team

Select cast(avg(Age) as unsigned)
From athlete_events
Group by Team;

-- average age of players during olympics

SELECT cast(AVG(av_age_per_country) as unsigned)
FROM (Select cast(avg(Age) as unsigned) AS av_age_per_country
From athlete_events
Group by Team) x;


-- counting the number of nations that participated in each year
-- finding the years where maximum and the minimum no. of countries participated
SELECT COUNT(DISTINCT noc) as no_nations, year, season
FROM athlete_events
GROUP BY year, season
Order by no_nations DESC;


-- -- year where maximum number of countries participated
SELECT 
	  no_nations, games
FROM (SELECT COUNT(DISTINCT noc) as no_nations, games
FROM athlete_events
GROUP BY games) y
WHERE no_nations = 207;


-- year where minimum number of countries participated
SELECT 
	  no_nations, games
FROM (SELECT COUNT(DISTINCT noc) as no_nations, games
FROM athlete_events
GROUP BY games) y
WHERE no_nations = 11;


-- which year had the highest number of participants
SELECT games
FROM athlete_events
WHERE COUNT(DISTINCT noc) = 207
;

-- the sport that was played in all summer olympics


-- -- how many summer olympics were played

SELECT count(distinct season) AS summer_counts, year
FROM athlete_events
WHERE season = "Summer"
Group BY year;


SELECT SUM(summer_counts)
FROM (SELECT count(distinct season) AS summer_counts, year
FROM athlete_events
WHERE season = "Summer"
Group BY year) a;

-- -- top 10 most played sports in olympics

SELECT COUNT(distinct year) as count_of_games, sport
FROM athlete_events
WHERE season = "Summer"
GROUP BY sport
Order by count_of_games DESC 
limit 10;

-- -- finding the sports that were played every year

SELECT sport, count_of_games
FROM (SELECT COUNT(distinct year) as count_of_games, sport
FROM athlete_events
WHERE season = "Summer"
GROUP BY sport) b
WHERE count_of_games = 29;

-- finding the sport that was only played once in the olympics
SELECT sport, count_of_games
FROM (SELECT COUNT(distinct year) as count_of_games, sport
FROM athlete_events
WHERE season = "Summer"
GROUP BY sport) b
WHERE count_of_games = 1;

-- which countries participated in all the olympic games
-- -- the number of games in which countries participated
SELECT noc, count(distinct games) as games_per_nation
FROM athlete_events
GROUP BY noc;

-- -- using CTE and joining two tables to find out which countries participated in all the olympics

SELECT d.games_per_nation, n.region
FROM (SELECT games_per_nation, noc
FROM (SELECT noc, count(distinct games) as games_per_nation
FROM athlete_events
GROUP BY noc) c 
WHERE games_per_nation = 51) d
JOIN noc_regions n on d.noc = n.noc;


-- total sports played in each olympic game

SELECT COUNT(DISTINCT sport) as sport_count, games
FROM athlete_events
Group BY games;


-- oldest athlete to win a gold medal

SELECT MAX(age)
FROM athlete_events
WHERE Medal = "Gold";

SELECT name, age, medal
FROM athlete_events
WHERE age = 64 AND medal = "Gold";

    
 -- ratio of male to female in all olympic games
 

  SELECT 
	sum(case when Sex = "M"then 1 else 0 end)/count(*) as m_ratio,
    sum(case when Sex = "F"then 1 else 0 end)/count(*) as f_ratio
FROM athlete_events;

-- OR
 
  SELECT 
	sum(case when Sex = "M"then 1 else 0 end)/sum(case when Sex = "F"then 1 else 0 end) as ratio
FROM athlete_events;


-- top 5 athletes who won the maximum gold medals

SELECT name, team, count(medal) as gold_medals
FROM athlete_events
WHERE medal="Gold"
GROUP BY name, team
ORDER BY gold_medals DESC
LIMIT 5;


-- top 5 athletes who won the maximum number of medals

SELECT name, team, count(medal) as medal_count
FROM athlete_events
GROUP BY name, team
ORDER BY medal_count
 DESC
LIMIT 5;


-- countries with maximum number of medals

SELECT team, count(medal) as medal_count
FROM athlete_events
GROUP BY team
ORDER BY medal_count DESC
LIMIT 10;

-- total gold, silver and bronze medals won by each country

SELECT team, 
	   sum(case when Medal = "Gold" then 1 else 0 end) as Gold,
       sum(case when Medal = "Silver"then 1 else 0 end) as Silver,
       sum(case when Medal = "Bronze"then 1 else 0 end) as Bronze
       
FROM athlete_events
GROUP BY team
ORDER BY Gold DESC;


-- List down total gold, silver and bronze medals won by each country corresponding to each olympic games

SELECT games, team, 
	   sum(case when Medal = "Gold"then 1 else 0 end) as Gold,
       sum(case when Medal = "Silver"then 1 else 0 end) as Silver,
       sum(case when Medal = "Bronze"then 1 else 0 end) as Bronze
       
FROM athlete_events
GROUP BY games, team
ORDER BY games;

SELECT distinct team
FROM athlete_events;


 
 
 
 






