--############################################################################
-- Create Rider table
CREATE TABLE dim_rider (
    rider_id INTEGER PRIMARY KEY, 
    firstName VARCHAR(50), 
    lastName VARCHAR(50), 
    _address VARCHAR(100), 
    birthday DATE, 
    account_start_date DATE, 
    account_end_date DATE, 
    is_member BOOLEAN
);
--############################################################################


--############################################################################
--Create Station table
CREATE TABLE dim_station (
    station_id VARCHAR(50) PRIMARY KEY, 
    _name VARCHAR(75), 
    latitude FLOAT, 
    longitude FLOAT
);
--############################################################################


--############################################################################
--Create time table
CREATE TABLE dim_time (
    time_id INTEGER PRIMARY KEY, 
    _date TIMESTAMP, 
    _month TEXT,
    _quarter TEXT,
    _year TEXT
);

--Create dim_time table
SELECT 
    _date,
    MONTH(_date) AS _month,
    YEAR(_date) AS _year
FROM payment

UNION 

SELECT 
    start_at,
    MONTH(start_at) AS _month,
    YEAR(start_at) AS _year
FROM trip

UNION 

SELECT 
    ended_at,
    MONTH(ended_at) AS _month,
    YEAR(ended_at) AS _year
FROM trip 
--############################################################################


--############################################################################
--Create fact_trip table
CREATE TABLE fact_trip (
    trip_id VARCHAR(50) PRIMARY KEY,
    rider_id INTEGER,
    start_station_id VARCHAR(50) FOREIGN KEY (dim_station.station_id), 
    end_station_id VARCHAR(50), 
    rideable_type VARCHAR(75),
    duration VARCHAR(75),
    rider_age VARCHAR(75),
);

SELECT 
    trip.trip_id,
    rider.rider_id,
    trip.start_station_id, 
    trip.end_station_id, 
    start_time.time_id              AS start_time_id,
    end_time.time_id                AS end_time_id,
    trip.rideable_type,
    trip.ended_at - trip.start_at   AS duration,
    trip.start_at - rider.birthday  AS rider_age

FROM trip
JOIN rider                      ON rider.rider_id = trip.rider_id
JOIN dim_time AS start_time     ON dim_time._date = trip.start_at
JOIN dim_time AS end_time       ON dim_time._date = trip.ended_at
--############################################################################


--############################################################################
--Create dim_payment table
CREATE TABLE dim_payment (
    payment_id VARCHAR(50) PRIMARY KEY, 
    _name VARCHAR(75), 
    latitude FLOAT, 
    longitude FLOAT
);

SELECT 
    payment.amount,
    payment.rider_id,
    dim_time.time_id AS time_id

FROM payment
JOIN dim_time ON dim_time._date = payment._date
--############################################################################

