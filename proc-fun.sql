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





