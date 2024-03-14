DROP TABLE IF EXISTS 2022seriespost;
CREATE TABLE 2022seriespost LIKE seriespost;
INSERT INTO 2022seriespost SELECT * FROM seriespost;

DROP TABLE IF EXISTS tmp;
CREATE TEMPORARY TABLE tmp
(
  teamIDwinner char(3),
  teamIDloser char(3),
  yearID smallint(6),
  round varchar(5),
  wins smallint(6),
  Loses smallint(6),
  ties smallint(6)
);

LOAD DATA LOCAL INFILE 'seriespost2022.csv' INTO TABLE tmp
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@teamIDwinner, @teamIDloser, @yearID, @round, @wins, @loses, @ties)
SET
teamIDwinner = @teamIDwinner,
teamIDloser = @teamIDloser,
yearID = @yearID,
round = @round,
wins = @wins,
loses = @loses,
ties = @ties;

INSERT INTO 2022seriespost(teamIDwinner, teamIDloser, yearID, round, wins, loses, ties)
SELECT teamIDwinner, teamIDloser, yearID, round, wins, loses, ties FROM tmp;