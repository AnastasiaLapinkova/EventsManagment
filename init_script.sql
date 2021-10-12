USE master;
GO
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'EventsManagementDB')
BEGIN
  CREATE DATABASE EventsManagementDB;
END;
GO
USE EventsManagementDB;
IF NOT EXISTS (SELECT * FROM EventsManagementDB.sys.tables WHERE name = 'Events')
BEGIN
CREATE TABLE Events (
EventID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
Name VARCHAR(50) NOT NULL,
Description VARCHAR(500),
StartDate DATE NOT NULL,
EndDate DATE NOT NULL
);
END;
GO
IF NOT EXISTS (SELECT * FROM EventsManagementDB.sys.tables WHERE name = 'Participants')
BEGIN
CREATE TABLE Participants(
ParticipantID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
Name VARCHAR(50) NOT NULL,
Description VARCHAR(500)
);
END;
GO
IF NOT EXISTS (SELECT * FROM EventsManagementDB.sys.tables WHERE name = 'ParticipantEvents')
BEGIN
CREATE TABLE ParticipantEvents(
ID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
ParticipantID INT NOT NULL,
EventID INT NOT NULL
);
END;
GO
IF NOT EXISTS (SELECT * FROM EventsManagementDB.sys.objects WHERE name = 'FK_ParticipantID')
BEGIN
ALTER TABLE ParticipantEvents
ADD CONSTRAINT FK_ParticipantID FOREIGN KEY (ParticipantID) REFERENCES Participants(ParticipantID);
END;
GO

IF NOT EXISTS (SELECT * FROM EventsManagementDB.sys.objects WHERE name = 'FK_EventID')
BEGIN
ALTER TABLE ParticipantEvents
ADD CONSTRAINT FK_EventID FOREIGN KEY (EventID) REFERENCES Events(EventID);
END;
GO

IF NOT EXISTS (SELECT * FROM EventsManagementDB.sys.tables WHERE name = 'EventTypes')
BEGIN
CREATE TABLE EventTypes(
EventTypeID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
EventID INT NOT NULL,
TypeID INT NOT NULL
);
END;
GO

IF NOT EXISTS (SELECT * FROM EventsManagementDB.sys.objects WHERE name = 'FK_EventTypesID')
BEGIN
ALTER TABLE EventTypes
ADD CONSTRAINT FK_EventTypesID FOREIGN KEY (EventID) REFERENCES Events(EventID);
END;
GO

IF NOT EXISTS (SELECT * FROM EventsManagementDB.sys.tables WHERE name = 'Types')
BEGIN
CREATE TABLE Types(
TypeID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
TypeName VARCHAR(50) NOT NULL,
AgeRestriction VARCHAR(10)
);
END;
GO

IF NOT EXISTS (SELECT * FROM EventsManagementDB.sys.objects WHERE name = 'FK_TypesEventID')
BEGIN
ALTER TABLE EventTypes
ADD CONSTRAINT FK_TypesEventID FOREIGN KEY (TypeID) REFERENCES Types(TypeID);
END;
GO

IF NOT EXISTS (SELECT * FROM EventsManagementDB.sys.tables WHERE name = 'Feedbacks')
BEGIN
CREATE TABLE Feedbacks(
FeedbackID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
UserID INT NOT NULL,
EventID INT NOT NULL,
FeedbackText VARCHAR(500),
CreatedOn DATE
);
END;
GO

 IF NOT EXISTS (SELECT * FROM EventsManagementDB.sys.objects WHERE name = 'FK_FeedbackID')
BEGIN
ALTER TABLE Feedbacks
ADD CONSTRAINT FK_FeedbackID FOREIGN KEY (EventID) REFERENCES Events(EventID);
END;
GO

IF NOT EXISTS (SELECT * FROM EventsManagementDB.sys.tables WHERE name = 'Users')
BEGIN
CREATE TABLE Users(
UserID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
FullName VARCHAR(50) NOT NULL,
Sex VARCHAR(10) NOT NULL,
BirthDate DATE NOT NULL,
Email VARCHAR(50) NOT NULL,
PhoneNumber VARCHAR (13) NOT NULL,
RoleID INT NOT NULL
);
END;
GO

IF NOT EXISTS (SELECT * FROM EventsManagementDB.sys.objects WHERE name = 'FK_UsersID')
BEGIN
ALTER TABLE Feedbacks
ADD CONSTRAINT FK_UsersID FOREIGN KEY (UserID) REFERENCES Users(UserID);
END;
GO
