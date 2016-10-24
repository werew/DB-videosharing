
-- XXX Improvements: better names, natural joins, 
-- problem with the future?

SELECT c.Name "Category" , COUNT(*) "Views"
FROM   Category c , UserView uv , Video v , Program p
WHERE  uv.Time > SYSDATE - 14 AND uv.VideoID = v.VideoID
       AND v.ProgramID = p.ProgramID AND p.CategoryID = c.CategoryID
GROUP BY c.CategoryID , c.Name ;

