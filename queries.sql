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






/*�����*/

/* 1. ����� ��� ����������� ������������ */

SELECT #TempTable.ID, Name, BirthDate, Age
FROM (SELECT Users.UserID AS ID, Users.FullName AS Name, Users.BirthDate AS BirthDate, DATEDIFF (YY, BirthDate, GETDATE () ) AS Age FROM Users) #TempTable
WHERE Age < 18

/* 2. ���������� ������� �� ��� ������������ */

SELECT AVG(DATEDIFF (YY, BirthDate, GETDATE () )) AS 'AverageAge'
FROM Users

/* 3. ³��������� ����� ��'� �� �������� ��� ������������ ����� ���� */

SELECT UserID, FullName, Email, PhoneNumber
FROM Users
WHERE Sex = 'Female'

/* 4. ����� ������, ��������� ������������ � ID = 1 */

SELECT Feedbacks.FeedbackID, Users.FullName, Events.Name, Feedbacks.FeedbackText
FROM Feedbacks
INNER JOIN Users
ON Feedbacks.UserID = Users.UserID
INNER JOIN Events
ON Feedbacks.EventID = Events.EventID
WHERE Feedbacks.UserID = 1

/* 5. ³��������� �� ����� ������ ���� 'Best deal' */

SELECT Orders.OrdersID, Orders.TicketID, Orders.UserID, Discounts.DiscountName
FROM Orders
INNER JOIN Discounts
ON Orders.DiscountID = Discounts.DiscountsID
WHERE Discounts.DiscountName = 'Best deal'

/* 6. ³��������� ������� �������� ������ ����� �������� �� ������� 'Stephen Ridley in Lviv' */

SELECT Tickets.TicketName, SUM(Orders.Quantity) AS 'QuantitySold'
FROM Tickets
INNER JOIN Orders
ON Orders.TicketID = Tickets.TicketID
WHERE Tickets.EventID = 3
GROUP BY Tickets.TicketName

/* 7. ³��������� �� ��䳿 ����� 2022 �. */

SELECT * FROM Events
WHERE StartDate >= '6/1/2022' AND EndDate <= '8/31/2022'

/* 8. ³��������� �� ��䳿 � �������� � 2021 �. */

SELECT * 
FROM Events 
WHERE EventID IN ( 
SELECT EventID FROM Tickets WHERE LocationID IN (
SELECT LocationsID FROM Locations WHERE City = 'Chernivtsi')) 
AND EndDate < '12/31/2021'

/* 9. ³��������� �� ��䳿 ��� ������� ��������� */

SELECT *
FROM Events
WHERE EventID IN (
SELECT EventID FROM EventTypes WHERE TypeID IN (
SELECT TypeID FROM Types WHERE AgeRestriction IS NULL))

/* 10. ����� ������������, ��� ����� �������� ���������� �� +38050 */

SELECT UserID, FullName, PhoneNumber FROM Users
WHERE PhoneNumber LIKE '+38050%'

/* 11. ³���������� ���� ������ �� ��������� ������� �������� */

SELECT Tickets.TicketName, SUM(Orders.Quantity) AS 'QuantitySold'
FROM Tickets 
INNER JOIN Orders
ON Orders.TicketID = Tickets.TicketID
GROUP BY Tickets.TicketName
ORDER BY QuantitySold desc

/* 12. ������ ��������� ����� �� ������� ������ */

SELECT SUM(Amount) AS TotalRevenue
FROM Payments

/* 13. ³��������� ������� �������� ��������� */

SELECT Orders.OrdersID, Amount AS Prepayment
FROM Payments
INNER JOIN Orders
ON Payments.PaymentsID = Orders.PaymentID
WHERE Orders.OrdersStatus = 'booked'

/* 14. ������� ������ ���, �� ������ ����������, �� ���������� ����, ��� ���������� �������� */

SELECT Orders.OrdersID, Users.UserID, Users.FullName, (Orders.Quantity * Tickets.Price) AS Cost, Payments.Amount AS Prepayment, ((Orders.Quantity * Tickets.Price) - Payments.Amount) AS LeftToPay
FROM Orders 
INNER JOIN Tickets
ON Orders.TicketID = Tickets.TicketID
INNER JOIN Payments 
ON Orders.PaymentID = Payments.PaymentsID
INNER JOIN Users
ON Orders.UserID = Users.UserID
WHERE Orders.OrdersStatus = 'booked'

/* 15. ³��������� ������ ��� ��䳿 �� � ����� */

SELECT EventID, Name
FROM Events
WHERE EventID IN (
SELECT EventID FROM Tickets WHERE LocationID IN (
SELECT LocationsID FROM Locations WHERE City <> 'Lviv'))

/* 16. ���������� ������� ������������ �� ������ */

SELECT Sex, COUNT (*) AS Users
FROM Users
WHERE RoleID IN (SELECT RolesID FROM Roles WHERE RoleName ='����������')
GROUP BY Sex

/* 17. ����������� ������������ �� ������������ �� ������ */

SELECT Users.Sex, Roles.RoleName, COUNT (*) AS Users
FROM Users
INNER JOIN Roles
ON Users.RoleID = Roles.RolesID
GROUP BY Users.Sex, Roles.RoleName
ORDER BY Users.Sex desc

/* 18. ������ ������� ������� ������� ������� ����������� */

SELECT Users.FullName, AVG (Payments.Amount) AS AveragePayment
FROM Orders
INNER JOIN Payments
ON Orders.PaymentID = Payments.PaymentsID
INNER JOIN Users
ON Orders.UserID = Users.UserID
GROUP BY Users.FullName

/* 19. ������ ������� ��������� ������� ����������� */

SELECT Users.FullName, COUNT(Orders.OrdersID) AS Orders
FROM Orders
INNER JOIN Users
ON Orders.UserID = Users.UserID
GROUP BY Users.FullName

/* 20. ³��������� ������������, �� ������� �� ����� ���� ��������� */

SELECT Users.FullName, COUNT (Orders.OrdersID) AS Orders
FROM Orders
INNER JOIN Users
ON Orders.UserID = Users.UserID
GROUP BY Users.FullName
HAVING COUNT(Orders.OrdersID) >= 2

/* 21. ³��������� ����� ����, �� �� ������� ����� 4 ������ */

SELECT Events.Name, COUNT (Orders.OrdersID) AS TicketsSold
FROM Tickets
INNER JOIN Events
ON Tickets.EventID = Events.EventID
INNER JOIN Orders
ON Tickets.TicketID = Orders.TicketID
GROUP BY Events.Name
HAVING COUNT (Orders.OrdersID) > 4

/* 22. ³���������� ��䳿 �� ����� */

SELECT *
FROM Events
ORDER BY StartDate

/* 23. ������ ������� ������������ ������� �� ������� ���������� ���� ��������� */

SELECT Users.FullName,
(CASE
	WHEN SUM (Payments.Amount) >= 8000 THEN 'VIP-����������'
	WHEN SUM (Payments.Amount) >= 5000 THEN '������� ����������'
	WHEN SUM (Payments.Amount) >= 3000 THEN '������ ����������'
ELSE '����������'
END ) AS Status
FROM Orders
INNER JOIN Users
ON Orders.UserID = Users.UserID
INNER JOIN Payments
ON Orders.PaymentID = Payments.PaymentsID
GROUP BY Users.FullName
ORDER BY Status

/* 24. ���������� ������������ �� ���� */

SELECT FullName,
(CASE
	WHEN DATEDIFF (YY, BirthDate, GETDATE ()) < 20 THEN '�� 20-�� ����'
	WHEN DATEDIFF (YY, BirthDate, GETDATE ()) < 25 THEN '�� 25-�� ����'
	WHEN DATEDIFF (YY, BirthDate, GETDATE ()) < 30 THEN '�� 30-�� ����'
ELSE '����� 30 ����'
END ) AS '³���� ��������'
FROM Users
GROUP BY FullName, DATEDIFF (YY, BirthDate, GETDATE ())
ORDER BY DATEDIFF (YY, BirthDate, GETDATE ())

/* 25. ³��������� ��䳿, �� ���� ����� ������ �������� */

SELECT Events.Name, COUNT(ParticipantEvents.ParticipantID) AS NumberOfParticipants
FROM Events
INNER JOIN ParticipantEvents
ON Events.EventID = ParticipantEvents.EventID
GROUP BY Name
HAVING COUNT(ParticipantEvents.ParticipantID) > 1

/* 26. ³��������� ������������, �� �������� ����� ������ ������ */

SELECT Users.FullName, COUNT (Feedbacks.FeedbackID) AS NumberOfFeedbacks
FROM Users
INNER JOIN Feedbacks
ON Users.UserID = Feedbacks.UserID
GROUP BY Users.FullName
HAVING COUNT (Feedbacks.FeedbackID) > 1

/* 27. ³��������� �������, �� ���� ����� ���� ���� ������ */

SELECT Locations.Address, COUNT (Tickets.TicketID) AS NumberOfTicketTypes
FROM Locations
INNER JOIN Tickets
ON Locations.LocationsID = Tickets.LocationID
GROUP BY Locations.Address
HAVING COUNT (Tickets.TicketID) > 2

/* 28. ���������� ������� ��������� ������� ������� */

SELECT OrdersStatus, COUNT (OrdersStatus) AS NumberOfOrders
FROM Orders
GROUP BY OrdersStatus
ORDER BY COUNT (OrdersStatus) DESC

/* 29. ����������� ������ �� ����� */

SELECT * 
FROM Payments
ORDER BY PaymentsID

/* 30. ����������� ������� �� ��������� ������� ���� */

SELECT LocationsID, City, Address, TotalQuantity
FROM Locations
ORDER BY TotalQuantity desc