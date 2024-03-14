/* Add the 2022 data to the database */

/* People */
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

INSERT INTO people(playerID, nameFirst, nameLast, bats, throws, weight, height, nameGiven)
SELECT playerID, nameFirst, nameLast, bats, throws, weight, height, nameGiven FROM tmp WHERE playerID NOT IN (SELECT playerID FROM people);


/* Teams */
LOAD DATA LOCAL INFILE 'teams2022.csv' INTO TABLE teams
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;


/* Pitching */
DROP TABLE IF EXISTS tmp;
CREATE TEMPORARY TABLE tmp
(
	ID int(12),
	playerID varchar(9),
	yearID smallint(6),
	teamID char(3),
	stint smallint(4),
	p_W smallint(6),
	p_L smallint(6),
	p_G smallint(6),
	p_GS smallint(6),
	p_CG smallint(6),
	p_SHO smallint(6),
	p_SV smallint(6),
	p_IPOuts int(11),
	p_H smallint(6),
	p_ER smallint(6),
	p_HR smallint(6),
	p_BB smallint(6),
	p_SO smallint(6),
	p_BAOpp double,
	p_ERA double, 
	p_IBB smallint(6),
	p_WP smallint(6),
	p_HBP smallint(6),
	p_BK int(11),
	p_BFP smallint(6),
	p_GF smallint(6),
	p_R smallint(6),
	p_SH smallint(6),
	p_SF smallint(6),
	p_GIDP smallint(6)
);

LOAD DATA LOCAL INFILE 'pitching2022.csv' INTO TABLE tmp
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@rk, @name, @age, @tm, @lg, @w, @l, @w_l, @era, @g, @gs, @gf, @cg, @sho, @sv, @ip, @h, @r, @er, @hr, @bb, @ibb, @so, @hbp, @bk, @wp, @bf, @eraplus, @fip, @whip, @h9, @hr9, @bb9, @so9, @so_w, @nameadditional, @empty)
SET
playerID = @nameadditional,
yearID = 2022,
teamID = @tm,
p_W = @w,
p_L = @l,
p_G = @g,
p_GS = @gs,
p_CG = @cg,
p_SHO = @sho,
p_SV = @sv,
p_H = @h,
p_ER = @er,
p_HR = @hr,
p_BB = @bb,
p_SO = @so,
p_ERA = @era,
p_IBB = @ibb,
p_WP = @wp,
p_HBP = @hbp,
p_BK = @bk,
p_GF = @gf,
p_R = @r,
p_SH = @sh,
p_SF = @sf;

INSERT INTO pitching(playerID, yearID, teamID, p_W, p_L, p_G, p_GS, p_CG, p_SHO, p_SV, p_H, p_ER, p_HR, p_BB, p_SO, p_ERA, p_IBB, p_WP, p_HBP, p_BK, p_GF, p_R, p_SH, p_SF)
SELECT playerID, yearID, teamID, p_W, p_L, p_G, p_GS, p_CG, p_SHO, p_SV, p_H, p_ER, p_HR, p_BB, p_SO, p_ERA, p_IBB, p_WP, p_HBP, p_BK, p_GF, p_R, p_SH, p_SF FROM tmp;



/* Batting */
DROP TABLE IF EXISTS tmp;
CREATE TEMPORARY TABLE tmp
(
	batting_id int(12),
	playerID varchar(9),
	yearId smallint(6),
	teamID char(3),
	stint smallint(4),
	b_G smallint(6),
	b_AB smallint(6),
	b_R smallint(6),
	b_H smallint(6),
	b_2B smallint(6),
	b_3B smallint(6),
	b_HR smallint(6),
	b_RBI smallint(6),
	b_SB smallint(6),
	b_CS smallint(6),
	b_BB smallint(6),
	b_SO smallint(6),
	b_IBB smallint(6),
	b_HBP smallint(6),
	b_SH smallint(6),
	b_SF smallint(6),
	b_GIDP smallint(6)
);

LOAD DATA LOCAL INFILE 'batting2022.csv' INTO TABLE tmp
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@rk, @name, @age, @tm, @lg, @g, @pa, @ab, @r, @h, @2b, @3b, @hr, @rbi, @sb, @cs, @bb, @so, @ba, @obp, @slg, @ops, @opsplus, @tb, @gdp, @hbp, @sh, @sf, @ibb, @possummary, @nameadditional, @empty)
SET
playerID = @nameadditional,
yearId = 2022,
teamID = @tm,
b_G = @g,
b_AB = @ab,
b_R = @r,
b_H = @h,
b_2B = @2b,
b_3B = @3b,
b_HR = @hr,
b_RBI = @rbi,
b_SB = @sb,
b_CS = @cs,
b_BB = @bb,
b_SO = @so,
b_IBB = @ibb,
b_HBP = @hbp,
b_SH = @sh,
b_SF = @sf;

INSERT INTO batting (playerID, yearId, teamID, b_G, b_AB, b_R, b_H, b_2B, b_3B, b_HR, b_RBI, b_SB, b_CS, b_BB, b_SO, b_IBB, b_HBP, b_SH, b_SF)
SELECT playerID, yearId, teamID, b_G, b_AB, b_R, b_H, b_2B, b_3B, b_HR, b_RBI, b_SB, b_CS, b_BB, b_SO, b_IBB, b_HBP, b_SH, b_SF FROM tmp; 

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

INSERT INTO seriespost(teamIDwinner, teamIDloser, yearID, round, wins, loses, ties)
SELECT teamIDwinner, teamIDloser, yearID, round, wins, loses, ties FROM tmp;


/* Drop at end */
DROP TABLE IF EXISTS tmp;

/* Done adding 2022 data */

/* Bug fix - change batting/pitching/fielding so that they are one table for regular
             and the post season */

CREATE TABLE `fbatting` (
  `b_PK` int(12) NOT NULL AUTO_INCREMENT,
  `playerID` varchar(9) NOT NULL,
  `yearId` smallint(6) NOT NULL,
  `teamID` char(3) NOT NULL,
  `stint` smallint(4) DEFAULT NULL,
  `round` varchar(10) DEFAULT NULL,
  `b_G` smallint(6) DEFAULT NULL,
  `b_AB` smallint(6) DEFAULT NULL,
  `b_R` smallint(6) DEFAULT NULL,
  `b_H` smallint(6) DEFAULT NULL,
  `b_2B` smallint(6) DEFAULT NULL,
  `b_3B` smallint(6) DEFAULT NULL,
  `b_HR` smallint(6) DEFAULT NULL,
  `b_RBI` smallint(6) DEFAULT NULL,
  `b_SB` smallint(6) DEFAULT NULL,
  `b_CS` smallint(6) DEFAULT NULL,
  `b_BB` smallint(6) DEFAULT NULL,
  `b_SO` smallint(6) DEFAULT NULL,
  `b_IBB` smallint(6) DEFAULT NULL,
  `b_HBP` smallint(6) DEFAULT NULL,
  `b_SH` smallint(6) DEFAULT NULL,
  `b_SF` smallint(6) DEFAULT NULL,
  `b_GIDP` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`b_PK`),
  KEY `k_fbat_teams` (`teamID`),
  CONSTRAINT `fbatting_pibt` FOREIGN KEY (`playerID`) REFERENCES `people` (`playerID`)
) ENGINE=InnoDB AUTO_INCREMENT=110496 DEFAULT CHARSET=utf8mb3;


INSERT INTO fbatting (playerID, yearId, teamID, stint, b_G, b_AB, b_R, b_H, b_2B, b_3B, b_HR, b_RBI, b_SB, b_CS, b_BB, b_SO, b_IBB, b_HBP, b_SH, b_SF, b_GIDP)
(SELECT playerID, yearId, teamID, stint, b_G, b_AB, b_R, b_H, b_2B, b_3B, b_HR, b_RBI, b_SB, b_CS, b_BB, b_SO, b_IBB, b_HBP, b_SH, b_SF, b_GIDP FROM batting);

INSERT INTO fbatting (playerID, yearId, teamID, round, b_G, b_AB, b_R, b_H, b_2B, b_3B, b_HR, b_RBI, b_SB, b_CS, b_BB, b_SO, b_IBB, b_HBP, b_SH, b_SF, b_GIDP)
(SELECT playerID, yearId, teamID, round, b_G, b_AB, b_R, b_H, b_2B, b_3B, b_HR, b_RBI, b_SB, b_CS, b_BB, b_SO, b_IBB, b_HBP, b_SH, b_SF, b_GIDP FROM battingpost);

DROP TABLE batting;
DROP TABLE battingpost;
ALTER TABLE fbatting RENAME TO batting;

CREATE TABLE `ffielding` (
  `f_PK` int(12) NOT NULL AUTO_INCREMENT,
  `playerID` varchar(9) NOT NULL,
  `yearID` smallint(6) NOT NULL,
  `teamID` char(3) NOT NULL,
  `stint` smallint(4) DEFAULT NULL,
  `round` varchar(10) DEFAULT NULL,
  `position` varchar(2) DEFAULT NULL,
  `f_G` smallint(6) DEFAULT NULL,
  `f_GS` smallint(6) DEFAULT NULL,
  `f_InnOuts` smallint(6) DEFAULT NULL,
  `f_PO` smallint(6) DEFAULT NULL,
  `f_A` smallint(6) DEFAULT NULL,
  `f_E` smallint(6) DEFAULT NULL,
  `f_DP` smallint(6) DEFAULT NULL,
  `f_TP` smallint(6) DEFAULT NULL,
  `f_PB` smallint(6) DEFAULT NULL,
  `f_WP` smallint(6) DEFAULT NULL,
  `f_SB` smallint(6) DEFAULT NULL,
  `f_CS` smallint(6) DEFAULT NULL,
  `f_ZR` double DEFAULT NULL,
  PRIMARY KEY (`f_PK`),
  KEY `f_fie_team` (`teamID`),
  KEY `ffielding_playerID_yearID_teamID` (`playerID`,`yearID`,`teamID`),
  CONSTRAINT `ffielding_ibfk_1` FOREIGN KEY (`playerID`) REFERENCES `people` (`playerID`)
) ENGINE=InnoDB AUTO_INCREMENT=163216 DEFAULT CHARSET=utf8mb3;

INSERT INTO ffielding (playerID, yearID, teamID, stint, position, f_G, f_GS, f_InnOuts, f_PO, f_A, f_E, f_DP, f_PB, f_WP, f_SB, f_CS, f_ZR) 
(SELECT playerID, yearID, teamID, stint, position, f_G, f_GS, f_InnOuts, f_PO, f_A, f_E, f_DP, f_PB, f_WP, f_SB, f_CS, f_ZR 
FROM fielding);

INSERT INTO ffielding (playerID, yearID, teamID, round, position, f_G, f_GS, f_InnOuts, f_PO, f_A, f_E, f_DP, f_PB, f_TP, f_SB, f_CS) 
(SELECT playerID, yearID, teamID, round, position, f_G, f_GS, f_InnOuts, f_PO, f_A, f_E, f_DP, f_PB, f_TP, f_SB, f_CS
FROM fieldingpost);

DROP TABLE fielding;
DROP TABLE fieldingpost;
ALTER TABLE ffielding RENAME TO fielding;

CREATE TABLE `fpitching` (
  `p_PK` int(12) NOT NULL AUTO_INCREMENT,
  `playerID` varchar(9) NOT NULL,
  `yearID` smallint(6) NOT NULL,
  `teamID` char(3) NOT NULL,
  `stint` smallint(4) DEFAULT NULL,
  `round` varchar(10) DEFAULT NULL,
  `p_W` smallint(6) DEFAULT NULL,
  `p_L` smallint(6) DEFAULT NULL,
  `p_G` smallint(6) DEFAULT NULL,
  `p_GS` smallint(6) DEFAULT NULL,
  `p_CG` smallint(6) DEFAULT NULL,
  `p_SHO` smallint(6) DEFAULT NULL,
  `p_SV` smallint(6) DEFAULT NULL,
  `p_IPOuts` int(11) DEFAULT NULL,
  `p_H` smallint(6) DEFAULT NULL,
  `p_ER` smallint(6) DEFAULT NULL,
  `p_HR` smallint(6) DEFAULT NULL,
  `p_BB` smallint(6) DEFAULT NULL,
  `p_SO` smallint(6) DEFAULT NULL,
  `p_BAOpp` double DEFAULT NULL,
  `p_ERA` double DEFAULT NULL,
  `p_IBB` smallint(6) DEFAULT NULL,
  `p_WP` smallint(6) DEFAULT NULL,
  `p_HBP` smallint(6) DEFAULT NULL,
  `p_BK` smallint(6) DEFAULT NULL,
  `p_BFP` smallint(6) DEFAULT NULL,
  `p_GF` smallint(6) DEFAULT NULL,
  `p_R` smallint(6) DEFAULT NULL,
  `p_SH` smallint(6) DEFAULT NULL,
  `p_SF` smallint(6) DEFAULT NULL,
  `p_GIDP` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`p_PK`),
  KEY `f_pit_team` (`teamID`),
  KEY `fpitching_playerID_yearID_teamID` (`playerID`,`yearID`,`teamID`),
  CONSTRAINT `fpitching_ibfk_1` FOREIGN KEY (`playerID`) REFERENCES `people` (`playerID`)
) ENGINE=InnoDB AUTO_INCREMENT=49431 DEFAULT CHARSET=utf8mb3;

INSERT INTO fpitching (playerID, yearID, teamID, stint, p_W, p_L, p_G, p_GS, p_CG, p_SHO, p_SV, p_IPOuts, p_H, p_ER, p_HR, p_BB, p_SO, p_BAOpp, p_ERA, p_IBB, p_WP, p_HBP, p_BK, p_BFP, p_GF, p_R, p_SH, p_SF, p_GIDP)
(SELECT playerID, yearID, teamID, stint, p_W, p_L, p_G, p_GS, p_CG, p_SHO, p_SV, p_IPOuts, p_H, p_ER, p_HR, p_BB, p_SO, p_BAOpp, p_ERA, p_IBB, p_WP, p_HBP, p_BK, p_BFP, p_GF, p_R, p_SH, p_SF, p_GIDP FROM pitching);

INSERT INTO fpitching (playerID, yearID, teamID, round, p_W, p_L, p_G, p_GS, p_CG, p_SHO, p_SV, p_IPOuts, p_H, p_ER, p_HR, p_BB, p_SO, p_BAOpp, p_ERA, p_IBB, p_WP, p_HBP, p_BK, p_BFP, p_GF, p_R, p_SH, p_SF, p_GIDP)
(SELECT playerID, yearID, teamID, round, p_W, p_L, p_G, p_GS, p_CG, p_SHO, p_SV, p_IPOuts, p_H, p_ER, p_HR, p_BB, p_SO, p_BAOpp, p_ERA, p_IBB, p_WP, p_HBP, p_BK, p_BFP, p_GF, p_R, p_SH, p_SF, p_GIDP FROM pitchingpost);

DROP TABLE pitching;
DROP TABLE pitchingpost;
ALTER TABLE fpitching RENAME TO pitching;

/* Rename primary keys */
ALTER TABLE appearances RENAME COLUMN ID TO ap_PK;
ALTER TABLE awards RENAME COLUMN ID TO aw_PK;
ALTER TABLE awardsshare RENAME COLUMN ID TO as_PK;
ALTER TABLE allstarfull RENAME COLUMN ID TO al_PK;
ALTER TABLE collegeplaying RENAME COLUMN ID TO c_PK;
ALTER TABLE divisions RENAME COLUMN ID TO d_PK;
ALTER TABLE halloffame RENAME COLUMN ID TO hf_PK;
ALTER TABLE homegames RENAME COLUMN ID TO hg_PK;
ALTER TABLE managers RENAME COLUMN ID TO m_PK;
ALTER TABLE salaries RENAME COLUMN ID TO sa_PK;
ALTER TABLE seriespost RENAME COLUMN ID TO sp_PK;
ALTER TABLE teams RENAME COLUMN ID TO t_PK;