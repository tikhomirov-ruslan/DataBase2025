-- Создание таблицы Airline_info
CREATE TABLE Airline_info (
    airline_id INT PRIMARY KEY,
    airline_code VARCHAR(30),
    airline_name VARCHAR(50),
    airline_country VARCHAR(50),
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    info VARCHAR(50)
);

-- Создание таблицы Airport
CREATE TABLE Airport (
    airport_id INT PRIMARY KEY,
    airport_name VARCHAR(50),
    country VARCHAR(50),
    state VARCHAR(50),
    city VARCHAR(50),
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

-- Создание таблицы Passengers
CREATE TABLE Passengers (
    passenger_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    date_of_birth DATE,
    gender VARCHAR(50),
    country_of_citizenship VARCHAR(50),
    country_of_residence VARCHAR(50),
    passport_number VARCHAR(20),
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

-- Создание таблицы Flights
CREATE TABLE Flights (
    flight_id INT PRIMARY KEY,
    sch_departure_time TIMESTAMP,
    sch_arrival_time TIMESTAMP,
    departing_airport_id INT,
    arriving_airport_id INT,
    departing_gate VARCHAR(50),
    arriving_gate VARCHAR(50),
    airline_id INT,
    act_departure_time TIMESTAMP,
    act_arrival_time TIMESTAMP,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    FOREIGN KEY (departing_airport_id) REFERENCES Airport(airport_id),
    FOREIGN KEY (arriving_airport_id) REFERENCES Airport(airport_id),
    FOREIGN KEY (airline_id) REFERENCES Airline_info(airline_id)
);

-- Создание таблицы Booking
CREATE TABLE Booking (
    booking_id INT PRIMARY KEY,
    flight_id INT,
    passenger_id INT,
    booking_platform VARCHAR(50),
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    status VARCHAR(50),
    price DECIMAL(7,2),
    FOREIGN KEY (flight_id) REFERENCES Flights(flight_id),
    FOREIGN KEY (passenger_id) REFERENCES Passengers(passenger_id)
);

-- Создание таблицы Baggage
CREATE TABLE Baggage (
    baggage_id INT PRIMARY KEY,
    weight_in_kg DECIMAL(4,2),
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    booking_id INT,
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id)
);

-- Создание таблицы Boarding_pass
CREATE TABLE Boarding_pass (
    boarding_pass_id INT PRIMARY KEY,
    booking_id INT,
    seat VARCHAR(50),
    boarding_time TIMESTAMP,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id)
);

-- Создание таблицы Booking_flight
CREATE TABLE Booking_flight (
    booking_flight_id INT PRIMARY KEY,
    booking_id INT,
    flight_id INT,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id),
    FOREIGN KEY (flight_id) REFERENCES Flights(flight_id)
);

-- Создание таблицы Security_check
CREATE TABLE Security_check (
    security_check_id INT PRIMARY KEY,
    check_result VARCHAR(20),
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    passenger_id INT,
    FOREIGN KEY (passenger_id) REFERENCES Passengers(passenger_id)
);

-- Создание таблицы Baggage_check
CREATE TABLE Baggage_check (
    baggage_check_id INT PRIMARY KEY,
    check_result VARCHAR(50),
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    booking_id INT,
    passenger_id INT,
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id),
    FOREIGN KEY (passenger_id) REFERENCES Passengers(passenger_id)
);


-- Добавляем NOT NULL constraints ко всем столбцам

-- Airline_info
ALTER TABLE Airline_info
ALTER COLUMN airline_code SET NOT NULL,
ALTER COLUMN airline_name SET NOT NULL,
ALTER COLUMN airline_country SET NOT NULL,
ALTER COLUMN created_at SET NOT NULL,
ALTER COLUMN updated_at SET NOT NULL;

-- Airport
ALTER TABLE Airport
ALTER COLUMN airport_name SET NOT NULL,
ALTER COLUMN country SET NOT NULL,
ALTER COLUMN state SET NOT NULL,
ALTER COLUMN city SET NOT NULL,
ALTER COLUMN created_at SET NOT NULL,
ALTER COLUMN updated_at SET NOT NULL;

-- Passengers
ALTER TABLE Passengers
ALTER COLUMN first_name SET NOT NULL,
ALTER COLUMN last_name SET NOT NULL,
ALTER COLUMN date_of_birth SET NOT NULL,
ALTER COLUMN gender SET NOT NULL,
ALTER COLUMN country_of_citizenship SET NOT NULL,
ALTER COLUMN country_of_residence SET NOT NULL,
ALTER COLUMN passport_number SET NOT NULL,
ALTER COLUMN created_at SET NOT NULL,
ALTER COLUMN updated_at SET NOT NULL;

-- Flights
ALTER TABLE Flights
ALTER COLUMN sch_departure_time SET NOT NULL,
ALTER COLUMN sch_arrival_time SET NOT NULL,
ALTER COLUMN departing_airport_id SET NOT NULL,
ALTER COLUMN arriving_airport_id SET NOT NULL,
ALTER COLUMN departing_gate SET NOT NULL,
ALTER COLUMN arriving_gate SET NOT NULL,
ALTER COLUMN airline_id SET NOT NULL,
ALTER COLUMN created_at SET NOT NULL,
ALTER COLUMN updated_at SET NOT NULL;

-- Booking
ALTER TABLE Booking
ALTER COLUMN flight_id SET NOT NULL,
ALTER COLUMN passenger_id SET NOT NULL,
ALTER COLUMN booking_platform SET NOT NULL,
ALTER COLUMN created_at SET NOT NULL,
ALTER COLUMN updated_at SET NOT NULL,
ALTER COLUMN status SET NOT NULL,
ALTER COLUMN price SET NOT NULL;

-- Baggage
ALTER TABLE Baggage
ALTER COLUMN weight_in_kg SET NOT NULL,
ALTER COLUMN created_at SET NOT NULL,
ALTER COLUMN updated_at SET NOT NULL,
ALTER COLUMN booking_id SET NOT NULL;

-- Boarding_pass
ALTER TABLE Boarding_pass
ALTER COLUMN booking_id SET NOT NULL,
ALTER COLUMN seat SET NOT NULL,
ALTER COLUMN boarding_time SET NOT NULL,
ALTER COLUMN created_at SET NOT NULL,
ALTER COLUMN updated_at SET NOT NULL;

-- Booking_flight
ALTER TABLE Booking_flight
ALTER COLUMN booking_id SET NOT NULL,
ALTER COLUMN flight_id SET NOT NULL,
ALTER COLUMN created_at SET NOT NULL,
ALTER COLUMN updated_at SET NOT NULL;

-- Security_check
ALTER TABLE Security_check
ALTER COLUMN check_result SET NOT NULL,
ALTER COLUMN created_at SET NOT NULL,
ALTER COLUMN updated_at SET NOT NULL,
ALTER COLUMN passenger_id SET NOT NULL;

-- Baggage_check
ALTER TABLE Baggage_check
ALTER COLUMN check_result SET NOT NULL,
ALTER COLUMN created_at SET NOT NULL,
ALTER COLUMN updated_at SET NOT NULL,
ALTER COLUMN booking_id SET NOT NULL,
ALTER COLUMN passenger_id SET NOT NULL;



-- Переименовываем таблицу airline_info в airline
ALTER TABLE Airline_info RENAME TO airline;


-- Переименовываем колонку price в ticket_price
ALTER TABLE Booking RENAME COLUMN price TO ticket_price;


-- Изменяем тип данных departing_gate на TEXT
ALTER TABLE Flights
ALTER COLUMN departing_gate TYPE TEXT;


-- Удаляем колонку info из таблицы airline
ALTER TABLE airline DROP COLUMN info;



-- Проверяем структуру таблиц после всех изменений
SELECT table_name, column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_schema = 'public'
ORDER BY table_name, ordinal_position;





-- Вставка данных в таблицу airline
INSERT INTO airline (airline_id, airline_code, airline_name, airline_country, created_at, updated_at)
VALUES
(1, 'KZ', 'KazAir', 'Kazakhstan', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, 'AF', 'AirFrance', 'France', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(3, 'LH', 'Lufthansa', 'Germany', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(4, 'BA', 'BritishAirways', 'UK', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(5, 'AA', 'AmericanAirlines', 'USA', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Вставка данных в таблицу Airport (20 аэропортов)
INSERT INTO Airport (airport_id, airport_name, country, state, city, created_at, updated_at)
VALUES
(1, 'Almaty International Airport', 'Kazakhstan', 'Almaty Region', 'Almaty', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, 'Astana International Airport', 'Kazakhstan', 'Akmola Region', 'Nur-Sultan', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(3, 'Charles de Gaulle Airport', 'France', 'Île-de-France', 'Paris', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(4, 'Heathrow Airport', 'UK', 'England', 'London', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(5, 'Frankfurt Airport', 'Germany', 'Hesse', 'Frankfurt', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(6, 'John F. Kennedy Airport', 'USA', 'New York', 'New York', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(7, 'Istanbul Airport', 'Turkey', 'Istanbul', 'Istanbul', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(8, 'Dubai International Airport', 'UAE', 'Dubai', 'Dubai', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(9, 'Changi Airport', 'Singapore', 'Singapore', 'Singapore', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(10, 'Incheon International Airport', 'South Korea', 'Incheon', 'Incheon', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(11, 'Tokyo Haneda Airport', 'Japan', 'Tokyo', 'Tokyo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(12, 'Sydney Airport', 'Australia', 'NSW', 'Sydney', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(13, 'Sheremetyevo Airport', 'Russia', 'Moscow', 'Moscow', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(14, 'Beijing Capital Airport', 'China', 'Beijing', 'Beijing', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(15, 'Madrid Barajas Airport', 'Spain', 'Madrid', 'Madrid', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(16, 'Leonardo da Vinci Airport', 'Italy', 'Lazio', 'Rome', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(17, 'Schiphol Airport', 'Netherlands', 'North Holland', 'Amsterdam', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(18, 'Vancouver Airport', 'Canada', 'BC', 'Vancouver', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(19, 'Mexico City Airport', 'Mexico', 'Mexico City', 'Mexico City', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(20, 'São Paulo Airport', 'Brazil', 'São Paulo', 'São Paulo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Вставка данных в таблицу Passengers (30 пассажиров)
INSERT INTO Passengers (passenger_id, first_name, last_name, date_of_birth, gender, country_of_citizenship, country_of_residence, passport_number, created_at, updated_at)
SELECT
    i,
    'FirstName' || i,
    'LastName' || i,
    DATE '1990-01-01' + (random() * 10000)::integer * INTERVAL '1 day',
    CASE WHEN random() > 0.5 THEN 'Male' ELSE 'Female' END,
    'Country' || (1 + (random() * 10)::integer),
    'Country' || (1 + (random() * 10)::integer),
    'PASS' || (100000 + i),
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
FROM generate_series(1, 30) AS i;

-- Вставка данных в таблицу Flights (50 рейсов)
INSERT INTO Flights (flight_id, sch_departure_time, sch_arrival_time, departing_airport_id, arriving_airport_id, departing_gate, arriving_gate, airline_id, act_departure_time, act_arrival_time, created_at, updated_at)
SELECT
    i,
    CURRENT_TIMESTAMP + (random() * 30)::integer * INTERVAL '1 day',
    CURRENT_TIMESTAMP + (random() * 30 + 2)::integer * INTERVAL '1 day',
    (1 + (random() * 19)::integer),
    (1 + (random() * 19)::integer),
    'Gate' || (1 + (random() * 20)::integer),
    'Gate' || (1 + (random() * 20)::integer),
    (1 + (random() * 4)::integer),
    CURRENT_TIMESTAMP + (random() * 30)::integer * INTERVAL '1 day',
    CURRENT_TIMESTAMP + (random() * 30 + 2)::integer * INTERVAL '1 day',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
FROM generate_series(1, 50) AS i;

-- Вставка данных в таблицу Booking (50 бронирований)
INSERT INTO Booking (booking_id, flight_id, passenger_id, booking_platform, created_at, updated_at, status, ticket_price)
SELECT
    i,
    (1 + (random() * 49)::integer),
    (1 + (random() * 29)::integer),
    'Platform' || (1 + (random() * 3)::integer),
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP,
    CASE (random() * 3)::integer
        WHEN 0 THEN 'Confirmed'
        WHEN 1 THEN 'Pending'
        ELSE 'Completed'
    END,
    (100 + (random() * 1000)::numeric(7,2))
FROM generate_series(1, 50) AS i;

-- Вставка данных в таблицу Baggage (30 багажей)
INSERT INTO Baggage (baggage_id, weight_in_kg, created_at, updated_at, booking_id)
SELECT
    i,
    (10 + (random() * 30)::numeric(4,2)),
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP,
    (1 + (random() * 49)::integer)
FROM generate_series(1, 30) AS i;

-- Вставка данных в таблицу Boarding_pass (40 посадочных талонов)
INSERT INTO Boarding_pass (boarding_pass_id, booking_id, seat, boarding_time, created_at, updated_at)
SELECT
    i,
    (1 + (random() * 49)::integer),
    (10 + (random() * 30)::integer) || chr(65 + (random() * 6)::integer),
    CURRENT_TIMESTAMP + (random() * 30)::integer * INTERVAL '1 hour',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
FROM generate_series(1, 40) AS i;

-- Вставка данных в таблицу Booking_flight (40 связей)
INSERT INTO Booking_flight (booking_flight_id, booking_id, flight_id, created_at, updated_at)
SELECT
    i,
    (1 + (random() * 49)::integer),
    (1 + (random() * 49)::integer),
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
FROM generate_series(1, 40) AS i;

-- Вставка данных в таблицу Security_check (30 проверок)
INSERT INTO Security_check (security_check_id, check_result, created_at, updated_at, passenger_id)
SELECT
    i,
    CASE WHEN random() > 0.2 THEN 'Passed' ELSE 'Failed' END,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP,
    (1 + (random() * 29)::integer)
FROM generate_series(1, 30) AS i;

-- Вставка данных в таблицу Baggage_check (25 проверок багажа)
INSERT INTO Baggage_check (baggage_check_id, check_result, created_at, updated_at, booking_id, passenger_id)
SELECT
    i,
    CASE WHEN random() > 0.3 THEN 'Approved' ELSE 'Rejected' END,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP,
    (1 + (random() * 49)::integer),
    (1 + (random() * 29)::integer)
FROM generate_series(1, 25) AS i;




-- Добавляем новую авиакомпанию KazAir
INSERT INTO airline (airline_id, airline_code, airline_name, airline_country, created_at, updated_at)
VALUES (6, 'KZR', 'KazAir', 'Kazakhstan', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);


-- Обновляем страну KazAir на Turkey
UPDATE airline
SET airline_country = 'Turkey', updated_at = CURRENT_TIMESTAMP
WHERE airline_name = 'KazAir';


-- Добавляем три авиакомпании одной командой
INSERT INTO airline (airline_id, airline_code, airline_name, airline_country, created_at, updated_at)
VALUES
(7, 'AE', 'AirEasy', 'France', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(8, 'FH', 'FlyHigh', 'Brazil', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(9, 'FF', 'FlyFly', 'Poland', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);


-- Удаляем рейсы с прибытием в 2024 году
DELETE FROM Flights
WHERE EXTRACT(YEAR FROM sch_arrival_time) = 2024
   OR EXTRACT(YEAR FROM act_arrival_time) = 2024;


-- Увеличиваем цену билетов на 15%
UPDATE Booking
SET ticket_price = ticket_price * 1.15,
    updated_at = CURRENT_TIMESTAMP;


-- Удаляем билеты с ценой менее 10000
DELETE FROM Booking
WHERE ticket_price < 10000;


-- Проверяем авиакомпании
SELECT * FROM airline ORDER BY airline_id;

-- Проверяем обновленные цены билетов
SELECT booking_id, ticket_price FROM Booking ORDER BY ticket_price DESC;

-- Проверяем количество записей в основных таблицах
SELECT
    'airline' as table_name, COUNT(*) as count FROM airline
UNION ALL
SELECT 'airport', COUNT(*) FROM Airport
UNION ALL
SELECT 'passengers', COUNT(*) FROM Passengers
UNION ALL
SELECT 'flights', COUNT(*) FROM Flights
UNION ALL
SELECT 'booking', COUNT(*) FROM Booking
UNION ALL
SELECT 'baggage', COUNT(*) FROM Baggage
UNION ALL
SELECT 'boarding_pass', COUNT(*) FROM Boarding_pass
UNION ALL
SELECT 'booking_flight', COUNT(*) FROM Booking_flight
UNION ALL
SELECT 'security_check', COUNT(*) FROM Security_check
UNION ALL
SELECT 'baggage_check', COUNT(*) FROM Baggage_check;