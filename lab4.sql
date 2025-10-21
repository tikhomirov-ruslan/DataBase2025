-- 1.	Retrieve all airline names in uppercase.
-- Получить все названия авиакомпаний в верхнем регистре
SELECT UPPER(airline_name) AS airline_name_uppercase
FROM airline;

-- 2. Replace any occurrence of the word "Air" in airline names with "Aero".
-- Заменить все вхождения слова "Air" в названиях авиакомпаний на "Aero"
SELECT
    airline_name,
    REPLACE(airline_name, 'Air', 'Aero') AS modified_airline_name
FROM airline;

-- 3. Fing all flight numbers that coordinates with both airline 1 and airline 2.
--  Найти все номера рейсов, которые связаны с авиакомпаниями 1 и 2
SELECT DISTINCT f.flight_id
FROM Flights f
WHERE f.airline_id IN (1, 2)
ORDER BY f.flight_id;

-- 4. Retrieve airports that contain the word "Reginal" and "Air" in their names.
-- Получить аэропорты, которые содержат слова "Regional" и "Air" в своих названиях
SELECT *
FROM Airport
WHERE airport_name LIKE '%Regional%'
   OR airport_name LIKE '%Air%';

-- 5. Retrieve passenger names and format their birth dates as 'Month DD, YYYY'..o
-- Получить имена пассажиров и отформатировать их даты рождения как 'Month DD, YYYY'
SELECT
    first_name,
    last_name,
    TO_CHAR(date_of_birth, 'Month DD, YYYY') AS formatted_birth_date
FROM Passengers;

-- 6. Find flight numbers that have been delayed based on the actual arrival time.
-- Найти номера рейсов, которые задержаны на основе фактического времени прибытия
SELECT
    flight_id,
    sch_arrival_time,
    act_arrival_time,
    (act_arrival_time - sch_arrival_time) AS delay_time
FROM Flights
WHERE act_arrival_time > sch_arrival_time
ORDER BY delay_time DESC;

-- 7. Create a query that divides passengers into age groups like ‘Young’ and ‘Adult’ based on their birth date. Young passengers age between 18 and 35, Adult passengers age between 36 and 55.
-- Создать запрос, который делит пассажиров на возрастные группы 'Young' и 'Adult'
SELECT
    first_name,
    last_name,
    date_of_birth,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, date_of_birth)) AS age,
    CASE
        WHEN EXTRACT(YEAR FROM AGE(CURRENT_DATE, date_of_birth)) BETWEEN 18 AND 35 THEN 'Young'
        WHEN EXTRACT(YEAR FROM AGE(CURRENT_DATE, date_of_birth)) BETWEEN 36 AND 55 THEN 'Adult'
        ELSE 'Other'
    END AS age_group
FROM Passengers
WHERE EXTRACT(YEAR FROM AGE(CURRENT_DATE, date_of_birth)) BETWEEN 18 AND 55
ORDER BY age;

-- 8. Create a query that categorizes ticket prices based on their price as "Cheap," "Medium" or "Expensive."
-- Создать запрос, который категоризирует цены на билеты как "Cheap", "Medium" или "Expensive"
SELECT
    booking_id,
    ticket_price,
    CASE
        WHEN ticket_price < 500 THEN 'Cheap'
        WHEN ticket_price BETWEEN 500 AND 1500 THEN 'Medium'
        ELSE 'Expensive'
    END AS price_category
FROM Booking
ORDER BY ticket_price;

-- 9. Find number of airline names in each airline country.
-- Найти количество названий авиакомпаний в каждой стране
SELECT
    airline_country,
    COUNT(airline_name) AS airline_count
FROM airline
GROUP BY airline_country
ORDER BY airline_count DESC;

-- 10. Find flights that arrived late according to their actual arrival time compared to the scheduled arrival time.
-- Найти рейсы, которые прибыли с опозданием согласно фактическому времени прибытия
SELECT
    flight_id,
    sch_arrival_time,
    act_arrival_time,
    (act_arrival_time - sch_arrival_time) AS delay_duration
FROM Flights
WHERE act_arrival_time > sch_arrival_time
ORDER BY delay_duration DESC;
