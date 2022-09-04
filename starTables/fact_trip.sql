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



