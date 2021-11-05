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
IF NOT EXISTS (SELECT * FROM EventsManagementDB.sys.tables WHERE name = 'Roles')
BEGIN
CREATE TABLE Roles(
RolesID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
RoleName VARCHAR(25) NOT NULL
);
END;
GO

IF NOT EXISTS (SELECT * FROM EventsManagementDB.sys.objects WHERE name = 'FK_RolesID')
BEGIN
ALTER TABLE Users
ADD CONSTRAINT FK_RolesID FOREIGN KEY (RoleID) REFERENCES Roles(RolesID);
END;
GO

IF NOT EXISTS (SELECT * FROM EventsManagementDB.sys.tables WHERE name = 'Payments')
BEGIN
CREATE TABLE Payments(
PaymentsID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
Amount DECIMAL(10,2) NOT NULL,
PaymentDate DATE
);
END;
GO

IF NOT EXISTS (SELECT * FROM EventsManagementDB.sys.tables WHERE name = 'Locations')
BEGIN
CREATE TABLE Locations(
LocationsID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
City VARCHAR(25) NOT NULL,
Address VARCHAR(100) NOT NULL,
Notes VARCHAR(250) NOT NULL,
TotalQuantity INT NOT NULL
);
END;
GO

IF NOT EXISTS (SELECT * FROM EventsManagementDB.sys.tables WHERE name = 'Tickets')
BEGIN
CREATE TABLE Tickets(
TicketID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
Price Decimal(10,2) NOT NULL,
TicketName NVarchar(25) NOT NULL,
EventID INT NOT NULL,
LocationID INT Not Null
);
END;
GO


IF NOT EXISTS (SELECT * FROM EventsManagementDB.sys.objects WHERE name = 'FK_LocationsID')
BEGIN
ALTER TABLE Tickets
ADD CONSTRAINT FK_LocationsID FOREIGN KEY (LocationID) REFERENCES Locations(LocationsID);
END;
GO

IF NOT EXISTS (SELECT * FROM EventsManagementDB.sys.objects WHERE name = 'FK_TicketEventID')
BEGIN
ALTER TABLE Tickets
ADD CONSTRAINT FK_TicketEventID FOREIGN KEY (EventID) REFERENCES Events(EventID);
END;
GO

IF NOT EXISTS (SELECT * FROM EventsManagementDB.sys.tables WHERE name = 'Discounts')
BEGIN
CREATE TABLE Discounts(
DiscountsID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
DiscountName VARCHAR(25) NOT NULL,
Amount DECIMAL(10,2) NOT NULL,
TicketID INT NOT NULL
);
END;
GO

IF NOT EXISTS (SELECT * FROM EventsManagementDB.sys.objects WHERE name = 'FK_DiscountsTicketID')
BEGIN
ALTER TABLE Discounts
ADD CONSTRAINT FK_DiscountsTicketID FOREIGN KEY (TicketID) REFERENCES Tickets(TicketID);
END;
GO

IF NOT EXISTS (SELECT * FROM EventsManagementDB.sys.tables WHERE name = 'Orders')
BEGIN
CREATE TABLE Orders(
OrdersID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
TicketID INT NOT NULL,
UserID INT NOT NULL,
Quantity INT NOT NULL,
PaymentID INT NOT NULL,
DiscountID INT NOT NULL,
OrdersStatus VARCHAR(25) NOT NULL,
);
END;
GO

IF NOT EXISTS (SELECT * FROM EventsManagementDB.sys.objects WHERE name = 'FK_DiscountsID')
BEGIN
ALTER TABLE Orders
ADD CONSTRAINT FK_DiscountsID FOREIGN KEY (DiscountID) REFERENCES Discounts(DiscountsID);
END;
GO

IF NOT EXISTS (SELECT * FROM EventsManagementDB.sys.objects WHERE name = 'FK_Payment_Orders')
BEGIN
ALTER TABLE Orders
ADD CONSTRAINT FK_Payment_Orders FOREIGN KEY (PaymentID) REFERENCES Payments(PaymentsID);
END;
GO

IF NOT EXISTS (SELECT * FROM EventsManagementDB.sys.objects WHERE name = 'FK_Ticket_Orders')
BEGIN
ALTER TABLE Orders
ADD CONSTRAINT FK_Ticket_Orders FOREIGN KEY (TicketID) REFERENCES Tickets(TicketID);
END;
GO

IF NOT EXISTS (SELECT * FROM EventsManagementDB.sys.objects WHERE name = 'FK_Users_Orders')
BEGIN
ALTER TABLE Orders
ADD CONSTRAINT FK_Users_Orders FOREIGN KEY (UserID) REFERENCES Users(UserID);
END;
GO