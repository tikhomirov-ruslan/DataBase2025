-- 1.	Select all the data of passengers whose last name is same as first name.
SELECT * FROM Passengers
WHERE first_name = last_name;

-- 2.	Select the last name of all passangers without duplicates.
SELECT DISTINCT last_name FROM Passengers
ORDER BY last_name;

-- 3.	Find all male passengers born between 1990 and 2000.
SELECT * FROM Passengers
WHERE gender = 'Male' AND date_of_birth BETWEEN '1990-01-01' AND '2000-12-31';

-- 4.	Find price of tickets sold for each month in sorted way.
SELECT
    EXTRACT(YEAR FROM created_at) AS year,
    EXTRACT(MONTH FROM created_at) AS month,
    SUM(ticket_price) AS total_revenue
FROM Booking
GROUP BY year, month
ORDER BY year, month;

-- 5.	Create a query that shows all flights flying to ‘China’.
SELECT f.* FROM Flights f
JOIN Airport a ON f.arriving_airport_id = a.airport_id
WHERE a.country = 'China';

-- 6.	Show airlines from any of: ('France','Portugal','Poland') created between '2023-11-01' and '2024-03-31'.
SELECT * FROM airline
WHERE airline_country IN ('France','Portugal','Poland')
  AND created_at BETWEEN '2023-11-01' AND '2024-03-31';

-- 7.	Find all airline names based in Kazakhstan.
SELECT airline_name FROM airline
WHERE airline_country = 'Kazakhstan';

-- 8.	Reduce the cost of booking price by 10% created before ’11-01-2023’.
UPDATE Booking
SET ticket_price = ticket_price * 0.9,
    updated_at = CURRENT_TIMESTAMP
WHERE created_at < '2023-11-01';

-- 9.	Find top3 overweighted baggage with more than 25kg.
SELECT * FROM Baggage
WHERE weight_in_kg > 25
ORDER BY weight_in_kg DESC LIMIT 3;

-- 10.	Find the youngest passengers’ full name.
SELECT first_name, last_name, date_of_birth FROM Passengers
ORDER BY date_of_birth DESC LIMIT 1;

-- 11.	Find the cheapest booking price on each booking platform.
SELECT
    booking_platform,
    MIN(ticket_price) AS cheapest_price
FROM Booking
GROUP BY booking_platform
ORDER BY cheapest_price;

-- 12.	Return airlines whose airline_code contains a digit.
SELECT * FROM airline
WHERE airline_code ~ '[0-9]';

-- 13.	List the top5 most recently created airlines.
SELECT * FROM airline
ORDER BY created_at DESC
LIMIT 5;

-- 14.	Return all rows where booking_id is between 200 and 300 inclusive and check_result <> 'Checked'.
SELECT * FROM Baggage_check
WHERE booking_id BETWEEN 200 AND 300
  AND check_result <> 'Checked';

-- 15.	Baggage checks where update_at is in the same month as created_at but occurs earlier than created_at.
SELECT * FROM Baggage_check
WHERE EXTRACT(MONTH FROM updated_at) = EXTRACT(MONTH FROM created_at)
  AND EXTRACT(YEAR FROM updated_at) = EXTRACT(YEAR FROM created_at)
  AND updated_at < created_at;