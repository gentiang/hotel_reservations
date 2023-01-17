-- Initial Exploratory Query

DROP TABLE IF EXISTS #sum_hotels; -- code to remedy iterative problems with temporary tables

WITH hotels AS(					  -- CTE to run before the main analysis so as to combine all the yearly tables
SELECT * FROM hotel_reservations.[dbo].[2018]
UNION
SELECT * FROM hotel_reservations.[dbo].[2019]
UNION
SELECT * FROM hotel_reservations.[dbo].[2020])

SELECT							  
	hotel,
	arrival_date_year,
	ROUND(SUM((stays_in_week_nights + stays_in_weekend_nights)*adr*Discount),2) AS revenue,
	hotels.market_segment,
	Discount
INTO 
	#sum_hotels					  -- creating a temporary table so that we can use it later on for creating more variables inside of it
FROM 
	hotels
JOIN 
	hotel_reservations.[dbo].market_segment
ON
	market_segment.market_segment = hotels.market_segment
GROUP BY
	arrival_date_year, 
	hotel, 
	hotels.market_segment,
	Discount
ORDER BY
	hotel,
	arrival_date_year,
	market_segment;

SELECT 
	*, 
	ROUND(yearly_revenue_by_hotel_type/yearly_revenue,2) AS hotel_revenue_share
FROM
	(SELECT 
		*,
		SUM(revenue) OVER(PARTITION BY arrival_date_year) AS yearly_revenue,
		SUM(revenue) OVER(PARTITION BY arrival_date_year, hotel) AS yearly_revenue_by_hotel_type
	FROM 
		#sum_hotels) AS a					-- the temporary table is used as a subquery that contains window variables that will be used to calculate indicators in the main query
	ORDER BY 
		arrival_date_year,
		hotel,
		market_segment;

-- Power BI Query
WITH hotels AS(
SELECT * FROM hotel_reservations.[dbo].[2018]
UNION
SELECT * FROM hotel_reservations.[dbo].[2019]
UNION
SELECT * FROM hotel_reservations.[dbo].[2020])

SELECT * FROM hotels
JOIN hotel_reservations.[dbo].market_segment
ON market_segment.market_segment = hotels.market_segment
JOIN hotel_reservations.[dbo].meal_cost
ON meal_cost.meal = hotels.meal