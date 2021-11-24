/*��������*/
/*
1. �������� ������ ��� ��������� ���������
*/
SELECT OrdersID,OrdersStatus FROM Orders WHERE OrdersStatus = 'paid'

/*
2. ���������� ������ ���������� ����� ���� ID
*/
SELECT OrdersStatus FROM Orders WHERE OrdersID = 2
SELECT OrdersStatus FROM Orders WHERE OrdersID = 6

/*
3. ������ ���� ���� �� ������ ���������� �� �������� ������
*/
SELECT TypeName FROM Types WHERE AgeRestriction >= 18 AND TypeName LIKE '%��%'

/*
4. ������� ������ � ���� ��� ������� 1 ��� ���� ����� 800
*/
SELECT * FROM Tickets WHERE TicketName = 'Fan 1' OR Price >= 800

/*
4. ������� �������, �� ����������� � �����
*/
SELECT * FROM Locations WHERE City NOT LIKE '�.%'

/*
5. ������� ��䳿 � ��� Lviv
*/
SELECT EventID, Name, StartDate FROM Events WHERE EventID IN (
	SELECT DISTINCT EventID FROM Tickets WHERE LocationID IN (
		SELECT LocationsID FROM Locations WHERE City = 'Lviv'
	)
)
/*
6. ������� �� ������ � �� ��������
*/

SELECT TicketName, (
	SELECT Address 
	FROM Locations 
	WHERE Locations.LocationsID = Tickets.LocationID
) as Address 
FROM Tickets

/*
7. ������� ��䳿 � ���� ���� �� 200 �� 600 ���
*/
SELECT * FROM Events WHERE EventID IN (
	SELECT EventID FROM Tickets WHERE Price BETWEEN 200 AND 600
)


/*
7*. ������� ��䳿 � ���� ���� �� 200 �� 600 ���, ��� ��� ������������ ����, ��� ������, ����� ��䳿, ���� ������� �� �������
*/

SELECT Price, TicketName, Name, StartDate, City, Address
FROM Tickets 
INNER JOIN Events
ON Tickets.Price BETWEEN 200 AND 600 AND Tickets.EventID = Events.EventID
INNER JOIN Locations 
ON Tickets.LocationID = Locations.LocationsID
 
 /*
8. ������� ��䳿 � ���� ���� ������ ���������� The HARDKISS
*/
SELECT Participants.Name, Participants.Description, Events.Name,Events.StartDate  FROM ParticipantEvents
INNER JOIN Participants
ON Participants.ParticipantID = ParticipantEvents.ParticipantID AND Participants.Name = 'The HARDKISS'
LEFT JOIN Events
ON ParticipantEvents.EventID = Events.EventID

/*
9.������� �� ��������� ������ ������ � UNDERHILL
*/
SELECT Participants.* FROM ParticipantEvents
INNER JOIN Events
ON Events.Name LIKE 'UNDERHILL%' AND Events.EventID = ParticipantEvents.EventID
LEFT JOIN Participants
ON ParticipantEvents.ParticipantID = Participants.ParticipantID

/*
10.������� ������� �� �����
*/
SELECT City, Address
FROM Locations
GROUP BY City, Address

/*
11.������� ��䳿 �� �����
*/
SELECT EventTypes.TypeID, Events.Name,Types.TypeName
FROM EventTypes
INNER JOIN Events
ON EventTypes.EventID = Events.EventID
INNER JOIN Types
ON Types.TypeID = EventTypes.TypeID
GROUP BY EventTypes.TypeID, Events.Name,Types.TypeName

/*
12.������ ������ ���������� �� ����
*/
SELECT (
(SELECT TotalQuantity FROM Locations WHERE LocationsID IN (
	SELECT DISTINCT LocationID FROM Tickets WHERE EventID = 7
))
-
(SELECT SUM (Quantity) FROM Orders WHERE TicketID IN (
	SELECT DISTINCT TicketID FROM Tickets WHERE EventID = 7
))
)
as 'Tickets Left'

/*
13. ������ ����������� � �������� ���� �� ������
*/
SELECT  min (Price) as 'Min Price', max(Price) as 'Max Price'
FROM Tickets

/*
14. ���������� ������� ������������, �� �� � �������������
*/
SELECT  count (UserID) as 'ʳ������ ������������'
FROM Users
Where RoleID IN ( select RolesID from Roles where RoleName not like '�%') 

/*
15. ������ ����������� ���� ����� 30 ����
*/

SELECT #TempTable.Name, Age
FROM (SELECT Users.FullName AS Name, (DATEDIFF(YEAR, Users.BirthDate,GETDATE())) as Age FROM Users) #TempTable 
GROUP BY Age, #TempTable.Name
HAVING Age > 30

/*
16. ���������� ������������ �� ��� �� ����������� �� ������������
*/
SELECT DATEDIFF(YEAR, Users.BirthDate,GETDATE()) as Age, FullName
FROM Users
ORDER BY Age DESC

/*
17. ������ ������� ���� �� ��䳿 �� ������ ���� �������� ����������� ��������
*/

SELECT  Events.Name, Types.TypeName, Tickets.TicketName, Locations.Address, Locations.TotalQuantity,
(CASE Types.TypeName
		WHEN '�������' THEN Locations.TotalQuantity / 5
		WHEN '�����' THEN Locations.TotalQuantity / 2
		WHEN '��������' THEN 10
		WHEN '������' THEN 0
		ELSE Locations.TotalQuantity
	END ) AS 'ʳ������ ���� ����� � ����������� �����������'
FROM Events
INNER JOIN EventTypes
ON EventTypes.EventID = Events.EventID
INNER JOIN Types
ON EventTypes.TypeID = Types.TypeID
INNER JOIN Tickets
ON Tickets.EventID = Events.EventID
INNER JOIN Locations
ON Locations.LocationsID = Tickets.LocationID
