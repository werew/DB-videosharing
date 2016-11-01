
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

- Check the nulls into the if conditions

#Usefull
-IDENTITY: auto increment not implemented unti oracle 12c
http://docs.oracle.com/database/121/DRDAA/migr_tools_feat.htm#DRDAA109
need to use a trigger


# Constraint

- contraint pour les selections d'un utilisateur: il PEUT selectionner
  un video qui n'a pas encore ete diffus.

- Un utilisateur ne peut pas visionner un video qui n'a pas ete diffuse (Trigger VideoAvailable)

- Si la date de disponibilite n'est pas passe, un video ne peut pas etre supprime (Trigger WaitExpiration)

- Après une diffusion, une vidéo sera accessible sur le site en replay pendant
au moins 7 jours.  (trigger BadExpiration)

- Le temps d'une vue ne peut pas etre > SYSDATE  (DID ! Better application level)

- Si il reste du temps: la date de premiere diffusion d'un video ne doit pas
  etre superieure la ma date de la premiere diffusion dans la table diffusion (mais
  il peut entre inferieure) (DONE)

- Contraints sur la date de expiration (Trigger ValidView)

