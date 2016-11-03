SET SERVEROUTPUT ON;

PROMPT ***********************************************
PROMPT *      TRIGGER: MaxUserSelections             *
PROMPT ***********************************************

CREATE OR REPLACE PROCEDURE Test_MaxUserSelections
IS
    videoid_v 	Video.VideoID%TYPE;
    count_v 	INTEGER := 0;
BEGIN
	
	SELECT MAX(VideoID) INTO videoid_v
	FROM Video;
	dbms_output.put_line('--------> Generating 300 user selections...');
	WHILE count_v < 300
	LOOP
		videoid_v := videoid_v+1;
		count_v := count_v+1;

		INSERT INTO Video (VideoID, Name, ProgramID)
		VALUES (videoid_v, 'TEST', 0);

		INSERT INTO UserSelection (VideoID, UserID)
		VALUES (videoid_v, 0);

	END LOOP;
END;
/

EXECUTE Test_MaxUserSelections;


PROMPT ***********************************************
PROMPT *      TRIGGER: UpdateExpiration              *
PROMPT ***********************************************

CREATE OR REPLACE PROCEDURE Test_UpdateExpiration
IS
	exp_v		Video.Expiration%TYPE;
BEGIN
	SELECT Expiration INTO exp_v FROM Video WHERE VideoID = 0;	
	IF exp_v IS NULL THEN 
		dbms_output.put_line('--------> VideoID: 0 Expiration: NULL');
		exp_v := SYSDATE;
	ELSE
		dbms_output.put_line('--------> VideoID: 0 Expiration: ' || exp_v);
		exp_v := exp_v + 9999;
	END IF;

	dbms_output.put_line('--------> Adding diffusion the: ' || exp_v);
	INSERT INTO Diffusion (VideoID, Time) VALUES (0, exp_v);
	SELECT Expiration INTO exp_v FROM Video WHERE VideoID = 0;	
	dbms_output.put_line('--------> VideoID: 0 Expiration: ' || exp_v);
END;
/


EXECUTE Test_UpdateExpiration;


PROMPT ***********************************************
PROMPT *      TRIGGER: ArchiveVideo                  *
PROMPT ***********************************************

CREATE OR REPLACE PROCEDURE Test_ArchiveVideo
IS
	count_v		INTEGER;
	videoid_v 	Video.VideoID%TYPE;
BEGIN

	SELECT COALESCE(MAX(VideoID)+1,0) INTO videoid_v FROM Video;
	INSERT INTO Video (VideoID, Name, ProgramID)
	VALUES (videoid_v, 'TEST', 0);
	dbms_output.put_line('--------> CREATING VIDEO N.' || videoid_v);

	SELECT COUNT(*) INTO count_v FROM ArchivedVideo;
	dbms_output.put_line('--------> Nb of archived videos: ' || count_v);


	dbms_output.put_line('--------> DELETING VIDEO N.' || videoid_v);
	DELETE FROM Video WHERE VideoID = videoid_v;

	SELECT COUNT(*) INTO count_v FROM ArchivedVideo;
	dbms_output.put_line('--------> Nb of archived videos: ' || count_v);
END;
/


EXECUTE Test_ArchiveVideo;


PROMPT ***********************************************
PROMPT *      TRIGGER: CountViews                    *
PROMPT ***********************************************

INSERT INTO UserView (UserID, VideoID, Time) 
       VALUES (0,0,SYSDATE);
INSERT INTO UserView (UserID, VideoID, Time) 
       VALUES (0,1,SYSDATE);
INSERT INTO UserView (UserID, VideoID, Time) 
       VALUES (0,2,SYSDATE);
INSERT INTO UserView (UserID, VideoID, Time) 
       VALUES (0,3,SYSDATE);


PROMPT ***********************************************
PROMPT *      TRIGGER: ValidView                     *
PROMPT ***********************************************


CREATE OR REPLACE PROCEDURE Test_ValidView_Future
IS
	videoid_v 	Video.VideoID%TYPE;
BEGIN
	SELECT COALESCE(MAX(VideoID)+1,0) INTO videoid_v FROM Video;

	dbms_output.put_line('----------> Whatch a video into the future');
	INSERT INTO UserView (UserID, VideoID, Time) VALUES (0,0,SYSDATE+1);
END;
/


EXECUTE Test_ValidView_Future;

CREATE OR REPLACE PROCEDURE Test_ValidView_Expired
IS
	videoid_v 	Video.VideoID%TYPE;
BEGIN

	SELECT COALESCE(MAX(VideoID)+1,0) INTO videoid_v FROM Video;

	dbms_output.put_line('----------> Whatch an expired video');
	INSERT INTO Video (VideoID, Name, ProgramID, Expiration)
	       VALUES (videoid_v, 'TEST', 0, SYSDATE-10);
	INSERT INTO UserView (UserID, VideoID, Time) VALUES (0,videoid_v,SYSDATE);
END;
/

EXECUTE Test_ValidView_Expired;

CREATE OR REPLACE PROCEDURE Test_ValidView_NotAv
IS
	videoid_v 	Video.VideoID%TYPE;
BEGIN
	SELECT COALESCE(MAX(VideoID)+1,0) INTO videoid_v FROM Video;

	dbms_output.put_line('----------> Whatch a not available video');
	INSERT INTO Video (VideoID, Name, ProgramID, Expiration)
	       VALUES (videoid_v, 'TEST', 0, SYSDATE+10);
	INSERT INTO UserView (UserID, VideoID, Time) VALUES (0,videoid_v,SYSDATE);
END;
/


EXECUTE Test_ValidView_NotAv;



PROMPT ***********************************************
PROMPT *      TRIGGER: WaitExpiration                *
PROMPT ***********************************************


CREATE OR REPLACE PROCEDURE Test_WaitExpiration
IS
	videoid_v 	Video.VideoID%TYPE;
BEGIN
	SELECT COALESCE(MAX(VideoID)+1,0) INTO videoid_v FROM Video;

	dbms_output.put_line('----------> Delete a video not yet expired');
	INSERT INTO Video (VideoID, Name, ProgramID, Expiration)
	       VALUES (videoid_v, 'TEST', 0, SYSDATE+10);
	DELETE FROM Video WHERE VideoID = videoid_v;
END;
/


EXECUTE Test_WaitExpiration;


PROMPT ***********************************************
PROMPT *      TRIGGER: BadExpiration                 *
PROMPT ***********************************************

CREATE OR REPLACE PROCEDURE Test_BadExpiration
IS
	videoid_v 	Video.VideoID%TYPE;
BEGIN
	SELECT COALESCE(MAX(VideoID)+1,0) INTO videoid_v FROM Video;

	dbms_output.put_line('----------> Video which expires before 7 days after the last diffusion');
	INSERT INTO Video (VideoID, Name, ProgramID)
	       VALUES (videoid_v, 'TEST', 0);
	INSERT INTO Diffusion (VideoID, Time) VALUES (videoid_v,SYSDATE+10);
	UPDATE Video SET Expiration = SYSDATE WHERE VideoID = videoid_v;
END;
/

EXECUTE Test_BadExpiration;


PROMPT ***********************************************
PROMPT *      TRIGGER: FirstDiffusionCheck           *
PROMPT ***********************************************

CREATE OR REPLACE PROCEDURE Test_FirstDiffusionCheck
IS
	videoid_v 	Video.VideoID%TYPE;
BEGIN
	SELECT COALESCE(MAX(VideoID)+1,0) INTO videoid_v FROM Video;

	dbms_output.put_line('----------> Adding diffusion previous to FirstDiffusion');
	INSERT INTO Video (VideoID, Name, ProgramID, FirstDiffusion)
	       VALUES (videoid_v, 'TEST', 0, SYSDATE);
	INSERT INTO Diffusion (VideoID, Time) VALUES (videoid_v,SYSDATE-1);
	UPDATE Video SET Expiration = SYSDATE WHERE VideoID = videoid_v;
END;
/

EXECUTE Test_FirstDiffusionCheck;

PROMPT ***********************************************
PROMPT *      TRIGGER: VideoWasDiffused              *
PROMPT ***********************************************

CREATE OR REPLACE PROCEDURE Test_VideoWasDiffused
IS
	videoid_v 	Video.VideoID%TYPE;
BEGIN
	SELECT COALESCE(MAX(VideoID)+1,0) INTO videoid_v FROM Video;

	dbms_output.put_line('----------> FirstDiffusion previous to the first entry in the table diffusion');
	INSERT INTO Video (VideoID, Name, ProgramID, FirstDiffusion)
	       VALUES (videoid_v, 'TEST', 0, SYSDATE-10);
	INSERT INTO Diffusion (VideoID, Time) VALUES (videoid_v,SYSDATE);
	UPDATE Video SET FirstDiffusion = SYSDATE+10 WHERE VideoID = videoid_v;
END;
/

EXECUTE Test_VideoWasDiffused;
