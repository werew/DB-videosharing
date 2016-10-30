
-- Users
INSERT INTO WebUser (UserID, Login, FirstName, LastName, Birth, Country, Email, NewsLetter, Admin)
            VALUES  (0, 'jojo', 'Mark', 'Lenas', '01-MAR-1992', 'FR', 'jojo@gmail.com', 'N', 'N');
INSERT INTO WebUser (UserID, Login, FirstName, LastName, Birth, Country, Email, NewsLetter, Admin)
            VALUES  (1, 'werew', 'Luigi','Coniglio', '07-MAR-1992','IT', 'luigi.coniglio@etu.unistra.fr', 'N', 'Y');
INSERT INTO WebUser (UserID, Login, FirstName, LastName, Birth, Country, Email, NewsLetter, Admin)
            VALUES  (2, 'ttk86', 'John', 'Smith', '19-FEB-1986','DE', 'johnsm@gmail.com', 'Y', 'N');
INSERT INTO WebUser (UserID, Login, FirstName, LastName, Birth, Country, Email, NewsLetter, Admin)
            VALUES  (3, 'awe', 'Lukas', 'Eihgvan', '03-DEC-1994','DE', 'awe@yahoo.com', 'Y', 'Y');
INSERT INTO WebUser (UserID, Login, FirstName, LastName, Birth, Country, Email, NewsLetter, Admin)
            VALUES  (4, 'jt', 'John', 'Titor', '13-APR-2036', 'FR', 'jtitor@ibm.com', 'N', 'N');

-- Passwords
INSERT INTO UserPass (UserID, PassHash, Salt)
            VALUES  (0, '40d3184bfb369d57d2d1eafeae7072d49ed79632', 84 );
INSERT INTO UserPass (UserID, PassHash, Salt)
            VALUES  (1, '5984be3439f1b4629e4b7a9ebc5324c58a57ce09', 328);
INSERT INTO UserPass (UserID, PassHash, Salt)
            VALUES  (2, '5082e3d05737504540e660c6886344c0ba9095d9', 921);
INSERT INTO UserPass (UserID, PassHash, Salt)
            VALUES  (3, 'dca41bafe48c57bf2c9309c485da267d23de04f9', 93 );
INSERT INTO UserPass (UserID, PassHash, Salt)
            VALUES  (4, '59fdb7b963ee0dad67abb39b66f1a5d9b27a4008', 262);

-- Categories
INSERT INTO Category (CategoryID, Name)
            VALUES   (0, 'News');
INSERT INTO Category (CategoryID, Name)
            VALUES   (1, 'Cinema');
INSERT INTO Category (CategoryID, Name)
            VALUES   (2, 'Intertainement');
INSERT INTO Category (CategoryID, Name)
            VALUES   (3, 'Science');

-- Programs
INSERT INTO Program (ProgramID, Name, CategoryID)
            VALUES  (0, 'The late show', 2);
INSERT INTO Program (ProgramID, Name, CategoryID)
            VALUES  (1, 'Great movies', 1);
INSERT INTO Program (ProgramID, Name, CategoryID)
            VALUES  (2, 'Turing''s life', 3);
INSERT INTO Program (ProgramID, Name, CategoryID)
            VALUES  (3, 'Futurama', 2);

-- Videos
INSERT INTO Video (VideoID, Name, Description, Length, Country, FirstDiffusion, Format, MultiLang, ProgramID)
            VALUES (0, 'The story of J.K. Scruber', 'All you need to know about J.K. Scruber', 
                    60, 'US', NULL, 'ogg', 'Y', 0);
INSERT INTO Video (VideoID, Name, Description, Length, Country, FirstDiffusion, Format, MultiLang, ProgramID)
            VALUES (1, 'The Shawshank Redemption', 'When does a prisoner lose his soul?', 
                    120, 'US',NULL, 'avi', 'Y', 1);
INSERT INTO Video (VideoID, Name, Description, Length, Country, FirstDiffusion, Format, MultiLang, ProgramID)
            VALUES (2, '12 Angry Men', 'One can make the difference', 
                    120, 'US',NULL, 'ogg', 'N', 1);
INSERT INTO Video (VideoID, Name, Description, Length, Country, FirstDiffusion, Format, MultiLang, ProgramID)
            VALUES (3, 'Life is Beautiful', 'A Jewish librarian protecting his son during Holocaust',
                    90, 'IT', NULL, 'mp4', 'Y', 1);
INSERT INTO Video (VideoID, Name, Description, Length, Country, FirstDiffusion, Format, MultiLang, ProgramID)
            VALUES (4, 'Turingi''s life', 'A tour inside the life of the father of the modern computer',
                    200, 'UK', NULL, 'avi', 'Y', 2);
INSERT INTO Video (VideoID, Name, Description, Length, Country, FirstDiffusion, Format, MultiLang, ProgramID)
            VALUES (5, 'Episode - 1', 'Space Pilot 3000',
                    25, 'US', NULL, 'ogg', 'Y', 3);
INSERT INTO Video (VideoID, Name, Description, Length, Country, FirstDiffusion, 
	           Format, MultiLang, Expiration, ProgramID)
            VALUES (6, 'Episode - 2', 'Fry meets his new roommate',
                    25, 'US', NULL, 'ogg', 'Y', TO_DATE('10-JAN-2017', 'DD-MM-YY'), 3);
INSERT INTO Video (VideoID, Name, Description, Length, Country, FirstDiffusion, 
	           Format, MultiLang, Expiration, ProgramID)
            VALUES (7, 'Episode - 3', 'Fry visits the moon',
                    25, 'US', NULL, 'ogg', 'Y', TO_DATE('15-JAN-2017', 'DD-MM-YY'), 3);

-- Diffusions
INSERT INTO Diffusion (VideoID, Time)
            VALUES    (0, TO_DATE('12-JAN-2017 15:30', 'DD-MM-YY HH24:MI'));
INSERT INTO Diffusion (VideoID, Time)
            VALUES    (0, TO_DATE('13-JAN-2017 15:30', 'DD-MM-YY HH24:MI'));
INSERT INTO Diffusion (VideoID, Time)
            VALUES    (1, TO_DATE('19-FEB-2017 20:00', 'DD-MM-YY HH24:MI'));
INSERT INTO Diffusion (VideoID, Time)
            VALUES    (2, TO_DATE('15-JAN-2017 8:20', 'DD-MM-YY HH24:MI'));
INSERT INTO Diffusion (VideoID, Time)
            VALUES    (2, TO_DATE('15-JAN-2017 20:00', 'DD-MM-YY HH24:MI'));
INSERT INTO Diffusion (VideoID, Time)
            VALUES    (5, TO_DATE('12-JAN-2017 11:45', 'DD-MM-YY HH24:MI'));
/*
INSERT INTO Diffusion (VideoID, Time)
            VALUES    (5, TO_DATE('4-NOV-2016 11:45', 'DD-MM-YY HH24:MI'));
INSERT INTO Diffusion (VideoID, Time)
            VALUES    (2, TO_DATE('5-NOV-2016 20:00', 'DD-MM-YY HH24:MI'));
INSERT INTO Diffusion (VideoID, Time)
            VALUES    (1, TO_DATE('5-NOV-2016 20:00', 'DD-MM-YY HH24:MI'));
*/


-- Subscriptions
INSERT INTO Subscription (UserID, ProgramID)
            VALUES       (1, 3);
INSERT INTO Subscription (UserID, ProgramID)
            VALUES       (1, 1);
INSERT INTO Subscription (UserID, ProgramID)
            VALUES       (2, 0);
INSERT INTO Subscription (UserID, ProgramID)
            VALUES       (3, 3);

-- User selections
INSERT INTO UserSelection (UserID, VideoID)
            VALUES        (0, 4);
INSERT INTO UserSelection (UserID, VideoID)
            VALUES        (0, 5);
INSERT INTO UserSelection (UserID, VideoID)
            VALUES        (3, 0);
INSERT INTO UserSelection (UserID, VideoID)
            VALUES        (4, 3);
INSERT INTO UserSelection (UserID, VideoID)
            VALUES        (4, 2);

-- User views
INSERT INTO UserView (UserID, VideoID, Time)
            VALUES   (0, 0, TO_DATE('13-JAN-2017 15:30:32', 'DD-MM-YY HH24:MI:SS'));
INSERT INTO UserView (UserID, VideoID, Time)
            VALUES   (0, 4, TO_DATE('13-JAN-2017 15:30:59', 'DD-MM-YY HH24:MI:SS'));
INSERT INTO UserView (UserID, VideoID, Time)
            VALUES   (1, 2, TO_DATE('20-FEB-2017 20:23:21', 'DD-MM-YY HH24:MI:SS'));
INSERT INTO UserView (UserID, VideoID, Time)
            VALUES   (2, 4, TO_DATE('13-JAN-2017 8:20:45', 'DD-MM-YY HH24:MI:SS'));
INSERT INTO UserView (UserID, VideoID, Time)
            VALUES   (2, 2, TO_DATE('13-JAN-2017 8:26:39', 'DD-MM-YY HH24:MI:SS'));
INSERT INTO UserView (UserID, VideoID, Time)
            VALUES   (2, 5, TO_DATE('02-MAR-2017 12:09:10', 'DD-MM-YY HH24:MI:SS'));
INSERT INTO UserView (UserID, VideoID, Time)
            VALUES   (2, 5, TO_DATE('03-MAR-2017 9:23:32', 'DD-MM-YY HH24:MI:SS'));
INSERT INTO UserView (UserID, VideoID, Time)
            VALUES   (3, 2, TO_DATE('17-JAN-2017 8:41:26', 'DD-MM-YY HH24:MI:SS'));
INSERT INTO UserView (UserID, VideoID, Time)
            VALUES   (3, 3, TO_DATE('29-JAN-2017 3:15:41', 'DD-MM-YY HH24:MI:SS'));
INSERT INTO UserView (UserID, VideoID, Time)
            VALUES   (3, 1, TO_DATE('02-FEB-2017 22:29:11', 'DD-MM-YY HH24:MI:SS'));
INSERT INTO UserView (UserID, VideoID, Time)
            VALUES   (3, 5, TO_DATE('04-FEB-2017 12:51:33', 'DD-MM-YY HH24:MI:SS'));
INSERT INTO UserView (UserID, VideoID, Time)
            VALUES   (3, 1, TO_DATE('11-MAR-2017 10:37:19', 'DD-MM-YY HH24:MI:SS'));
INSERT INTO UserView (UserID, VideoID, Time)
            VALUES   (3, 6, TO_DATE('11-MAR-2017 11:23:38', 'DD-MM-YY HH24:MI:SS'));
INSERT INTO UserView (UserID, VideoID, Time)
            VALUES   (3, 2, TO_DATE('11-MAR-2017 11:56:24', 'DD-MM-YY HH24:MI:SS'));


-- Preferences 
INSERT INTO Preference (UserID, CategoryID)
            VALUES     (0,2);
INSERT INTO Preference (UserID, CategoryID)
            VALUES     (2,3);
INSERT INTO Preference (UserID, CategoryID)
            VALUES     (4,2);




