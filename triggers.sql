SET SERVEROUTPUT ON;

/**************** Exercise 1 ***************/

CREATE OR REPLACE TRIGGER MaxUserSelections
AFTER INSERT OR UPDATE ON UserSelection
DECLARE
	nbselections_v 	INTEGER;
BEGIN
	SELECT MAX(COUNT(*)) INTO nbselections_v
		FROM UserSelection
		GROUP BY UserID;
	IF nbselections_v > 300 THEN
		RAISE_APPLICATION_ERROR(-20200, 'Too many selections');	
	END IF;
END;
/



/**************** Exercise 2 ***************/
-- Update all videos
CREATE OR REPLACE TRIGGER UpdateExpiration
AFTER INSERT OR UPDATE ON Diffusion
DECLARE
	lastdiff_v 	Diffusion.Time%TYPE;
BEGIN
	FOR my_row IN (SELECT VideoID, MAX(Time) LastDiff
		       FROM Diffusion GROUP BY VideoID)
	LOOP
		UPDATE Video v SET v.Expiration = my_row.LastDiff + 14
		WHERE v.VideoID = my_row.VideoID;
	END LOOP;
END;
/


-- Update only related videos
/*
CREATE OR REPLACE TRIGGER UpdateExpiration
AFTER INSERT OR UPDATE ON Diffusion
FOR EACH ROW
DECLARE
	expiration_v    Video.Expiration%TYPE;
BEGIN
	SELECT Expiration INTO expiration_v 
	FROM Video WHERE VideoID = :new.VideoID;

	IF expiration_v < :new.Time + 14 OR expiration_v IS NULL THEN
		UPDATE Video SET Video.Expiration = :new.Time + 14
		WHERE  VideoID = :new.VideoID;
	END IF;
END;
/

*/




/**************** Exercise 3 ***************/

CREATE OR REPLACE TRIGGER ArchiveVideo
AFTER DELETE ON Video
FOR EACH ROW
DECLARE
	archID_v 	INTEGER;
BEGIN
	LOCK TABLE ArchivedVideo IN SHARE MODE;

	SELECT COALESCE(MAX(ArchivedVideoID)+1,0) INTO archID_v
	FROM ArchivedVideo;

	INSERT INTO ArchivedVideo
		(ArchivedVideoID, Name, Description, Length,
		 Country, FirstDiffusion, Format, MultiLang)
	VALUES  (archID_v, :old.Name, :old.Description, :old.Length, 
		:old.Country,:old.FirstDiffusion, :old.Format, :old.MultiLang );
END;
/


CREATE OR REPLACE TRIGGER ErasePrograms
AFTER DELETE ON Video
BEGIN
	DELETE FROM PROGRAM 
	WHERE ProgramID IN  (
	        SELECT p.ProgramID
		FROM Program p
		LEFT OUTER JOIN Video v
		    ON v.ProgramID = p.ProgramID
		GROUP BY p.ProgramID HAVING COUNT(v.VideoID) = 0
	);
END;
/



/**************** Exercise 4 ***************/
CREATE OR REPLACE TRIGGER CountViews
AFTER INSERT OR UPDATE ON UserView
DECLARE
	maxViewsMin_v	INTEGER;
BEGIN
	SELECT MAX(COUNT(*)) INTO maxViewsMin_v
	FROM UserView
	GROUP BY UserID, to_char(Time, 'YYYY-MM-DD HH24:MI');

	IF maxViewsMin_v > 3 THEN
		RAISE_APPLICATION_ERROR(-20200, 'Too many views for minute');	
	END IF;
END;
/



/************** MY TRIGGERS *******************/

CREATE OR REPLACE TRIGGER ValidView
BEFORE INSERT OR UPDATE ON UserView
FOR EACH ROW
DECLARE
	first_diff_v	Diffusion.Time%TYPE;
	expiration_v	Video.Expiration%TYPE;
BEGIN
	IF :new.Time > SYSDATE THEN
		RAISE_APPLICATION_ERROR(-20200, 'Cannot watch a video in the future');
	END IF;

	SELECT Expiration INTO expiration_v
	FROM Video WHERE VideoID = :new.VideoID;

	IF :new.Time >= expiration_v THEN
		RAISE_APPLICATION_ERROR(-20200, 'The video has already expired');
	END IF;

	SELECT MIN(Time) INTO first_diff_v
	FROM Diffusion WHERE VideoID = :new.VideoID;

	IF :new.Time < first_diff_v OR first_diff_v IS NULL THEN
		RAISE_APPLICATION_ERROR(-20200, 'Video not yet available');
	END IF;
END;
/


CREATE OR REPLACE TRIGGER WaitExpiration
BEFORE DELETE ON Video
FOR EACH ROW
BEGIN
	IF SYSDATE < :old.Expiration THEN
		RAISE_APPLICATION_ERROR(-20200, 'Video not yet expired');
	END IF;
END;
/


CREATE OR REPLACE TRIGGER BadExpiration
BEFORE UPDATE ON Video
FOR EACH ROW
DECLARE
	lastdiff_v 	Diffusion.Time%TYPE;	
BEGIN
	IF :new.Expiration < :old.Expiration 
	   OR :old.Expiration IS NULL  THEN
		SELECT MAX(Time) INTO lastdiff_v
		FROM Diffusion WHERE VideoID = :new.VideoID;
		
		IF :new.Expiration < lastdiff_v + 7 THEN
			RAISE_APPLICATION_ERROR(-20200, 'New expiration is too early');
		END IF;
	END IF;
END;
/


CREATE OR REPLACE TRIGGER FirstDiffusionCheck
BEFORE INSERT OR UPDATE ON Diffusion
FOR EACH ROW
DECLARE
	firstdiffusion_v	Video.FirstDiffusion%TYPE;
BEGIN
	SELECT FirstDiffusion INTO firstdiffusion_v
	FROM Video WHERE VideoID = :new.VideoID;

	IF :new.Time < firstdiffusion_v THEN
		RAISE_APPLICATION_ERROR(-20200, 'Time is previous to first diffusion');
	END IF;
END;
/


CREATE OR REPLACE TRIGGER VideoWasDiffused
BEFORE INSERT OR UPDATE ON Video
FOR EACH ROW
DECLARE
	first_diff_v	 Diffusion.Time%TYPE;
BEGIN
	IF :new.FirstDiffusion IS NOT NULL THEN
		SELECT MIN(Time) INTO first_diff_v
		FROM Diffusion WHERE VideoID = :new.VideoID;

		IF :new.FirstDiffusion > first_diff_v THEN
			RAISE_APPLICATION_ERROR(-20200, 'Video was already diffused');
		END IF;
	END IF;
END;
/

