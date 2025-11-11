-- 1.	Create an index on the actual_departure column in the flights table.
-- Создание индекса на столбец actual_departure в таблице flights

SELECT column_name
FROM information_schema.columns
WHERE table_name = 'flights' AND table_schema = 'public';

-- Создаем индекс (правильное название столбца)
CREATE INDEX idx_flights_act_departure
ON Flights (act_departure_time);

-- проверка
SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'flights'
AND indexname = 'idx_flights_act_departure';

-- 2.	Create a unique index to ensure flight_no and scheduled_departure combinations are unique.
-- Создание уникального индекса для комбинации flight_no и scheduled_departure

ALTER TABLE Flights ADD COLUMN IF NOT EXISTS flight_no VARCHAR(20);

UPDATE Flights SET flight_no = 'FL' || flight_id WHERE flight_no IS NULL;

-- уникальный индекс
CREATE UNIQUE INDEX idx_unique_flight_departure
ON Flights (flight_no, sch_departure_time);

-- Проверка
SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'flights'
AND indexname = 'idx_unique_flight_departure';

-- 3.	Create a composite index on the departure_airport_id and arrival_airport_id columns.
-- Создание составного индекса на столбцы departure_airport_id и arrival_airport_id

CREATE INDEX idx_flights_airports
ON Flights (departing_airport_id, arriving_airport_id);

-- Проверка
SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'flights'
AND indexname = 'idx_flights_airports';


-- 4.	Evaluate the difference in query performance with and without indexes. Measure performance differences.
-- Оценка разницы в производительности запросов с индексами и без

DROP INDEX IF EXISTS idx_flights_airports;

-- Запрос без индекса
EXPLAIN ANALYZE
SELECT * FROM Flights
WHERE departing_airport_id = 1 AND arriving_airport_id = 2;

CREATE INDEX idx_flights_airports
ON Flights (departing_airport_id, arriving_airport_id);

-- Запрос с индексом
EXPLAIN ANALYZE
SELECT * FROM Flights
WHERE departing_airport_id = 1 AND arriving_airport_id = 2;


-- 5.	Use EXPLAIN ANALYZE to check index usage in a query filtering by departure_airport and arrival_airport.
-- Использование EXPLAIN ANALYZE для проверки использования индекса

-- Проверяем использование индекса для запроса с фильтрацией по аэропортам
EXPLAIN ANALYZE
SELECT
    f.flight_id,
    f.sch_departure_time,
    dep.airport_name AS departure_airport,
    arr.airport_name AS arrival_airport
FROM Flights f
JOIN Airport dep ON f.departing_airport_id = dep.airport_id
JOIN Airport arr ON f.arriving_airport_id = arr.airport_id
WHERE f.departing_airport_id = 1
    AND f.arriving_airport_id = 2
ORDER BY f.sch_departure_time;


-- 6.	Create a unique index for the passport_number of the Passengers table. Check if the index was created or not. Insert into the table two new passengers.
--         Explain in your own words what is going on in the output?
 -- Создание уникального индекса для passport_number и вставка новых пассажиров

CREATE UNIQUE INDEX idx_unique_passport
ON Passengers (passport_number);

-- Проверка
SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'passengers'
AND indexname = 'idx_unique_passport';

-- Пытаемся вставить двух новых пассажиров
-- Первый пассажир - должен быть успешно добавлен
INSERT INTO Passengers (
    passenger_id, first_name, last_name, date_of_birth, gender,
    country_of_citizenship, country_of_residence, passport_number,
    created_at, updated_at
) VALUES (
    1001, 'John', 'Smith', '1990-05-15', 'Male',
    'USA', 'USA', 'US123456789',
    CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
);

-- Второй пассажир - ДОЛЖЕН ВЫЗВАТЬ ОШИБКУ из-за дублирующегося passport_number
INSERT INTO Passengers (
    passenger_id, first_name, last_name, date_of_birth, gender,
    country_of_citizenship, country_of_residence, passport_number,
    created_at, updated_at
) VALUES (
    1002, 'Jane', 'Doe', '1992-08-20', 'Female',
    'Canada', 'Canada', 'US123456789', -- Тот же номер паспорта!
    CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
);

-- Первая вставка завершится успешно, так как номер паспорта уникален
-- Вторая вставка вызовет ошибку нарушения уникального ограничения, потому что номер паспорта 'US123456789' уже существует
-- Это демонстрирует, что уникальный индекс предотвращает дублирование данных в столбце passport_number



-- 7.	Create an index for the Passengers table. Use for that first name, last name, date of birth and country of citizenship. Then, write a SQL query to find a passenger who was born in Philippines and was born in 1984 and check if the query uses indexes or not. Give the explanation of the results.
--
-- Создание составного индекса для Passengers и проверка его использования

-- составной индекс
CREATE INDEX idx_passengers_search
ON Passengers (first_name, last_name, date_of_birth, country_of_citizenship);

-- Проверка
SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'passengers'
AND indexname = 'idx_passengers_search';

-- Запрос для поиска пассажира из Филиппин, родившегося в 1984
EXPLAIN ANALYZE
SELECT
    passenger_id,
    first_name,
    last_name,
    date_of_birth,
    country_of_citizenship
FROM Passengers
WHERE country_of_citizenship = 'Philippines'
    AND EXTRACT(YEAR FROM date_of_birth) = 1984;



-- 8.	Write a SQL query to list indexes for table Passengers. After delete the created indexes.
-- Просмотр индексов таблицы Passengers и их удаление

-- Список всех индексов для таблицы Passengers
SELECT
    indexname,
    indexdef,
    indisunique as is_unique
FROM pg_indexes
WHERE tablename = 'passengers'
ORDER BY indexname;

-- Альтернативный способ просмотра индексов
SELECT
    i.relname as index_name,
    am.amname as index_type,
    idx.indisunique as is_unique,
    idx.indisprimary as is_primary
FROM pg_index idx
JOIN pg_class i ON i.oid = idx.indexrelid
JOIN pg_class t ON t.oid = idx.indrelid
JOIN pg_am am ON i.relam = am.oid
WHERE t.relname = 'passengers';

DROP INDEX IF EXISTS idx_unique_passport;
DROP INDEX IF EXISTS idx_passengers_search;

-- Проверка
SELECT indexname
FROM pg_indexes
WHERE tablename = 'passengers';