DROP TABLE IF EXISTS 2022pitching;
CREATE TABLE 2022pitching LIKE pitching;
INSERT INTO 2022pitching SELECT * FROM pitching;

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

INSERT INTO 2022pitching(playerID, yearID, teamID, p_W, p_L, p_G, p_GS, p_CG, p_SHO, p_SV, p_H, p_ER, p_HR, p_BB, p_SO, p_ERA, p_IBB, p_WP, p_HBP, p_BK, p_GF, p_R, p_SH, p_SF)
SELECT playerID, yearID, teamID, p_W, p_L, p_G, p_GS, p_CG, p_SHO, p_SV, p_H, p_ER, p_HR, p_BB, p_SO, p_ERA, p_IBB, p_WP, p_HBP, p_BK, p_GF, p_R, p_SH, p_SF FROM tmp;

