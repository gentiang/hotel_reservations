-- Initial Exploratory Analysis

SELECT 
  *,
  ROUND(yearly_revenue_by_hotel_type/yearly_revenue,2) AS hotel_revenue_share
FROM
  (SELECT 
    *,
    SUM(revenue) OVER(PARTITION BY arrival_date_year) AS yearly_revenue,
    SUM(revenue) OVER(PARTITION BY arrival_date_year, hotel) AS yearly_revenue_by_hotel_type
  FROM
    (WITH hotels AS (
    SELECT * FROM `portfolio-project-1-374821.hotel.2018`
    UNION ALL
    SELECT * FROM `portfolio-project-1-374821.hotel.2019`
    UNION ALL
    SELECT * FROM `portfolio-project-1-374821.hotel.2020`)

    SELECT 
      hotel,
      arrival_date_year,
      ROUND(SUM((stays_in_weekend_nights + stays_in_week_nights)*adr*Discount),2) AS revenue,
      hotels.market_segment	
    FROM 
      hotels
    JOIN
      `portfolio-project-1-374821.hotel.meal_segment`
    ON
      `portfolio-project-1-374821.hotel.meal_segment`.market_segment = hotels.market_segment
    GROUP BY
      arrival_date_year,
      hotel,
      hotels.market_segment,
      Discount))
ORDER BY
      arrival_date_year,
      hotel,
      market_segment;
  
  -- Power BI Query
WITH hotels AS (
SELECT * FROM `portfolio-project-1-374821.hotel.2018`
UNION ALL
SELECT * FROM `portfolio-project-1-374821.hotel.2019`
UNION ALL
SELECT * FROM `portfolio-project-1-374821.hotel.2020`)

SELECT *
FROM 
  hotels
JOIN
  `portfolio-project-1-374821.hotel.meal_segment`
ON
  `portfolio-project-1-374821.hotel.meal_segment`.market_segment = hotels.market_segment
JOIN
  `portfolio-project-1-374821.hotel.meal_cost`
ON
  `portfolio-project-1-374821.hotel.meal_cost`.meal = hotels.meal
