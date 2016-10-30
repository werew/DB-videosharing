
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



