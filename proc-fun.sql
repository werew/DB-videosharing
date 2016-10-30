SET SERVEROUTPUT ON;


-- dbms_output.put_line('Hello');



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
	        ' "programid": '       || ProgramID      ||
	       ' }' INTO json_v
	FROM Video
	WHERE VideoID = vid;

	RETURN json_v; /*TODO to lower ?? in order to take care of the nulls */
END;
/


--TODO REMOVE
show errors;

--TODO UNCOMMENT
--SELECT video2json(VideoID) "JSON" FROM Video;



/* Exercice 2 */

CREATE OR REPLACE PROCEDURE mk_newsletter_mail
IS 
	email_v VARCHAR2(4000);
BEGIN
	WITH next_vid AS (
		SELECT d.VideoID
		FROM Diffusion d
		GROUP BY d.VideoID 
		HAVING MIN(d.Time) BETWEEN SYSDATE AND SYSDATE + 7
	)
	SELECT LISTAGG( p.Name || ' - ' || v.Name || ': ' 
		  || v.Description , CHR(10) )
	       WITHIN GROUP (ORDER BY p.ProgramID) INTO email_v
	FROM Video v
	INNER JOIN next_vid
	ON next_vid.VideoID = v.VideoID
	INNER JOIN Program p
	ON p.ProgramID = v.ProgramID;

	email_v := 'Hello, new fantastic videos are coming this week!' || chr(10) ||
		   'Chek it out! ' || chr(10) || chr(10) || email_v 
			|| chr(10) || chr(10) ||
		   'See you soon on www.fantasticvideos.com!';

	dbms_output.put(email_v);

	dbms_output.new_line;
	
END;
/

--TODO REMOVE
show errors;

--TODO UNCOMMENT
--EXECUTE mk_newsletter_mail;





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

		INSERT INTO Video (VideoID, Name, Description, ProgramID)
		VALUES (lastep_v+count_v, 'Episode ' || count_v , 'a venir', prog_a);
	END LOOP;
	
END;
/


--TODO REMOVE
show errors;

--TODO UNCOMMENT
--EXECUTE mk_new_episodes(TO_DATE('10-DEC-2016', 'DD-MM-YY'),TO_DATE('31-DEC-2016', 'DD-MM-YY'),2);


