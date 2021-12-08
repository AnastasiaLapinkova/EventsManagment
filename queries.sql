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



/*����*/

/* 1. ���� ������� �� ������� ���� � ������ 500  */

SELECT * 
FROM Locations 
Where TotalQuantity<=500

/* 2. ���� ������ ��� ������� 6 � ������� �������� ����  */

SELECT TicketID,TicketName, Price
FROM Tickets 
Where LocationID=6
Order by Price DESC

/* 3. ���� ������������ ������ � 1 ��� 2 ������� */

SELECT  min(Price) as "����������� ������"
from Tickets
Where LocationID= 1 or LocationID= 2

/* 4. ϳ�������� ������ �� ������� ������ �� ���� ���� */

SElECT SUM(Amount) as "����� �� 06/06/2021"
From Payments
WHERE PaymentDate='06/06/2021'

/* 5. ���� ������ �� ������� ������ �������� � ���� ������� */

SELECT Discounts.DiscountName, Orders.DiscountID,Orders.Quantity
FROM Orders
INNER JOIN Discounts
ON Orders.DiscountID = Discounts.DiscountsID
ORDER BY Quantity desc

/* 6. ����� ��������� ���������� ���� � RoleID - 1 */

Select Distinct FullName, Email,PhoneNumber
From Users
Where RoleID=1 AND Sex='Female'
Order by FullName Asc

/* 7. ���������� ������� �������� ���� ������� ���� ������� */

Select Amount,PaymentDate,
Case	
	When Amount<500 Then '���������� 10 ����'
	When Amount >500 and Amount<1000 Then '���������� 20 ����'
	When Amount > 1000 Then '���������� 30 ����'
END number_of_points
From Payments

/* 8. ���������� ���� �� ����������� �������� ��� �볺��� �� �������� ����� 2 ������*/

SELECT Distinct Orders.UserID, Users.FullName, Users.PhoneNumber,Orders.Quantity
FROM Orders
INNER JOIN Users
ON Orders.UserID = Users.UserID
Where Quantity>2
ORDER BY Users.FullName desc

/* 9. ����� ���������� ���� ������� �� ����, �� ����� �� ����������� ��� ������� ����� ������ */

SELECT Distinct Feedbacks.FeedbackText, Users.FullName,Events.Name
FROM Feedbacks
INNER JOIN Events
ON Feedbacks.EventID = Events.EventID
INNER JOIN Users
ON Users.UserID=Feedbacks.UserID
ORDER BY Users.FullName desc

/* 10. ���� ������ �� ���� ������ � ��������� �� 1000 ���.  */

SELECT Distinct EventID, Name, StartDate,EndDate FROM Events WHERE EventID IN (
	SELECT DISTINCT LocationID FROM Tickets WHERE Price>1000
)

/* 11. ���������� �������� ������� ���������� ����������  */

SELECT  AVG(Amount) AS '������� ������� ����������'
FROM Payments

/* 12. ������ ������ ������������ �������� 35 ���� � �� �������� ������  */

SELECT #TempTable.Name, Age, Contact_number
FROM (SELECT Users.FullName AS Name, Users.PhoneNumber AS Contact_number, (DATEDIFF(YEAR, Users.BirthDate,GETDATE())) as Age FROM Users) #TempTable 
GROUP BY Age, #TempTable.Name, Contact_number
HAVING Age < 35
  

 /* 13. ������ ������, ������ ���������� �� ������� ����������  */

SELECT Distinct Payments.PaymentDate,Payments.PaymentsID, Orders.DiscountID, Orders.OrdersStatus
FROM Payments
INNER JOIN Orders
ON Orders.PaymentID = Payments.PaymentsID
 WHERE OrdersID = 4

 /* 14. ������ ������ ����������� ���������  */

SELECT OrdersID,OrdersStatus 
FROM Orders 
WHERE OrdersStatus = 'booked'

/* 15. ������ ������ ������������, �� ������� ����������, � ���� � UserID �������� ����� 1  */

SELECT  Distinct Orders.TicketID, Orders.UserID, Discounts.DiscountName,Orders.OrdersStatus
FROM Orders
INNER JOIN Discounts
ON Orders.DiscountID = Discounts.DiscountsID
WHERE Orders.UserID LIKE '%1%'

/* 16.  ���� ������������ ������ ��� ����� ������� � ��� ���� */

SELECT  min(Price) as "����������� ������", Locations.Address, Locations.TotalQuantity
from Tickets
INNER JOIN Locations
ON Locations.LocationsID=Tickets.LocationID
Where City= 'Lviv'
Group by Locations.Address, Locations.TotalQuantity

/* 17.  ���� ��� ������ �� ��䳿, �� ����������� � 2021 ���� �� ����� ������ ����� 100 ���.*/

SELECT Distinct Events.StartDate, Tickets.TicketID, Tickets.TicketName, Tickets.LocationID
From Events
INNER JOIN Tickets
ON Tickets.EventID=Events.EventID
Where Tickets.Price>100 AND Events.StartDate < '12/31/2021'

/* 18.  ���� ��� ������������, �� � ��������� */

SELECT *
From Users
Where Sex='Male' AND RoleID=1

/* 19.  ���� ���������� ��� ������������ �� �������� ���������� �� ���� ����� �� 1500 ���. */

SELECT Distinct Users.FullName, Payments.Amount, Orders.DiscountID
From Users
INNER JOIN Orders
ON Orders.UserID=Users.UserID
INNER JOIN Payments
ON Payments.PaymentsID=Orders.PaymentID
WHERE Payments.Amount>1500

/* 20.  ���� ���������� ��� ���������� � ����� ������ ����� 100 ���. */

SELECT Distinct Orders.TicketID, Discounts.DiscountName, Orders.DiscountID, Discounts.Amount, Orders.UserID
FROM Orders
INNER Join Discounts
ON Orders.DiscountID=Discounts.DiscountsID
Where Discounts.Amount<100
Order by UserID ASC