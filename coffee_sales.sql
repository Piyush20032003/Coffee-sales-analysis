CREATE DATABASE coffee_shop_sales;

USE coffee_shop_sales;

select * from coffee_sales;

describe coffee_sales;
----------------------------------------------------------------------------------------------------------------
UPDATE coffee_sales
SET transaction_date = STR_TO_DATE(transaction_date, '%d-%m-%Y'); -------- Changes into date format

ALTER TABLE coffee_sales
MODIFY COLUMN transaction_date DATE; ----------- Changes transaction_Date column into date format

UPDATE coffee_sales
SET transaction_date = str_to_date(transaction_time, '%H:%i:%s'); ----- changing into time format

ALTER TABLE coffee_sales
MODIFY COLUMN transaction_time TIME;

ALTER TABLE coffee_sales
CHANGE COLUMN ï»¿transaction_id transaction_id int;  ----- Fixing the table name
--------------------------------------------------------------------------------------------------------------
-- calculate the total sales for each respective months
select round(sum(unit_price * transaction_qty),1) total_sales
from coffee_sales
where month(transaction_date) = 5; -- for may month

-- determine month on month increase or decrease in sale
SELECT 
    MONTH(transaction_date) AS month,
    ROUND(SUM(unit_price * transaction_qty)) AS total_sales,
    (SUM(unit_price * transaction_qty) - LAG(SUM(unit_price * transaction_qty), 1)
    OVER (ORDER BY MONTH(transaction_date))) / LAG(SUM(unit_price * transaction_qty), 1) 
    OVER (ORDER BY MONTH(transaction_date)) * 100 AS mom_increase_percentage
FROM 
    coffee_sales
WHERE 
    MONTH(transaction_date) IN (4, 5) -- for months of April and May
GROUP BY 
    MONTH(transaction_date)
ORDER BY 
    MONTH(transaction_date);

-- count total number of orders in a particular month
SELECT COUNT(transaction_id) as Total_Orders
FROM coffee_sales 
WHERE MONTH (transaction_date)= 5; -- for may month

-- mom difference and mom growth
select MONTH(transaction_date) AS month,
    ROUND(COUNT(transaction_id)) AS total_orders,
    (COUNT(transaction_id) - LAG(COUNT(transaction_id), 1) 
    OVER (ORDER BY MONTH(transaction_date))) / LAG(COUNT(transaction_id), 1) 
    OVER (ORDER BY MONTH(transaction_date)) * 100 AS mom_increase_percentage
FROM 
    coffee_sales
WHERE 
    MONTH(transaction_date) IN (4, 5) -- for April and May
GROUP BY 
    MONTH(transaction_date)
ORDER BY 
    MONTH(transaction_date);

-- total quantity sold
SELECT SUM(transaction_qty) as Total_Quantity_Sold
FROM coffee_sales 
WHERE MONTH(transaction_date) = 5;

-- Daily sales, total orders and quantity
SELECT
    SUM(unit_price * transaction_qty) AS total_sales,
    SUM(transaction_qty) AS total_quantity_sold,
    COUNT(transaction_id) AS total_orders
FROM 
    coffee_sales
WHERE 
    transaction_date = '2023-05-18'; -- For 18 May 2023
    
-- Sales trend over period
SELECT AVG(total_sales) AS average_sales
FROM (
    SELECT 
        SUM(unit_price * transaction_qty) AS total_sales
    FROM 
        coffee_sales
	WHERE 
        MONTH(transaction_date) = 5  -- Filter for May
    GROUP BY 
        transaction_date
) AS x;

-- Daily sales for month selected
SELECT DAY(transaction_date) AS day_of_month,
    ROUND(SUM(unit_price * transaction_qty),1) AS total_sales
FROM 
    coffee_sales
WHERE 
    MONTH(transaction_date) = 5  -- Filter for May
GROUP BY 
    DAY(transaction_date)
ORDER BY 
    DAY(transaction_date);

-- Comapring daily sales with average sales
SELECT 
    day_of_month,
    CASE 
        WHEN total_sales > avg_sales THEN 'Above Average'
        WHEN total_sales < avg_sales THEN 'Below Average'
        ELSE 'Average'
    END AS sales_status,
    total_sales
FROM (
    SELECT 
        DAY(transaction_date) AS day_of_month,
        SUM(unit_price * transaction_qty) AS total_sales,
        AVG(SUM(unit_price * transaction_qty)) OVER () AS avg_sales
    FROM 
        coffee_sales
    WHERE 
        MONTH(transaction_date) = 5  -- Filter for May
    GROUP BY 
        DAY(transaction_date)
) AS sales_data
ORDER BY 
    day_of_month;
    
-- sales by product category
SELECT 
	product_category,
	ROUND(SUM(unit_price * transaction_qty),1) as Total_Sales
FROM coffee_sales
WHERE
	MONTH(transaction_date) = 5 
GROUP BY product_category
ORDER BY SUM(unit_price * transaction_qty) DESC;

-- sales of top 10 products
SELECT 
	product_type,
	ROUND(SUM(unit_price * transaction_qty),1) as Total_Sales
FROM coffee_sales
WHERE
	MONTH(transaction_date) = 5 
GROUP BY product_type
ORDER BY SUM(unit_price * transaction_qty) DESC
LIMIT 10;

-- sales by store location
SELECT 
	store_location,
	SUM(unit_price * transaction_qty) as Total_Sales
FROM coffee_sales
WHERE
	MONTH(transaction_date) =5 
GROUP BY store_location
ORDER BY 	SUM(unit_price * transaction_qty) DESC;


    





