SET SERVEROUTPUT ON;



/***************** Exercise 1 *********************/

PROMPT
PROMPT ******** Exercise 1 ******************************************
PROMPT * Définir une fonction qui convertit au format json les      *
PROMPT * informations d’une vidéo                                   *
PROMPT **************************************************************

CREATE OR REPLACE FUNCTION video2json(vid Video.VideoID%TYPE)
	RETURN VARCHAR2
IS 
	json_v VARCHAR2(4000);
BEGIN

	SELECT '{ "videoid": '         || VideoID        ||  ',' ||
	        ' "name": "'           || Name           || '",' ||
	        ' "description": "'    || Description    || '",' ||
	        ' "length": '          || Length         ||  ',' ||
	        ' "country": "'        || Country        || '",' ||
	        ' "firstdiffusion": "' || FirstDiffusion || '",' ||
	        ' "format": "'         || Format         || '",' ||
	        ' "multilang": '       || CASE WHEN Multilang = 'Y' 
                                          THEN 'true' ELSE 'false' 
                                          END            ||  ',' ||
	        ' "expiration": "'     || Expiration     || '",' ||
	        ' "programid": '       || ProgramID      ||
	       ' }' INTO json_v
	FROM Video
	WHERE VideoID = vid;

	RETURN json_v; 
END;
/



/* Execution */
SELECT video2json(3) "JSON" FROM DUAL;






/***************** Exercise 2 *********************/

PROMPT ******** Exercise 2 ******************************************
PROMPT * Définir une procédure qui générera un texte initial de la  *
PROMPT * newsletter en y ajoutant la liste de toutes les sorties de *
PROMPT * la semaine informations d’une vidéo                        *
PROMPT **************************************************************

-- Using a cursor to display the text of the email
-- direclty on the screen and considering the past 
-- (or current) Monday as the first day of the week
CREATE OR REPLACE PROCEDURE mk_newsletter_mail
IS
	CURSOR comingSoon_curs IS
		SELECT p.Name PName, v.Name VName, v.Description
		FROM Video v
		INNER JOIN (
			SELECT d.VideoID
			FROM Diffusion d
			GROUP BY d.VideoID 
			HAVING MIN(d.Time) >= TRUNC(NEXT_DAY(SYSDATE-7, 'Monday')) AND -- Last monday at midnight
			       MIN(d.Time) <  TRUNC(NEXT_DAY(SYSDATE, 'Monday')) -- Next Monday at midnight
		) next_vid
			ON next_vid.VideoID = v.VideoID
		INNER JOIN Program p
			ON p.ProgramID = v.ProgramID;
BEGIN
	dbms_output.put_line('Hello, have you seen the new videos of this week ?');
	dbms_output.put_line('Chek it out!');
	dbms_output.put(chr(10) || chr(13));

	FOR comingSoon_row IN comingSoon_curs
	LOOP
		dbms_output.put_line(comingSoon_row.PName || ' - ' ||
				     comingSoon_row.VName || ': '  ||
				     comingSoon_row.Description);
	END LOOP;

	dbms_output.put(chr(10) || chr(13));
	dbms_output.put_line('See you soon on www.fantasticvideos.com!');
END;
/



-- Without a cursor and using an OUT parameter to
-- return the text of the mail.
CREATE OR REPLACE PROCEDURE mk_newsletter_mail2 (email_v OUT VARCHAR2)
IS
BEGIN
	WITH next_vid AS (
		SELECT d.VideoID
		FROM Diffusion d
		GROUP BY d.VideoID 
		HAVING MIN(d.Time) >= SYSDATE AND 
		       MIN(d.Time) <  TRUNC(NEXT_DAY(SYSDATE, 'Monday')) -- Monday at midnight
	)
	SELECT LISTAGG( p.Name || ' - ' || v.Name || ': ' 
		  || v.Description , chr(10) )
	       WITHIN GROUP (ORDER BY p.ProgramID) INTO email_v
	FROM Video v
	INNER JOIN next_vid
	ON next_vid.VideoID = v.VideoID
	INNER JOIN Program p
	ON p.ProgramID = v.ProgramID;

	email_v := 'Hello, new fantastic videos are coming this week!' || chr(10) ||
		   'Chek it out! ' || chr(10) || chr(10) || 
		        email_v    || chr(10) || chr(10) ||
		   'See you soon on www.fantasticvideos.com!';
END;
/


/* Execution */
EXECUTE mk_newsletter_mail;
DECLARE
	email_v VARCHAR2(4000);
BEGIN
	mk_newsletter_mail2(email_v);
	dbms_output.put_line(email_v);
END;
/







/***************** Exercise 3 *********************/

PROMPT ******** Exercise 3 ******************************************
PROMPT * Définir une procédure qui génère N épisodes, un par semaine*
PROMPT * , entre une date de début et une date de fin indiquées en  *
PROMPT * paramètre de la procédure. L’incrémentation du numéro      *
PROMPT * d’épisode partira du dernier épisode dans la base. Le      *
PROMPT * descriptif de l’épisode sera « à venir ».                  *
PROMPT **************************************************************

-- Just adding one video for each week
CREATE OR REPLACE PROCEDURE mk_new_episodes
	(start_a DATE, end_a DATE, prog_a Program.ProgramID%TYPE)
IS 
	nbweeks_v    INTEGER := (end_a-start_a)/7;
	count_v	     INTEGER := 0;
	lastep_v     Video.VideoID%TYPE;
BEGIN
	LOCK TABLE Video IN SHARE MODE;

	SELECT COALESCE(MAX(VideoID),0) INTO lastep_v
	FROM Video; 

	WHILE count_v < nbweeks_v
	LOOP
		count_v := count_v + 1;

		INSERT INTO Video (VideoID, Name, Description, ProgramID)
		VALUES (lastep_v+count_v, 'Episode ' || count_v , 'a venir', prog_a);
	END LOOP;
	
END;
/


-- Add a video and a diffusion for each week
/*
CREATE OR REPLACE PROCEDURE mk_new_episodes2
	(start_a DATE, end_a DATE, prog_a Program.ProgramID%TYPE)
IS 
	datediff_v 	DATE := start_a;
	epid_v     Video.VideoID%TYPE;
BEGIN
	LOCK TABLE Video IN SHARE MODE;

	SELECT COALESCE(MAX(VideoID)+1,0) INTO epid_v
	FROM Video; 

	WHILE datediff_v <= end_a
	LOOP
		INSERT INTO Video (VideoID, Name, Description, ProgramID)
		VALUES (epid_v, 'New episode' , 'a venir', prog_a);

		INSERT INTO Diffusion (VideoID, Time)
		VALUES (epid_v, datediff_v);

		datediff_v := datediff_v + 7;
		epid_v := epid_v + 1;
	END LOOP;
	
END;
/
*/

/* Execution */
EXECUTE mk_new_episodes(TO_DATE('10-DEC-2016', 'DD-MM-YY'),TO_DATE('31-DEC-2016', 'DD-MM-YY'),2);
--EXECUTE mk_new_episodes2(TO_DATE('10-DEC-2016', 'DD-MM-YY'),TO_DATE('31-DEC-2016', 'DD-MM-YY'),2);









/***************** Exercise 4 *********************/

PROMPT ******** Exercise 4 ******************************************
PROMPT * Générer la liste des vidéos populaires, conseillées pour   *
PROMPT * un utilisateur, c’est à dire fonction des catégories de    *
PROMPT * vidéos qu’il suit.                                         *
PROMPT **************************************************************


-- Using a cursor and displayung the retult on the screen
CREATE OR REPLACE PROCEDURE suggestion_list
	(user_a WebUser.UserID%TYPE)
IS 
	CURSOR trendVideos_curs IS 
		SELECT po.Name PName, v.Name VName, v.Description
		FROM UserView uv
		INNER JOIN Video v
			ON v.VideoID = uv.VideoID
		INNER JOIN Program po
			ON po.ProgramID = v.ProgramID
		INNER JOIN Preference pe
			ON pe.UserID = 2 AND 
			   pe.CategoryID = po.CategoryID
		WHERE uv.Time > SYSDATE - 14
		GROUP BY v.VideoID, po.Name, v.Name, v.Description
		ORDER BY COUNT(DISTINCT uv.UserID) DESC;
BEGIN
	FOR trendVideos_row IN trendVideos_curs
	LOOP
		dbms_output.put_line(trendVideos_row.PName || ' - ' ||
				     trendVideos_row.VName || ': '  ||
				     trendVideos_row.Description);
	END LOOP;
END;
/


-- Without a cursor, returning the result
/*
CREATE OR REPLACE FUNCTION suggestion_list2
	(user_a WebUser.UserID%TYPE) RETURN VARCHAR2
IS 
	list_v VARCHAR2(4000);
BEGIN
	SELECT LISTAGG( v.Name || ' - ' || 
		       po.Name || ': '  || 
		       v.Description, chr(10) || chr(13)) 
	       WITHIN GROUP (ORDER BY COUNT(DISTINCT uv.UserID) DESC)
	       INTO list_v
        FROM UserView uv
	INNER JOIN Video v
		ON v.VideoID = uv.VideoID
        INNER JOIN Program po
                ON po.ProgramID = v.ProgramID
        INNER JOIN Preference pe
                ON pe.UserID = user_a AND 
                   pe.CategoryID = po.CategoryID
	WHERE uv.Time > SYSDATE - 14
	GROUP BY v.VideoID, po.Name, v.Name, v.Description;

	RETURN list_v;
END;
/
*/

-- Using a cursor, returning the result
/*
CREATE OR REPLACE FUNCTION suggestion_list3
	(user_a WebUser.UserID%TYPE) RETURN VARCHAR2
IS 
	CURSOR trendVideos_curs IS 
		SELECT po.Name PName, v.Name VName, v.Description
		FROM UserView uv
		INNER JOIN Video v
			ON v.VideoID = uv.VideoID
		INNER JOIN Program po
			ON po.ProgramID = v.ProgramID
		INNER JOIN Preference pe
			ON pe.UserID = 2 AND 
			   pe.CategoryID = po.CategoryID
		WHERE uv.Time > SYSDATE - 14
		GROUP BY v.VideoID, po.Name, v.Name, v.Description
		ORDER BY COUNT(DISTINCT uv.UserID) DESC;
	list_v VARCHAR2(4000);
BEGIN
	FOR trendVideos_row IN trendVideos_curs
	LOOP
		list_v := list_v ||
			  trendVideos_row.PName || ' - ' ||
			  trendVideos_row.VName || ': '  ||
			  trendVideos_row.Description ||
 			  chr(10) || chr(13);
	END LOOP;

	RETURN list_v;
END;
/
*/


/* Execution */
EXECUTE suggestion_list(2);
--SELECT suggestion_list2(2) FROM DUAL;
--SELECT suggestion_list3(2) FROM DUAL;
