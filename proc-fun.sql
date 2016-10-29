SET SERVEROUTPUT ON;


-- dbms_output.put_line('Hello');

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

	RETURN json_v;
END;
/


--TODO REMOVE
show errors;


SELECT video2json(VideoID) "JSON" FROM Video;










