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
