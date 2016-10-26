

PROMPT
PROMPT ***** Requete N. 1 ******************************************************
PROMPT * Nombre de visionnages de videos par categories de videos, pour les    *
PROMPT * visionnages de moins de deux semaines.                                *
PROMPT *************************************************************************


-- XXX Improvements: better names, natural joins, 
-- problem with the future?

SELECT c.Name "Category" , COUNT(*) "Views"
FROM   Category c , UserView uv , Video v , Program p
WHERE  uv.Time > SYSDATE - 14 
    AND uv.VideoID = v.VideoID
    AND v.ProgramID = p.ProgramID 
    AND p.CategoryID = c.CategoryID
GROUP BY c.CategoryID , c.Name ;


-- En utilisant des INNER JOIN

/* 
SELECT Category.Name "Category" , COUNT(*) "Views"
FROM Category 
    INNER JOIN Program 
        ON Program.CategoryID = Category.CategoryID 
    INNER JOIN Video
        ON Video.ProgramID = Program.ProgramID
    INNER JOIN UserView
        ON UserView.VideoID = Video.VideoID
WHERE  UserView.Time > SYSDATE - 14
GROUP BY Category.Name ;
*/


PROMPT ***** Requete N. 2 ******************************************************
PROMPT * Par utilisateur, le nombre d''abonnements, de favoris et de videos    *
PROMPT * visionnees                                                            *
PROMPT *************************************************************************


SELECT u.UserID "User", 
       COUNT(DISTINCT s.ProgramID)  "Subscriptions", 
       COUNT(DISTINCT us.VideoID ) "Selections"   ,
       COUNT(DISTINCT CONCAT(uv.VideoID,uv.Time)) "Views"
FROM WebUser u
    LEFT OUTER JOIN Subscription s 
        ON u.UserID = s.UserID 
    LEFT OUTER JOIN UserSelection us
        ON u.UserID = us.UserID 
    LEFT OUTER JOIN UserView uv
        ON u.UserID = uv.UserID 
GROUP BY u.UserID
ORDER BY u.UserID;


/*
SELECT u.UserID "User", 
       COUNT(DISTINCT s.ProgramID)  "Subscriptions", 
       COUNT(DISTINCT us.VideoID ) "Selections"   ,
       k.Count "Views"
FROM WebUser u
    LEFT OUTER JOIN Subscription s 
        ON u.UserID = s.UserID 
    LEFT OUTER JOIN UserSelection us
        ON u.UserID = us.UserID 
    INNER JOIN ( SELECT u.UserID UserID, COUNT(uv.UserID) Count
		 FROM WebUser u
		      LEFT OUTER JOIN UserView uv
		      ON u.UserID = uv.UserID 
		 GROUP BY u.UserID
		) k
        ON u.UserID = k.UserID 
GROUP BY u.UserID, k.Count
ORDER BY u.UserID;
*/



PROMPT ***** Requete N. 3 ******************************************************
PROMPT * Pour chaque video, le nombre de visionnages par des utilisateurs      *
PROMPT * francais, le nombrede visionnage par des utilisateurs allemand, la    *
PROMPT * difference entre les deux, trees par valeu absolue de la difference   *
PROMPT * entre les deux.						       *
PROMPT *************************************************************************




WITH nb_views AS (
	SELECT v.VideoID,
	       COUNT(CASE WHEN u.Country = 'FR' then 1 else null end)  as fr,
	       COUNT(CASE WHEN u.Country = 'DE' then 1 else null end)  as de
	FROM Video v
	LEFT OUTER JOIN UserView uv
	    ON v.VideoID = uv.VideoID
	LEFT OUTER JOIN WebUser u
	    ON uv.UserID = u.UserID 
	GROUP BY v.VideoID )
SELECT VideoID, fr "Views FR", de "Views DE", ABS(fr-de) "Difference"
FROM nb_views
ORDER BY "Difference";


/*
SELECT v.VideoID, fr.NbViews "Views FR" , de.NbViews "Views DE", 
       ABS(de.NbViews - fr.NbViews) as "Difference"
FROM Video v
LEFT OUTER JOIN (SELECT v.VideoID, COUNT(u.UserID) NbViews
	         FROM Video v
	         LEFT OUTER JOIN UserView uv
	             ON v.VideoID = uv.VideoID
	         LEFT OUTER JOIN WebUser u
	             ON uv.UserID = u.UserID AND u.Country = 'FR'
	         GROUP BY v.VideoID) fr
    ON v.VideoID = fr.VideoID
LEFT OUTER JOIN (SELECT v.VideoID, COUNT(u.UserID) NbViews
	         FROM Video v
	         LEFT OUTER JOIN UserView uv
	             ON v.VideoID = uv.VideoID
	         LEFT OUTER JOIN WebUser u
	             ON uv.UserID = u.UserID AND u.Country = 'DE'
	         GROUP BY v.VideoID) de
    ON v.VideoID = de.VideoID 
ORDER BY "Difference";
*/



PROMPT ***** Requete N. 4 ******************************************************
PROMPT * Les episodes d''emissions qui ont au moins deux fois plus de          * 
PROMPT * visionnage que la moyenne des visionnages des autres épisode	       *
PROMPT * del''emission.	                                                       *
PROMPT *************************************************************************


WITH nbuv AS 
	(SELECT p.ProgramID ProgramID, 
		v.VideoID VideoID, 
		COUNT(uv.VideoID) NbViews
	 FROM Video v
		 INNER JOIN Program p ON v.ProgramID = p.ProgramID
		 LEFT OUTER JOIN UserView uv ON v.VideoID = uv.VideoID
	 GROUP BY v.VideoID, p.ProgramID
	)
SELECT N1.VideoID
FROM nbuv N1
WHERE N1.NbViews >= COALESCE(
		(SELECT AVG(N2.NbViews)
		FROM nbuv N2 
		WHERE N2.VideoID <> N1.VideoID
		GROUP BY N2.ProgramID HAVING N2.ProgramID = N1.ProgramID
		), 0 ) * 3;




