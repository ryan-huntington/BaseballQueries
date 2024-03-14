DROP TABLE IF EXISTS 2022batting;
CREATE TABLE 2022batting LIKE batting;
INSERT INTO 2022batting SELECT * FROM batting;

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

INSERT INTO 2022batting (playerID, yearId, teamID, b_G, b_AB, b_R, b_H, b_2B, b_3B, b_HR, b_RBI, b_SB, b_CS, b_BB, b_SO, b_IBB, b_HBP, b_SH, b_SF)
SELECT playerID, yearId, teamID, b_G, b_AB, b_R, b_H, b_2B, b_3B, b_HR, b_RBI, b_SB, b_CS, b_BB, b_SO, b_IBB, b_HBP, b_SH, b_SF FROM tmp; 


