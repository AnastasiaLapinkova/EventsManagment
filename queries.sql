/*Анастасія*/
/*
1. Отримуємо список усіх оплачених замовлень
*/
SELECT OrdersID,OrdersStatus FROM Orders WHERE OrdersStatus = 'paid'

/*
2. Перевіряємо статус замовлення через його ID
*/
SELECT OrdersStatus FROM Orders WHERE OrdersID = 2
SELECT OrdersStatus FROM Orders WHERE OrdersID = 6

/*
3. Шукаємо типи подій за віковим обмеженням та неповною назвою
*/
SELECT TypeName FROM Types WHERE AgeRestriction >= 18 AND TypeName LIKE '%ст%'

/*
4. Обираємо квитки в яких тип фанзона 1 або ціна більше 800
*/
SELECT * FROM Tickets WHERE TicketName = 'Fan 1' OR Price >= 800

/*
4. Обираємо локації, які знаходяться в містах
*/
SELECT * FROM Locations WHERE City NOT LIKE 'с.%'

/*
5. Обираємо події у місті Lviv
*/
SELECT EventID, Name, StartDate FROM Events WHERE EventID IN (
	SELECT DISTINCT EventID FROM Tickets WHERE LocationID IN (
		SELECT LocationsID FROM Locations WHERE City = 'Lviv'
	)
)
/*
6. Вивести які квитки є на локаціях
*/

SELECT TicketName, (
	SELECT Address 
	FROM Locations 
	WHERE Locations.LocationsID = Tickets.LocationID
) as Address 
FROM Tickets

/*
7. Обираємо події в яких ціна від 200 до 600 грн
*/
SELECT * FROM Events WHERE EventID IN (
	SELECT EventID FROM Tickets WHERE Price BETWEEN 200 AND 600
)


/*
7*. Обираємо події в яких ціна від 200 до 600 грн, але вже відображається ціна, тип квитка, назва події, дата початку та локацію
*/

SELECT Price, TicketName, Name, StartDate, City, Address
FROM Tickets 
INNER JOIN Events
ON Tickets.Price BETWEEN 200 AND 600 AND Tickets.EventID = Events.EventID
INNER JOIN Locations 
ON Tickets.LocationID = Locations.LocationsID
 
 /*
8. Обираємо події в яких бере участь виконавець The HARDKISS
*/
SELECT Participants.Name, Participants.Description, Events.Name,Events.StartDate  FROM ParticipantEvents
INNER JOIN Participants
ON Participants.ParticipantID = ParticipantEvents.ParticipantID AND Participants.Name = 'The HARDKISS'
LEFT JOIN Events
ON ParticipantEvents.EventID = Events.EventID

/*
9.Обираємо які виконавці беруть участь в UNDERHILL
*/
SELECT Participants.* FROM ParticipantEvents
INNER JOIN Events
ON Events.Name LIKE 'UNDERHILL%' AND Events.EventID = ParticipantEvents.EventID
LEFT JOIN Participants
ON ParticipantEvents.ParticipantID = Participants.ParticipantID

/*
10.Групуємо локації по містам
*/
SELECT City, Address
FROM Locations
GROUP BY City, Address

/*
11.Групуємо події по типам
*/
SELECT EventTypes.TypeID, Events.Name,Types.TypeName
FROM EventTypes
INNER JOIN Events
ON EventTypes.EventID = Events.EventID
INNER JOIN Types
ON Types.TypeID = EventTypes.TypeID
GROUP BY EventTypes.TypeID, Events.Name,Types.TypeName

/*
12.Скільки квитків залишилось на подію
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
13. Знайти максимальну і мінімальну ціну на квитки
*/
SELECT  min (Price) as 'Min Price', max(Price) as 'Max Price'
FROM Tickets

/*
14. Порахувати кількість користувачів, які не є адмістраторами
*/
SELECT  count (UserID) as 'Кількість користувачів'
FROM Users
Where RoleID IN ( select RolesID from Roles where RoleName not like 'А%') 

/*
15. Знайти кристувачів яким більше 30 років
*/

SELECT #TempTable.Name, Age
FROM (SELECT Users.FullName AS Name, (DATEDIFF(YEAR, Users.BirthDate,GETDATE())) as Age FROM Users) #TempTable 
GROUP BY Age, #TempTable.Name
HAVING Age > 30

/*
16. Згрупувати користувачів по віку від найстаршого до наймолодшого
*/
SELECT DATEDIFF(YEAR, Users.BirthDate,GETDATE()) as Age, FullName
FROM Users
ORDER BY Age DESC

/*
17. Змінити кількість місць на події за типами після введення карантинних обмежень
*/

SELECT  Events.Name, Types.TypeName, Tickets.TicketName, Locations.Address, Locations.TotalQuantity,
(CASE Types.TypeName
		WHEN 'Концерт' THEN Locations.TotalQuantity / 5
		WHEN 'Театр' THEN Locations.TotalQuantity / 2
		WHEN 'Екскурсія' THEN 10
		WHEN 'Дитяча' THEN 0
		ELSE Locations.TotalQuantity
	END ) AS 'Кількість місць згідно з карантинним обмеженнями'
FROM Events
INNER JOIN EventTypes
ON EventTypes.EventID = Events.EventID
INNER JOIN Types
ON EventTypes.TypeID = Types.TypeID
INNER JOIN Tickets
ON Tickets.EventID = Events.EventID
INNER JOIN Locations
ON Locations.LocationsID = Tickets.LocationID






/*Ірина*/

/* 1. Пошук всіх неповнолітніх користувачів */

SELECT #TempTable.ID, Name, BirthDate, Age
FROM (SELECT Users.UserID AS ID, Users.FullName AS Name, Users.BirthDate AS BirthDate, DATEDIFF (YY, BirthDate, GETDATE () ) AS Age FROM Users) #TempTable
WHERE Age < 18

/* 2. Порахувати середній вік всіх користувачів */

SELECT AVG(DATEDIFF (YY, BirthDate, GETDATE () )) AS 'AverageAge'
FROM Users

/* 3. Відобразити повне ім'я та контакти усіх користувачів жіночої статі */

SELECT UserID, FullName, Email, PhoneNumber
FROM Users
WHERE Sex = 'Female'

/* 4. Пошук відгуків, залишених користувачем з ID = 1 */

SELECT Feedbacks.FeedbackID, Users.FullName, Events.Name, Feedbacks.FeedbackText
FROM Feedbacks
INNER JOIN Users
ON Feedbacks.UserID = Users.UserID
INNER JOIN Events
ON Feedbacks.EventID = Events.EventID
WHERE Feedbacks.UserID = 1

/* 5. Відобразити всі надані знижки типу 'Best deal' */

SELECT Orders.OrdersID, Orders.TicketID, Orders.UserID, Discounts.DiscountName
FROM Orders
INNER JOIN Discounts
ON Orders.DiscountID = Discounts.DiscountsID
WHERE Discounts.DiscountName = 'Best deal'

/* 6. Відобразити кількість проданих квитків різних категорій на концерт 'Stephen Ridley in Lviv' */

SELECT Tickets.TicketName, SUM(Orders.Quantity) AS 'QuantitySold'
FROM Tickets
INNER JOIN Orders
ON Orders.TicketID = Tickets.TicketID
WHERE Tickets.EventID = 3
GROUP BY Tickets.TicketName

/* 7. Відобразити всі події влітку 2022 р. */

SELECT * FROM Events
WHERE StartDate >= '6/1/2022' AND EndDate <= '8/31/2022'

/* 8. Відобразити всі події у Чернівцях у 2021 р. */

SELECT * 
FROM Events 
WHERE EventID IN ( 
SELECT EventID FROM Tickets WHERE LocationID IN (
SELECT LocationsID FROM Locations WHERE City = 'Chernivtsi')) 
AND EndDate < '12/31/2021'

/* 9. Відобразити всі події без вікового обмеження */

SELECT *
FROM Events
WHERE EventID IN (
SELECT EventID FROM EventTypes WHERE TypeID IN (
SELECT TypeID FROM Types WHERE AgeRestriction IS NULL))

/* 10. Пошук користувачів, чий номер телефону починається на +38050 */

SELECT UserID, FullName, PhoneNumber FROM Users
WHERE PhoneNumber LIKE '+38050%'

/* 11. Відсортувати типи квитків за спаданням кількості проданих */

SELECT Tickets.TicketName, SUM(Orders.Quantity) AS 'QuantitySold'
FROM Tickets 
INNER JOIN Orders
ON Orders.TicketID = Tickets.TicketID
GROUP BY Tickets.TicketName
ORDER BY QuantitySold desc

/* 12. Знайти загальний дохід від продажу квитків */

SELECT SUM(Amount) AS TotalRevenue
FROM Payments

/* 13. Відобразити вартість внесених передплат */

SELECT Orders.OrdersID, Amount AS Prepayment
FROM Payments
INNER JOIN Orders
ON Payments.PaymentsID = Orders.PaymentID
WHERE Orders.OrdersStatus = 'booked'

/* 14. Вивести список осіб, які внесли передплату, та відобразити суму, яку залишилось сплатити */

SELECT Orders.OrdersID, Users.UserID, Users.FullName, (Orders.Quantity * Tickets.Price) AS Cost, Payments.Amount AS Prepayment, ((Orders.Quantity * Tickets.Price) - Payments.Amount) AS LeftToPay
FROM Orders 
INNER JOIN Tickets
ON Orders.TicketID = Tickets.TicketID
INNER JOIN Payments 
ON Orders.PaymentID = Payments.PaymentsID
INNER JOIN Users
ON Orders.UserID = Users.UserID
WHERE Orders.OrdersStatus = 'booked'

/* 15. Відобразити список всіх події не у Львові */

SELECT EventID, Name
FROM Events
WHERE EventID IN (
SELECT EventID FROM Tickets WHERE LocationID IN (
SELECT LocationsID FROM Locations WHERE City <> 'Lviv'))

/* 16. Порахувати кількість користувачів за статтю */

SELECT Sex, COUNT (*) AS Users
FROM Users
WHERE RoleID IN (SELECT RolesID FROM Roles WHERE RoleName ='Користувач')
GROUP BY Sex

/* 17. Погрупувати користувачів та адміністраторів за статтю */

SELECT Users.Sex, Roles.RoleName, COUNT (*) AS Users
FROM Users
INNER JOIN Roles
ON Users.RoleID = Roles.RolesID
GROUP BY Users.Sex, Roles.RoleName
ORDER BY Users.Sex desc

/* 18. Знайти середню вартість платежів кожного користувача */

SELECT Users.FullName, AVG (Payments.Amount) AS AveragePayment
FROM Orders
INNER JOIN Payments
ON Orders.PaymentID = Payments.PaymentsID
INNER JOIN Users
ON Orders.UserID = Users.UserID
GROUP BY Users.FullName

/* 19. Знайти кількість замовлень кожного користувача */

SELECT Users.FullName, COUNT(Orders.OrdersID) AS Orders
FROM Orders
INNER JOIN Users
ON Orders.UserID = Users.UserID
GROUP BY Users.FullName

/* 20. Відобразити користувачів, що зробили не менше двох замовлень */

SELECT Users.FullName, COUNT (Orders.OrdersID) AS Orders
FROM Orders
INNER JOIN Users
ON Orders.UserID = Users.UserID
GROUP BY Users.FullName
HAVING COUNT(Orders.OrdersID) >= 2

/* 21. Відобразити назви подій, на які продано більше 4 квитків */

SELECT Events.Name, COUNT (Orders.OrdersID) AS TicketsSold
FROM Tickets
INNER JOIN Events
ON Tickets.EventID = Events.EventID
INNER JOIN Orders
ON Tickets.TicketID = Orders.TicketID
GROUP BY Events.Name
HAVING COUNT (Orders.OrdersID) > 4

/* 22. Відсортувати події за датою */

SELECT *
FROM Events
ORDER BY StartDate

/* 23. Надати статуси користувачам залежно від вартості оформлених ними замовлень */

SELECT Users.FullName,
(CASE
	WHEN SUM (Payments.Amount) >= 8000 THEN 'VIP-користувач'
	WHEN SUM (Payments.Amount) >= 5000 THEN 'Золотий користувач'
	WHEN SUM (Payments.Amount) >= 3000 THEN 'Срібний користувач'
ELSE 'Користувач'
END ) AS Status
FROM Orders
INNER JOIN Users
ON Orders.UserID = Users.UserID
INNER JOIN Payments
ON Orders.PaymentID = Payments.PaymentsID
GROUP BY Users.FullName
ORDER BY Status

/* 24. Згрупувати користувачів за віком */

SELECT FullName,
(CASE
	WHEN DATEDIFF (YY, BirthDate, GETDATE ()) < 20 THEN 'До 20-ти років'
	WHEN DATEDIFF (YY, BirthDate, GETDATE ()) < 25 THEN 'До 25-ти років'
	WHEN DATEDIFF (YY, BirthDate, GETDATE ()) < 30 THEN 'До 30-ти років'
ELSE 'Понад 30 років'
END ) AS 'Вікова категорія'
FROM Users
GROUP BY FullName, DATEDIFF (YY, BirthDate, GETDATE ())
ORDER BY DATEDIFF (YY, BirthDate, GETDATE ())

/* 25. Відобразити події, на яких більше одного учасника */

SELECT Events.Name, COUNT(ParticipantEvents.ParticipantID) AS NumberOfParticipants
FROM Events
INNER JOIN ParticipantEvents
ON Events.EventID = ParticipantEvents.EventID
GROUP BY Name
HAVING COUNT(ParticipantEvents.ParticipantID) > 1

/* 26. Відобразити користувачів, які залишили більше одного відгука */

SELECT Users.FullName, COUNT (Feedbacks.FeedbackID) AS NumberOfFeedbacks
FROM Users
INNER JOIN Feedbacks
ON Users.UserID = Feedbacks.UserID
GROUP BY Users.FullName
HAVING COUNT (Feedbacks.FeedbackID) > 1

/* 27. Відобразити локації, на яких більше трох типів квитків */

SELECT Locations.Address, COUNT (Tickets.TicketID) AS NumberOfTicketTypes
FROM Locations
INNER JOIN Tickets
ON Locations.LocationsID = Tickets.LocationID
GROUP BY Locations.Address
HAVING COUNT (Tickets.TicketID) > 2

/* 28. Порахувати кількість замовлень кожного статусу */

SELECT OrdersStatus, COUNT (OrdersStatus) AS NumberOfOrders
FROM Orders
GROUP BY OrdersStatus
ORDER BY COUNT (OrdersStatus) DESC

/* 29. Посортувати платежі за датою */

SELECT * 
FROM Payments
ORDER BY PaymentsID

/* 30. Посортувати локації за спаданням кількості місць */

SELECT LocationsID, City, Address, TotalQuantity
FROM Locations
ORDER BY TotalQuantity desc