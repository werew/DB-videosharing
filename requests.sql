

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



