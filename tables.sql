
CREATE TABLE WebUser (
    UserID      INTEGER             PRIMARY KEY,
    Login       VARCHAR2(20)        NOT NULL UNIQUE,
    FirstName   VARCHAR2(20)        ,
    LastName    VARCHAR2(20)        ,
    Birth       DATE                ,
    Email       VARCHAR2(320)       NOT NULL UNIQUE,
    NewsLetter  CHAR(1)             NOT NULL,
    Admin       CHAR(1)             NOT NULL,
    CONSTRAINT  ck_NewsLetter       CHECK (NewsLetter IN ('Y','N')),
    CONSTRAINT  ck_Admin            CHECK (Admin IN ('Y','N'))
);

CREATE TABLE UserPass (
    UserID      INTEGER             PRIMARY KEY,
    PassHash    CHAR(41)            NOT NULL,       -- TODO 
    Salt        INTEGER             NOT NULL,       -- TODO
    CONSTRAINT  fk_UserPassUser     FOREIGN KEY (UserID) 
                                    REFERENCES WebUser
                                    ON DELETE CASCADE
);

CREATE TABLE Category (
    CategoryID  INTEGER             PRIMARY KEY,
    Name        VARCHAR2(20)        NOT NULL
);


CREATE TABLE Program (
    ProgramID   INTEGER             PRIMARY KEY,
    Name        VARCHAR2(20)        NOT NULL,
    CategoryID  INTEGER             NOT NULL,
    CONSTRAINT  fk_ProgramCategory  FOREIGN KEY (CategoryID) 
                                    REFERENCES Category
);

CREATE TABLE Video (
    VideoID     INTEGER             PRIMARY KEY,
    Name        VARCHAR2(200)       NOT NULL,
    Description VARCHAR2(400)       ,
    Length      INTEGER             ,
    Country     VARCHAR2(3)         ,   -- TODO 3 o 2 o complete name ?
    FirstDiffusion DATE             ,
    Format      VARCHAR2(20)        ,
    MultiLang   CHAR(1)             ,
    ProgramID   INTEGER             NOT NULL,
    CONSTRAINT  fk_VideoProgram     FOREIGN KEY (ProgramID) 
                                    REFERENCES Program
                                    ON DELETE CASCADE,
    CONSTRAINT  ck_MultiLang        CHECK (MultiLang IN ('Y','N'))
);

CREATE TABLE ArchivedVideo (
    ArchivedVideoID  INTEGER        PRIMARY KEY,
    Name        VARCHAR2(200)       NOT NULL,
    Description VARCHAR2(400)       ,
    Length      INTEGER             ,
    Country     VARCHAR2(3)         ,   -- TODO 3 o 2 o complete name ?
    FirstDiffusion DATE             ,
    Format      VARCHAR2(20)        ,
    MultiLang   CHAR(1)             ,
    ProgramID   INTEGER             NOT NULL,
    CONSTRAINT  ck_MultiLangAv      CHECK (MultiLang IN ('Y','N'))
);
    
CREATE TABLE Diffusion (
    VideoID     INTEGER             NOT NULL,
    Time        DATE                NOT NULL,
    CONSTRAINT  pk_Diffusion        PRIMARY KEY (VideoID, Time),
    CONSTRAINT  fk_DiffusionVideo   FOREIGN KEY (VideoID) 
                                    REFERENCES Video
                                    ON DELETE CASCADE
);

CREATE TABLE Subscription (
    UserID      INTEGER             NOT NULL,
    ProgramID   INTEGER             NOT NULL,
    CONSTRAINT  pk_Subscription     PRIMARY KEY (UserID, ProgramID),
    CONSTRAINT  fk_SubscriptionUser FOREIGN KEY (UserID) 
                                    REFERENCES WebUser
                                    ON DELETE CASCADE,
    CONSTRAINT  fk_SubscriptionProgram FOREIGN KEY (ProgramID) 
                                    REFERENCES Program
                                    ON DELETE CASCADE
);


CREATE TABLE UserView (
    UserID      INTEGER             NOT NULL,
    VideoID     INTEGER             NOT NULL,
    Time        DATE                NOT NULL,
    CONSTRAINT  pk_UserView         PRIMARY KEY (UserID, VideoID, Time),
    CONSTRAINT  fk_UserViewUser     FOREIGN KEY (UserID) 
                                    REFERENCES WebUser
                                    ON DELETE CASCADE,
    CONSTRAINT  fk_UserViewVideo    FOREIGN KEY (VideoID) 
                                    REFERENCES Video
                                    ON DELETE CASCADE
);

CREATE TABLE UserSelection (
    UserID      INTEGER             NOT NULL,
    VideoID     INTEGER             NOT NULL,
    CONSTRAINT  pk_UserSelection    PRIMARY KEY (UserID, VideoID),
    CONSTRAINT  fk_UserSelectionUser FOREIGN KEY (UserID) 
                                    REFERENCES WebUser
                                    ON DELETE CASCADE,
    CONSTRAINT  fk_UserSelectionVideo FOREIGN KEY (VideoID) 
                                    REFERENCES Video
                                    ON DELETE CASCADE
);


CREATE TABLE Preference (
    UserID      INTEGER             NOT NULL,
    CategoryID  INTEGER             NOT NULL,
    CONSTRAINT  pk_Preference       PRIMARY KEY (UserID, CategoryID),
    CONSTRAINT  fk_PreferenceUser   FOREIGN KEY (UserID) 
                                    REFERENCES WebUser 
                                    ON DELETE CASCADE,
    CONSTRAINT  fk_PreferenceCategory FOREIGN KEY (CategoryID) 
                                    REFERENCES Category
                                    ON DELETE CASCADE
);


