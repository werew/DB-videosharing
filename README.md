
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
- CHAR(2) for countries car on utilise ISO 3166-1 alpha-2



# Memo
- Les videos archivee doivent etre deplace dans une autre table (voir mail prof)
- Les contraint d'integrite doivent etre rendu


#TODO

- Fix Name in entity User

- Create a file to show all the constraints and 
  some other actions. Need to print everything on the screen

- Create documentation

- Create a guide for correspondence english tables names --> french names into the project
  ex: Video Favoris --> UserSelection

- If there is time: http://stackoverflow.com/questions/10286204/the-right-json-date-format

#Usefull
-IDENTITY: auto increment not implemented unti oracle 12c
http://docs.oracle.com/database/121/DRDAA/migr_tools_feat.htm#DRDAA109
need to use a trigger


# Constraint
- La date de la premier diffusion de chaque video doit correspondre
  a la diffusion la plus ancienne (il peut etre NULL si il n'y a
  encore aucune diffusion)

- contraint pour les selections d'un utilisateur: il ne peut pas selectionner
  un video qui n'a pas encore ete diffus.

- Un utilisateur ne peut pas visionner un video qui n'a pas ete diffuse

- Si la date de disponibilite n'est pas passe, un video ne peut pas etre supprime

- Après une diffusion, une vidéo sera accessible sur le site en replay pendant
au moins 7 jours. 

- Le temps d'une vue ne peut pas etre > SYSDATE

