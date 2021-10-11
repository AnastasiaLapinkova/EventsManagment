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
