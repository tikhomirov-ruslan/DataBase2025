-- 1. Write a query that displays all flights of a specific airline.
-- Запрос для отображения всех рейсов конкретной авиакомпании
-- Все рейсы авиакомпании KazAir (ID = 6)
SELECT
    f.flight_id,
    f.sch_departure_time,
    f.sch_arrival_time,
    a.airline_name
FROM Flights f
JOIN airline a ON f.airline_id = a.airline_id
WHERE a.airline_name = 'KazAir'
ORDER BY f.sch_departure_time;

-- 2.	Compose a query to obtain a list of all flights with the names of departure airports.
-- Запрос для получения списка всех рейсов с названиями аэропортов вылета
SELECT
    f.flight_id,
    f.sch_departure_time,
    f.sch_arrival_time,
    dep.airport_name AS departure_airport,
    arr.airport_name AS arrival_airport,
    a.airline_name
FROM Flights f
JOIN Airport dep ON f.departing_airport_id = dep.airport_id
JOIN Airport arr ON f.arriving_airport_id = arr.airport_id
JOIN airline a ON f.airline_id = a.airline_id
ORDER BY f.sch_departure_time;

-- 3.	Create a query that finds all airlines that have no flights scheduled for the next month.
-- Запрос для поиска всех авиакомпаний, у которых нет рейсов в следующем месяце
SELECT
    a.airline_id,
    a.airline_name,
    a.airline_country
FROM airline a
WHERE a.airline_id NOT IN (
    SELECT DISTINCT f.airline_id
    FROM Flights f
    WHERE EXTRACT(YEAR FROM f.sch_departure_time) = EXTRACT(YEAR FROM CURRENT_DATE + INTERVAL '1 month')
    AND EXTRACT(MONTH FROM f.sch_departure_time) = EXTRACT(MONTH FROM CURRENT_DATE + INTERVAL '1 month')
)
ORDER BY a.airline_name;

-- 4.	Create a query to display a list of passengers on a specific flight.
-- Запрос для отображения списка пассажиров на конкретном рейсе
-- Пассажиры на рейсе с ID = 2
SELECT
    p.passenger_id,
    p.first_name,
    p.last_name,
    p.passport_number,
    b.booking_platform,
    b.status as booking_status
FROM Booking b
JOIN Passengers p ON b.passenger_id = p.passenger_id
WHERE b.flight_id = 2
ORDER BY p.last_name, p.first_name;

-- 5.	Write a query that calculates the average, total, maximum and minimum price of tickets for each flight.
-- Запрос для расчета средней, общей, максимальной и минимальной цены билетов для каждого рейса
SELECT
    f.flight_id,
    a.airline_name,
    dep.airport_name AS departure_airport,
    arr.airport_name AS arrival_airport,
    COUNT(b.booking_id) AS tickets_sold,
    ROUND(AVG(b.ticket_price), 2) AS average_price,
    ROUND(SUM(b.ticket_price), 2) AS total_revenue,
    ROUND(MAX(b.ticket_price), 2) AS max_price,
    ROUND(MIN(b.ticket_price), 2) AS min_price
FROM Flights f
LEFT JOIN Booking b ON f.flight_id = b.flight_id
JOIN airline a ON f.airline_id = a.airline_id
JOIN Airport dep ON f.departing_airport_id = dep.airport_id
JOIN Airport arr ON f.arriving_airport_id = arr.airport_id
GROUP BY f.flight_id, a.airline_name, dep.airport_name, arr.airport_name
ORDER BY total_revenue DESC NULLS LAST;

-- 6.	Create a query that shows all flights flying to a specific country by combining flights, airports and airline, and using the condition on the country name.
-- Запрос для показа всех рейсов, летящих в конкретную страну
-- Все рейсы в Казахстан
SELECT
    f.flight_id,
    a.airline_name,
    dep.airport_name AS departure_airport,
    dep.city AS departure_city,
    arr.airport_name AS arrival_airport,
    arr.city AS arrival_city,
    f.sch_departure_time,
    f.sch_arrival_time
FROM Flights f
JOIN airline a ON f.airline_id = a.airline_id
JOIN Airport dep ON f.departing_airport_id = dep.airport_id
JOIN Airport arr ON f.arriving_airport_id = arr.airport_id
WHERE arr.country = 'Kazakhstan'
ORDER BY f.sch_departure_time;

-- 7.	Display a list of minor passengers and their arrival destination.
-- Отображение списка несовершеннолетних пассажиров и их пунктов назначения
SELECT
    p.passenger_id,
    p.first_name,
    p.last_name,
    p.date_of_birth,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, p.date_of_birth)) AS age,
    arr.airport_name AS arrival_airport,
    arr.city AS arrival_city,
    arr.country AS arrival_country,
    f.sch_arrival_time
FROM Passengers p
JOIN Booking b ON p.passenger_id = b.passenger_id
JOIN Flights f ON b.flight_id = f.flight_id
JOIN Airport arr ON f.arriving_airport_id = arr.airport_id
WHERE EXTRACT(YEAR FROM AGE(CURRENT_DATE, p.date_of_birth)) < 18
ORDER BY age, p.last_name;

-- 8.	Display the passenger’s full name, passport number, and the passenger’s current time of arrival at the destination.
-- Отображение полного имени пассажира, номера паспорта и времени прибытия
SELECT
    p.first_name || ' ' || p.last_name AS full_name,
    p.passport_number,
    f.flight_id,
    dep.airport_name AS departure_airport,
    arr.airport_name AS arrival_airport,
    f.sch_arrival_time AS scheduled_arrival,
    f.act_arrival_time AS actual_arrival,
    CASE
        WHEN f.act_arrival_time IS NOT NULL THEN f.act_arrival_time
        ELSE f.sch_arrival_time
    END AS current_arrival_time
FROM Passengers p
JOIN Booking b ON p.passenger_id = b.passenger_id
JOIN Flights f ON b.flight_id = f.flight_id
JOIN Airport dep ON f.departing_airport_id = dep.airport_id
JOIN Airport arr ON f.arriving_airport_id = arr.airport_id
WHERE b.status = 'Confirmed'
ORDER BY full_name;

-- 9.	Print a list of flights where the airline's home country and origin country are the same. Group them by the airport country.
-- Список рейсов, где страна авиакомпании и страна вылета совпадают
SELECT
    dep.country AS airport_country,
    a.airline_name,
    a.airline_country,
    COUNT(f.flight_id) AS flight_count,
    STRING_AGG(f.flight_id::text, ', ') AS flight_ids
FROM Flights f
JOIN airline a ON f.airline_id = a.airline_id
JOIN Airport dep ON f.departing_airport_id = dep.airport_id
WHERE a.airline_country = dep.country
GROUP BY dep.country, a.airline_name, a.airline_country
ORDER BY flight_count DESC, airport_country;