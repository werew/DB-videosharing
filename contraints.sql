SET SERVEROUTPUT ON;

/* Exercice 1 */

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

show errors;


/**
 * Version naive: pose des problemes si la table est en train
 *                de muter (p.ex. dans les cas d'un update
 *		  sur plusieurs lignes )
 */
/*
CREATE OR REPLACE TRIGGER MaxUserSelectionsNaive
BEFORE INSERT OR UPDATE ON UserSelection
FOR EACH ROW
DECLARE
	nbselections_v 	INTEGER;
BEGIN
	SELECT COUNT(*) INTO nbselections_v
		FROM UserSelection
		WHERE UserID = :new.UserID;
	IF nbselections_v >= 300 THEN
		RAISE_APPLICATION_ERROR(-20200, 'Too many selections');	
	END IF;
END;
/

show errors;

*/



/* Exercice 2 */

/* Met a jour toutes les dates de disponibilite a chaque UPDATE/INSERT */
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


show errors;


/* Met a jour chaque les dates de disponibilite par rapport
   a les diffusions ajoute/mises jour. 
 */

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

show errors; 


*/



/* Exercice 3 */
CREATE OR REPLACE TRIGGER ArchiveVideo
AFTER DELETE ON Video
FOR EACH ROW
BEGIN
	INSERT INTO ArchivedVideo
		(ArchivedVideoID, Name, Description, Length, Country, FirstDiffusion, Format, MultiLang)
	VALUES  (:old.VideoID, :old.Name, :old.Description, :old.Length, :old.Country, 
		 :old.FirstDiffusion, :old.Format, :old.MultiLang );
END;
/

show errors;

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


show errors;



/* Exercice 4 */
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

show errors;
