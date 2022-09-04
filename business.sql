-- 1. Analyze how much time is spent per ride

-- - Based on date and time factors such as day of week and time of day
select duration 

from fact_trip
join dim_time on fact_trip.time_id = dim_time.time_id

where dim_time._month = "1"


-- - Based on which station is the starting and / or ending station
select duration 

from fact_trip
join dim_station on dim_station.station_id = fact_trip.station_id

where dim_station._name = "stationname"


-- - Based on age of the rider at time of the ride
select duration 

from fact_trip
join dim_rider on dim_rider.rider_id = fact_trip.rider_id

where dim_rider.rider_age = 23


-- - Based on whether the rider is a member or a casual rider
select duration 

from fact_trip
join dim_rider on dim_rider.rider_id = fact_trip.rider_id

where dim_rider.is_member = TRUE


-- 2. Analyze how much money is spent
-- - Per month, quarter, year
select amount 

from fact_payment
join dim_time on fact_payment.time_id = dim_time.time_id

where dim_time._month = "1"


-- - Per member, based on the age of the rider at account start
select amount 

from fact_payment
join dim_rider on fact_payment.rider_id = fact_trip.rider_id

where dim_rider.rider_age = 23


-- 3. Analyze how much money is spent per member
-- - Based on how many rides the rider averages per month
select amount 

from fact_payment
join dim_rider on fact_payment.rider_id = fact_trip.rider_id
join fact_trip on fact_trip.rider_id = dim_rider.rider_id

where dim_rider.rider_id = "123"


-- - Based on how many minutes the rider spends on a bike per month