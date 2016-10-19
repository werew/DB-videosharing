
CREATE TABLE User (
    UserID      integer             PRIMARY KEY,
    Login       varchar2(20)        NOT NULL UNIQUE,
    FirstName   varchar2(20)        ,
    LastName    varchar2(20)        ,
    Birth       date                ,
    Email       varchar2(320)       NOT NULL UNIQUE,
    NewsLetter  boolean             NOT NULL,
    Admin       boolean             NOT NULL
)
                

CREATE TABLE UserPass (
    UserID      integer             PRIMARY KEY,
    PassHash    char(41)            NOT NULL,       -- TODO 
    Salt        integer             NOT NULL,       -- TODO
    CONSTRAINT fk_UserPassUser      FOREIGN KEY (UserID) REFERENCES User
)

CREATE TABLE Category (
    CategoryID  integer             PRIMARY KEY,
    Name        varchar(20)         NOT NULL
)


CREATE TABLE Program (
    ProgramID   integer             PRIMARY KEY,
    Name        varchar(20)         NOT NULL,
    CategoryID  integer             NOT NULL,
    CONSTRAINT  fk_ProgramCategory  FOREIGN KEY (CategoryID) REFERENCES Category
)

CREATE TABLE Video (
    VideoID     integer             PRIMARY KEY,
    Name        varchar2(200)       NOT NULL,
    Description varchar2(400)       ,
    Length      integer             ,
    Country     varchar(3)          ,   -- TODO 3 o 2 o complete name ?
    FirstDiffusion date             ,
    Format      varchar(20)         ,
    MultiLang   boolean             ,
    ProgramID   integer             NOT NULL,
    CONSTRAINT fk_VideoProgram      FOREIGN KEY (ProgramID) REFERENCES Program
)
    
CREATE TABLE Diffusion (
    VideoID     integer             NOT NULL,
    Time        timestamp           NOT NULL,
    CONSTRAINT  pk_Diffusion PRIMARY KEY (VideoID, Time),
    CONSTRAINT  fk_DiffusionVideo FOREIGN KEY (VideoID) REFERENCES Video
)

CREATE TABLE Subscription (
    UserID      integer             NOT NULL,
    ProgramID   integer             NOT NULL,
    CONSTRAINT  pk_Subscription     PRIMARY KEY (UserID, ProgramID),
    CONSTRAINT  fk_SubscriptionUser FOREIGN KEY (UserID) REFERENCES User,
    CONSTRAINT  fk_SubscriptionProgram FOREIGN KEY (ProgramID) REFERENCES Program
)


CREATE TABLE UserSelection (
    UserID      integer             NOT NULL,
    VideoID     integer             NOT NULL,
    CONSTRAINT  pk_UserSelection    PRIMARY KEY (UserID, VideoID),
    CONSTRAINT  fk_UseSelectionUser FOREIGN KEY (UserID) REFERENCES User,
    CONSTRAINT  fk_UserSelectionVideo FOREIGN KEY (VideoID) REFERENCES Video
)


CREATE TABLE Preference (
    UserID      integer             NOT NULL,
    CategoryID  integer             NOT NULL,
    CONSTRAINT  pk_Preference       PRIMARY KEY (UserID, CategoryID),
    CONSTRAINT  fk_PreferenceUser   FOREIGN KEY (UserID) REFERENCES User,
    CONSTRAINT  fk_PreferenceCategory FOREIGN KEY (CategoryID) REFERENCES Category
)


