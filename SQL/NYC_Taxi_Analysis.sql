CREATE DATABASE nyc;

USE nyc;

CREATE TABLE nyc_taxi_clean (
    VendorID INT,
    tpep_pickup_datetime TEXT,
    tpep_dropoff_datetime TEXT,
    passenger_count DOUBLE,
    trip_distance DOUBLE,
    RatecodeID DOUBLE,
    store_and_fwd_flag TEXT,
    PULocationID INT,
    DOLocationID INT,
    payment_type INT,
    fare_amount DOUBLE,
    extra DOUBLE,
    mta_tax DOUBLE,
    tip_amount DOUBLE,
    tolls_amount DOUBLE,
    improvement_surcharge DOUBLE,
    total_amount DOUBLE,
    congestion_surcharge DOUBLE,
    Airport_fee DOUBLE,
    cbd_congestion_fee DOUBLE,
    trip_duration_minutes DOUBLE,
    pickup_date TEXT,
    pickup_month TEXT,
    pickup_day TEXT,
    pickup_hour INT,
    pickup_weekday INT,
    payment_name TEXT,
    trip_type TEXT,
    avg_speed DOUBLE,
    speed_category TEXT
);

SET GLOBAL max_allowed_packet = 1073741824;  -- 1GB
SET GLOBAL net_read_timeout = 600;
SET GLOBAL net_write_timeout = 600;

SET GLOBAL local_infile = 1;

SHOW VARIABLES LIKE 'local_infile';

ALTER TABLE nyc_taxi_clean RENAME TO nyc_taxi;

LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/nyc_taxi_clean.csv'
INTO TABLE nyc_taxi
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from nyc_taxi
limit 2;

alter table nyc_taxi 
modify tpep_pickup_datetime DATETIME;

alter table nyc_taxi 
modify tpep_dropoff_datetime DATETIME;

create index idx_datetime on nyc_taxi(tpep_pickup_datetime);

create index idx_payment on nyc_taxi(payment_type);

create index idx_location on nyc_taxi(pulocationid, dolocationid);

-- 1.  What is the total revenue generated from all taxi trips?
select sum(total_amount) as total_revenue 
from nyc_taxi;

-- 2.  Which month generated the highest revenue?
select 
    month(tpep_pickup_datetime) AS month_no,
    monthname(tpep_pickup_datetime) AS month,
    sum(total_amount) AS revenue
from nyc_taxi
group by month_no, month
order by revenue desc
limit 1;

-- 3. Which day of the week generates the most revenue?
 select dayname (tpep_pickup_datetime) as day, 
	sum(total_amount) as revenue 
from nyc_taxi 
group by  dayname (tpep_pickup_datetime), dayofweek(tpep_pickup_datetime) 
order by revenue desc 
limit 1;


-- 4. During which hour does the taxi business earn the most revenue?
 select hour(tpep_pickup_datetime) as pickup_hour, 
	sum(total_amount) as revenue 
from nyc_taxi 
group by hour(tpep_pickup_datetime) 
order by revenue desc 
limit 1;


-- 5. What is the average fare charged per trip?
select avg(fare_amount) as avg_fare_amt 
from nyc_taxi;


-- 6. Which payment method is preferred by customers?
select payment_name, count(*) as trip 
from nyc_taxi 
group by payment_name
order by trip desc ;

-- 7. Which payment method contributes the most revenue?
select payment_type,
	sum(total_amount) as revenue 
from nyc_taxi 
group by payment_type 
order by revenue desc ;

-- 8. Which payment method results in the highest average tips?
 select payment_type,
	avg(tip_amount) as avg_tip 
from nyc_taxi 
group by payment_type 
order by avg_tip desc;

-- 9. How many passengers travel per trip on average?
select avg(passenger_count) as avg_passenger 
from nyc_taxi;


-- 10. What is the most common number of passengers per trip?
select passenger_count,
	count(*) as trip 
from nyc_taxi 
group by passenger_count 
order by trip desc
limit 1;

-- 11. How long does an average taxi trip last?
select avg(trip_duration_minutes) as avg_trip_duration 
from nyc_taxi;

-- 12.What is the average distance traveled per trip?
select avg(trip_distance) as avg_trip_distance from nyc_taxi;

-- 13. Which trips took unusually long and may indicate traffic or delays?
select * from nyc_taxi 
where trip_duration_minutes > 60
limit 100;

-- 14. Which trips were long-distance journeys?
select * from nyc_taxi 
where trip_distance > 20
limit 100;

-- 15. How does the average taxi speed change across different months?
 select month(tpep_pickup_datetime) as month, 
	avg(trip_distance / (trip_duration_minutes/60)) as avg_speed 
from nyc_taxi 
where trip_duration_minutes>0 
group by month(tpep_pickup_datetime);

-- 16. Which pickup hours have the highest demand?
 select hour(tpep_pickup_datetime) as pickup_hour,
	count(*) as total_trip 
from nyc_taxi 
group by hour(tpep_pickup_datetime) 
order by total_trip 
desc limit 5;

-- 17.Which weekday earns the most revenue?
 select dayname(tpep_pickup_datetime) as weekday, 
	sum(total_amount) as revenue 
from nyc_taxi 
group by dayname(tpep_pickup_datetime), dayofweek(tpep_pickup_datetime)
order by revenue desc;


-- 18.Which pickup locations generate the highest revenue?
select PULocationID,sum(total_amount) as revenue
from nyc_taxi 
group by PULocationID 
order by revenue 
desc limit 10;


-- 19.Which drop-off locations receive the most trips?
select DOLocationID,count(*) total_trip 
from nyc_taxi 
group by DOLocationID 
order by total_trip 
desc limit 10;


-- 20.Which vendor completed the most trips?
select VendorID,count(*) as total_trip 
from nyc_taxi 
group by VendorID 
order by total_trip desc;


-- 21.Which payment method generates the most revenue?
select payment_type, sum(total_amount) as revenue from nyc_taxi group by payment_type order by revenue desc;


-- 22. Which customers (by payment type) tip the most?
select payment_type,avg(tip_amount) as avg_tip 
from nyc_taxi 
group by payment_type 
order by avg_tip desc ;


-- 23.Which trips had the longest duration?
 with trip_rank as
		(select  *, rank() over(order by trip_duration_minutes desc) as rnk 
        from nyc_taxi ) 
select * from trip_rank where rnk<=10;

-- 24.Which dates generated the highest revenue?
 with daily_revenue as 
	(select date(tpep_pickup_datetime) as trip_date, 
		sum(total_amount) as revenue 
	from nyc_taxi  
    group by date(tpep_pickup_datetime) ) 
select *, dense_rank() over(order by revenue desc) rnk 
from daily_revenue  
where rnk <= 5;

-- 25.How is revenue growing month by month over time?
 with monthly_revenue as
	( select month(tpep_pickup_datetime) month_no, 
		monthname(tpep_pickup_datetime) month_name, 
		sum(total_amount) as revenue 
    from nyc_taxi 
    group by month(tpep_pickup_datetime),
    monthname(tpep_pickup_datetime)) 
select month_name,revenue, 
	sum(revenue) over(order by month_no) running_revenue 
from monthly_revenue;

-- 26.What percentage of total revenue comes from each payment method?
select payment_name,sum(total_amount) as revenue, 
	round(sum(total_amount)*100/sum(sum(total_amount))over(),2) contribution_percent 
from nyc_taxi 
group by payment_type;


-- 27. Which 10 individual taxi trips generated the highest revenue?
select *from  nyc_taxi 
order by total_amount 
desc limit 10;


-- 28.Which taxi vendor has the longest average trip duration?
select VendorID,avg(trip_duration_minutes) as avg_duration 
from nyc_taxi 
group by VendorID
order by avg_duration desc;


-- 29.Compare each month's revenue with the previous month's revenue.
with monthly as (
  select 
    month(tpep_pickup_datetime) as month_no,
    monthname(tpep_pickup_datetime) as month_name,
    sum(total_amount) as revenue
  from nyc_taxi
  group by month_no, month_name
)
select 
  month_name,
  revenue,
  lag(revenue) over (order by month_no) as previous_month_revenue
from monthly;


-- 30. What is the average tip percentage paid by customers for each payment method?
select payment_type, 
	avg((tip_amount/fare_amount)*100) as avg_tip_percentage 
from nyc_taxi 
where fare_amount>0 
group by payment_type;



