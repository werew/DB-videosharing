
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
