SET SERVEROUTPUT ON;



/* Exercice 1 */

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


--TODO REMOVE
show errors;

--TODO UNCOMMENT
--SELECT video2json(VideoID) "JSON" FROM Video;







/* Exercice 2 */


-- Premiere option
-- Avec un curseur en affichant le texte de l'email directement a l'ecran
CREATE OR REPLACE PROCEDURE mk_newsletter_mail
IS
	CURSOR comingSoon_curs IS
		SELECT p.Name PName, v.Name VName, v.Description
		FROM Video v
		INNER JOIN (
			SELECT d.VideoID
			FROM Diffusion d
			GROUP BY d.VideoID 
			HAVING MIN(d.Time) >= SYSDATE AND 
			       MIN(d.Time) <  TRUNC(NEXT_DAY(SYSDATE, 'Monday')) -- Monday at midnight
		) next_vid
			ON next_vid.VideoID = v.VideoID
		INNER JOIN Program p
			ON p.ProgramID = v.ProgramID;
BEGIN
	dbms_output.put_line('Hello, new fantastic videos are coming this week!');
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

--TODO REMOVE
show errors;

--TODO UNCOMMENT
--EXECUTE mk_newsletter_mail;

-- Deuxieme optione
-- Sans courseur et en utilisant un parametre de type OUT pour passer le texte de l'email
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

--TODO REMOVE
show errors;

--TODO UNCOMMENT
/*
DECLARE
	email_v VARCHAR2(4000);
BEGIN
	mk_newsletter_mail2(email_v);
	dbms_output.put_line(email_v);
END;
/
*/














/* Exercice 3 */


CREATE OR REPLACE PROCEDURE mk_new_episodes
	(start_a DATE, end_a DATE, prog_a Program.ProgramID%TYPE)
IS 
	nbweeks_v    INTEGER := (end_a-start_a)/7;
	count_v	     INTEGER := 0;
	lastep_v     Video.VideoID%TYPE;
BEGIN
	SELECT MAX(VideoID) INTO lastep_v
	FROM Video; 

	WHILE count_v < nbweeks_v
	LOOP
		count_v := count_v + 1;

--TODO which number has to be incremented ? 
--TODO problems if somebody is inserting videos at the same time

		INSERT INTO Video (VideoID, Name, Description, ProgramID)
		VALUES (lastep_v+count_v, 'Episode ' || count_v , 'a venir', prog_a);
	END LOOP;
	
END;
/


--TODO REMOVE
show errors;

--TODO UNCOMMENT
--EXECUTE mk_new_episodes(TO_DATE('10-DEC-2016', 'DD-MM-YY'),TO_DATE('31-DEC-2016', 'DD-MM-YY'),2);













/* Exercice 4 */

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

--TODO REMOVE
show errors;


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


--TODO REMOVE
show errors;


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

--TODO REMOVE
show errors;

PROMPT ##########1##########
EXECUTE suggestion_list(2);
PROMPT ##########2##########
SELECT suggestion_list2(2) "JSON" FROM dual;
SELECT suggestion_list3(2) "JSON" FROM dual;

/*
SELECT uv.VideoID, COUNT(DISTINCT uv.UserID)
FROM UserView uv
INNER JOIN Video v
	ON v.VideoID = uv.VideoID
INNER JOIN Program po
	ON po.ProgramID = v.ProgramID
INNER JOIN Preference pe
	ON pe.UserID = 2 AND 
	   pe.CategoryID = po.CategoryID
GROUP BY uv.VideoID
ORDER BY COUNT(DISTINCT uv.UserID) DESC;
*/



