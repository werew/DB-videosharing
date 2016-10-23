
# Decisions
- En anglais car c'est mieux XD
- Password hashee avec un algoritme efficace 
- Utiliser le Salt pour hasher les passwords
- Mettre les hash et les Stalts dans une table separee 
(souligner le fait que il serait mieu avoir les hashes dans une
machine separe)
- Le type email c'est varchar(320) car https://tools.ietf.org/html/rfc5321.html specifie 64 chars username+ 1 char @ + 255 chars domain name
- Not support for unicode
- ?? store separately domain names
- varchar2 instead of varchar https://docs.oracle.com/cd/B28359_01/server.111/b28318/datatype.htm#i3253
- email unique
- char(1) avec check in ('Y','N') au lieu de BOOLEAN car il n'est pas 
  present sur oracle



# Memo
- Les videos archivee doivent etre deplace dans une autre table (voir mail prof)
- Les contraint d'integrite doivent etre rendu


#TODO

- Fix Name in entity User


#Usefull
-IDENTITY: auto increment not implemented unti oracle 12c
http://docs.oracle.com/database/121/DRDAA/migr_tools_feat.htm#DRDAA109
need to use a trigger

