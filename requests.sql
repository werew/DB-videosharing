

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






