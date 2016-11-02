
CREATE TABLE WebUser (
    UserID      INTEGER                 PRIMARY KEY,
    Login       VARCHAR2(35)            NOT NULL UNIQUE,
    FirstName   VARCHAR2(35)            ,
    LastName    VARCHAR2(35)            ,
    Birth       DATE                    ,
    Country     CHAR(2)                 ,
    Email       VARCHAR2(320)           NOT NULL UNIQUE,
    NewsLetter  CHAR(1)                 NOT NULL,
    Admin       CHAR(1)                 NOT NULL,
    CONSTRAINT  ck_NewsLetter           CHECK (NewsLetter IN ('Y','N')),
    CONSTRAINT  ck_Admin                CHECK (Admin IN ('Y','N'))
);


CREATE TABLE UserPass (
    UserID      INTEGER                 PRIMARY KEY,
    PassHash    CHAR(41)                NOT NULL,      
    Salt        INTEGER                 NOT NULL,    
    CONSTRAINT  fk_UserPass_WebUser     FOREIGN KEY (UserID) 
                                        REFERENCES WebUser
                                        ON DELETE CASCADE
);


CREATE TABLE Category (
    CategoryID  INTEGER                 PRIMARY KEY,
    Name        VARCHAR2(20)            NOT NULL UNIQUE
);


CREATE TABLE Program (
    ProgramID   INTEGER                 PRIMARY KEY,
    Name        VARCHAR2(20)            NOT NULL,
    CategoryID  INTEGER                 NOT NULL,
    CONSTRAINT  fk_Program_Category     FOREIGN KEY (CategoryID) 
                                        REFERENCES Category
);


CREATE TABLE Video (
    VideoID     INTEGER                 PRIMARY KEY,
    Name        VARCHAR2(200)           NOT NULL,
    Description VARCHAR2(400)           ,
    Length      INTEGER                 ,
    Country     CHAR(2)                 ,
    FirstDiffusion DATE                 ,
    Format      VARCHAR2(20)            ,
    MultiLang   CHAR(1)                 ,
    ProgramID   INTEGER                 NOT NULL,
    Expiration  DATE                    ,
    CONSTRAINT  fk_Video_Program        FOREIGN KEY (ProgramID) 
                                        REFERENCES Program,
    CONSTRAINT  ck_Video_MultiLang      CHECK (MultiLang IN ('Y','N'))
);


CREATE TABLE ArchivedVideo (
    ArchivedVideoID  INTEGER            PRIMARY KEY,
    Name        VARCHAR2(200)           NOT NULL,
    Description VARCHAR2(400)           ,
    Length      INTEGER                 ,
    Country     CHAR(2)                 ,
    FirstDiffusion DATE                 ,
    Format      VARCHAR2(20)            ,
    MultiLang   CHAR(1)                 ,
    CONSTRAINT  ck_ArchivedVideo_MultiLang CHECK (MultiLang IN ('Y','N'))
);

    
CREATE TABLE Diffusion (
    VideoID     INTEGER                 NOT NULL,
    Time        DATE                    NOT NULL,
    CONSTRAINT  pk_Diffusion            PRIMARY KEY (VideoID, Time),
    CONSTRAINT  fk_Diffusion_Video      FOREIGN KEY (VideoID) 
                                        REFERENCES Video
                                        ON DELETE CASCADE
);


CREATE TABLE Subscription (
    UserID      INTEGER                 NOT NULL,
    ProgramID   INTEGER                 NOT NULL,
    CONSTRAINT  pk_Subscription         PRIMARY KEY (UserID, ProgramID),
    CONSTRAINT  fk_Subscription_WebUser FOREIGN KEY (UserID) 
                                        REFERENCES WebUser
                                        ON DELETE CASCADE,
    CONSTRAINT  fk_Subscription_Program FOREIGN KEY (ProgramID) 
                                        REFERENCES Program
                                        ON DELETE CASCADE
);


CREATE TABLE UserView (
    UserID      INTEGER                 NOT NULL,
    VideoID     INTEGER                 NOT NULL,
    Time        DATE                    NOT NULL,
    CONSTRAINT  pk_UserView             PRIMARY KEY (UserID, VideoID, Time),
    CONSTRAINT  fk_UserView_WebUser     FOREIGN KEY (UserID) 
                                        REFERENCES WebUser
                                        ON DELETE CASCADE,
    CONSTRAINT  fk_UserView_Video       FOREIGN KEY (VideoID) 
                                        REFERENCES Video
                                        ON DELETE CASCADE
);

 
CREATE TABLE UserSelection (
    UserID      INTEGER                 NOT NULL,
    VideoID     INTEGER                 NOT NULL,
    CONSTRAINT  pk_UserSelection        PRIMARY KEY (UserID, VideoID),
    CONSTRAINT  fk_UserSelection_WebUser FOREIGN KEY (UserID) 
                                        REFERENCES WebUser
                                        ON DELETE CASCADE,
    CONSTRAINT  fk_UserSelection_Video  FOREIGN KEY (VideoID) 
                                        REFERENCES Video
                                        ON DELETE CASCADE
);


CREATE TABLE Preference (
    UserID      INTEGER                 NOT NULL,
    CategoryID  INTEGER                 NOT NULL,
    CONSTRAINT  pk_Preference           PRIMARY KEY (UserID, CategoryID),
    CONSTRAINT  fk_Preference_WebUser   FOREIGN KEY (UserID) 
                                        REFERENCES WebUser 
                                        ON DELETE CASCADE,
    CONSTRAINT  fk_Preference_Category  FOREIGN KEY (CategoryID) 
                                        REFERENCES Category
                                        ON DELETE CASCADE
);


