-- 1. A passenger cancels their booking. You need to remove the booking for the flight. Ensure the ‘booking’ table no longer contains the booking. Simulate an error to test rollback (for example, invalid booking_id).
-- Пассажир отменяет бронирование + тестирование отката

BEGIN;

DELETE FROM Booking
WHERE booking_id = 1;

SELECT * FROM Booking WHERE booking_id = 1;

COMMIT;

-- Отмена с неверным booking_id
BEGIN;

DELETE FROM Booking
WHERE booking_id = 9999; -- Неверный ID

-- откатываем
ROLLBACK;

-- Проверяем, что откат сработал (данные не изменились)
SELECT COUNT(*) FROM Booking WHERE booking_id = 1;


-- 2. Rescheduling a flight. You need to reschedule a flight. Verify the ‘flights’ table reflects the new departure time. Simulate an error to test rollback (for example, invalid flight_id).
-- Перенос рейса + тестирование отката

-- обновление времени рейса
BEGIN;

UPDATE Flights
SET
    sch_departure_time = sch_departure_time + INTERVAL '2 hours',
    sch_arrival_time = sch_arrival_time + INTERVAL '2 hours',
    updated_at = CURRENT_TIMESTAMP
WHERE flight_id = 1;

SELECT flight_id, sch_departure_time, sch_arrival_time
FROM Flights
WHERE flight_id = 1;

COMMIT;

-- отмена с неверным flight_id
BEGIN;

UPDATE Flights
SET
    sch_departure_time = sch_departure_time + INTERVAL '2 hours'
WHERE flight_id = 9999; -- Неверный ID

ROLLBACK;

SELECT flight_id, sch_departure_time
FROM Flights
WHERE flight_id = 1;


-- 3.	Updating ticket prices. You need to decrease the ticket price for a specific flight for all existing bookings. If an error occurs, no changes should be applied.
-- Обновление цен на билеты с гарантией отката при ошибке

-- Уменьшение цены билетов для конкретного рейса
BEGIN;

UPDATE Booking
SET
    ticket_price = ticket_price * 0.9, -- 10% скидка
    updated_at = CURRENT_TIMESTAMP
WHERE flight_id = 1;

SELECT booking_id, ticket_price
FROM Booking
WHERE flight_id = 1;

COMMIT;

-- 4.	A passenger updates their details. Ensure the update is reflected across all associated records, including bookings.
-- Обновление данных пассажира во всех связанных записях

BEGIN;

-- Обновляем данные пассажира
UPDATE Passengers
SET
    first_name = 'UpdatedFirstName',
    last_name = 'UpdatedLastName',
    passport_number = 'NEWPASS123',
    updated_at = CURRENT_TIMESTAMP
WHERE passenger_id = 1;

SELECT * FROM Passengers WHERE passenger_id = 1;

SELECT
    p.passenger_id,
    p.first_name,
    p.last_name,
    p.passport_number,
    b.booking_id
FROM Passengers p
JOIN Booking b ON p.passenger_id = b.passenger_id
WHERE p.passenger_id = 1;

COMMIT;

-- 5.	A new passenger is registered, and a booking is created. Ensure the new passenger is added and the booking succeeds.
-- Регистрация нового пассажира и создание бронирования

BEGIN;

-- Добавляем нового пассажира
INSERT INTO Passengers (
    passenger_id, first_name, last_name, date_of_birth, gender,
    country_of_citizenship, country_of_residence, passport_number,
    created_at, updated_at
) VALUES (
    1003, 'New', 'Passenger', '1995-03-15', 'Male',
    'Kazakhstan', 'Kazakhstan', 'KZ987654321',
    CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
);

-- Создаем бронирование для нового пассажира
INSERT INTO Booking (
    booking_id, flight_id, passenger_id, booking_platform,
    created_at, updated_at, status, ticket_price
) VALUES (
    1008, 1, 1003, 'Website',
    CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Confirmed', 350.00
);

SELECT
    p.passenger_id,
    p.first_name,
    p.last_name,
    b.booking_id,
    b.status,
    b.ticket_price
FROM Passengers p
JOIN Booking b ON p.passenger_id = b.passenger_id
WHERE p.passenger_id = 1003;

COMMIT;

-- 6.	Increase the ticket price for all bookings on a specific flight by a fixed amount.
-- Увеличение цены билетов для всех бронирований конкретного рейса

BEGIN;

-- Увеличиваем цену на фиксированную сумму
UPDATE Booking
SET
    ticket_price = ticket_price + 50.00, -- Увеличиваем на 50
    updated_at = CURRENT_TIMESTAMP
WHERE flight_id = 1;

-- Проверяем обновленные цены
SELECT
    booking_id,
    flight_id,
    ticket_price,
    (ticket_price - 50.00) AS old_price
FROM Booking
WHERE flight_id = 1;

COMMIT;

-- 7.	Update a baggage weight. A passenger updates the declared weight of their baggage. Ensure that the change is correctly reflected in the database.
-- Обновление веса багажа

BEGIN;

-- Обновляем вес багажа
UPDATE Baggage
SET
    weight_in_kg = 20.50, -- Новый вес
    updated_at = CURRENT_TIMESTAMP
WHERE baggage_id = 1;

SELECT
    baggage_id,
    weight_in_kg,
    booking_id
FROM Baggage
WHERE baggage_id = 1;

COMMIT;

-- 8.	Apply a discount to a booking for a specific passenger. If any error occurs, roll back.
-- Применение скидки к бронированию с откатом при ошибке

-- Применяем скидку 15% к конкретному бронированию
BEGIN;

UPDATE Booking
SET
    ticket_price = ticket_price * 0.85, -- 15% скидка
    updated_at = CURRENT_TIMESTAMP
WHERE booking_id = 2 AND passenger_id = 1;

SELECT
    booking_id,
    passenger_id,
    ticket_price,
    (ticket_price / 0.85) AS original_price
FROM Booking
WHERE booking_id = 2 AND passenger_id = 1;

COMMIT;

-- 9.	Reschedule all bookings for a flight to a new flight.
-- Перенос всех бронирований с одного рейса на другой

BEGIN;

-- Переносим все бронирования с рейса 1 на рейс 2
UPDATE Booking
SET
    flight_id = 2, -- Новый рейс
    updated_at = CURRENT_TIMESTAMP
WHERE flight_id = 1;

SELECT
    booking_id,
    flight_id,
    passenger_id
FROM Booking
WHERE flight_id = 2;

-- Проверяем, что на старом рейсе не осталось бронирований
SELECT COUNT(*) AS remaining_bookings
FROM Booking
WHERE flight_id = 1;

COMMIT;