DROP TABLE IF EXISTS 2022people;
CREATE TABLE 2022people LIKE people;
INSERT INTO 2022people SELECT * FROM PEOPLE;

DROP TABLE IF EXISTS tmp;
CREATE TEMPORARY TABLE tmp
(
	playerID varchar(9),
	birthYear int(12),
	birthMonth int(12),
	birthDay int(12),
	birthCountry varchar(255),
	birthState varchar(255),
	birthCity varchar(255),
	deathYear int(12),
	deathMonth int(12),
	deathDay int(12),
	deathCountry varchar(255),
	deathState varchar(255),
	deathCity varchar(255),
	nameFirst varchar(255),
	nameLast varchar(255),
	nameGiven varchar(255),
	weight int(10),
	height int(10),
	bats varchar(255),
	throws varchar(255),
	debutDate date,
	finalGameDate date
);
LOAD DATA LOCAL INFILE 'people2022.csv' INTO TABLE tmp
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@rk, @name, @age, @debut, @last_game, @pos, @tm, @war, @height, @weight, @b, @t, @birthdate, @birthplace, @draft, @schools, @high_school, @givenname, @playerid, @empty)
SET
playerID = @playerid,
nameFirst = SUBSTRING_INDEX(@name, ' ', 1),
nameLast = SUBSTRING_INDEX(@name, ' ', -1),
bats = @b,
throws = @t,
weight = @weight,
height = @height,
nameGiven = @givenname;

INSERT INTO 2022people(playerID, nameFirst, nameLast, bats, throws, weight, height, nameGiven)
SELECT playerID, nameFirst, nameLast, bats, throws, weight, height, nameGiven FROM tmp WHERE playerID NOT IN (SELECT playerID FROM 2022people);







	