use nasreen;

show tables;

-- Step 5: Convert the pre-processed dataset into an SQL file and import it to table named "superstore"
-- mysqldump -u root -p mydatabase mytable > mytable.sql

-- task-1: What percentage of total orders were shipped on the same date?
SELECT COUNT(*) AS Total_Orders, 
       SUM(CASE WHEN Order_Date = Ship_Date THEN 1 ELSE 0 END) AS Same_Date_Orders,
       (SUM(CASE WHEN Order_Date = Ship_Date THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS Percentage_Same_Date_Orders
FROM superstore;

-- task-2: Name top 3 customers with highest total value of orders.
SELECT Customer_Name, SUM(Sales) AS Total_Sales
FROM superstore
GROUP BY Customer_Name
ORDER BY Total_Sales DESC
LIMIT 3;

-- task-3: Find the top 5 items with the highest average sales per day.
SELECT Product_Name, AVG(Sales / DATEDIFF(Ship_Date, Order_Date)) AS Avg_Sales_Per_Day
FROM superstore
GROUP BY Product_Name
ORDER BY Avg_Sales_Per_Day DESC
LIMIT 5;

-- task-4: Write a query to find the average order value for each customer, and rank the customers by their average order value.
SELECT Customer_Name, AVG(Sales) AS Avg_Order_Value
FROM superstore
GROUP BY Customer_Name
ORDER BY Avg_Order_Value DESC;

-- task-5: Give the name of customers who ordered highest and lowest orders from each city.
SELECT City, 
       MAX(Sales) AS Highest_Order, 
       MIN(Sales) AS Lowest_Order,
       MAX(CASE WHEN Sales = max_sales THEN Customer_Name END) AS Customer_Highest_Order,
       MIN(CASE WHEN Sales = min_sales THEN Customer_Name END) AS Customer_Lowest_Order
FROM superstore
GROUP BY City;

-- task-6: What is the most demanded sub-category in the west region?
SELECT Sub_Category, SUM(Sales) AS Total_Sales
FROM superstore
WHERE Region = 'West'
GROUP BY Sub_Category
ORDER BY Total_Sales DESC
LIMIT 1;

-- task-7: Which order has the highest number of items? And which order has the highest cumulative value?
SELECT Order_ID, COUNT(*) AS num_items
FROM superstore
GROUP BY Order_ID
ORDER BY num_items DESC
LIMIT 1;

SELECT Order_ID, SUM(Sales) AS total_sales
FROM superstore
GROUP BY Order_ID
ORDER BY total_sales DESC
LIMIT 1;

-- task-8: Which order has the highest cumulative value?
SELECT Order_ID, SUM(Sales) AS total_sales
FROM superstore
GROUP BY Order_ID
ORDER BY total_sales DESC
LIMIT 1;

-- task-9: Which segment’s order is more likely to be shipped via first class?
SELECT Segment, COUNT(*) AS num_first_class_shipments
FROM superstore
WHERE Ship_Mode = 'First Class'
GROUP BY Segment
ORDER BY num_first_class_shipments DESC
LIMIT 1;

-- task-10: Which city is least contributing to total revenue?
SELECT City, SUM(Sales) AS total_revenue
FROM superstore
GROUP BY City
ORDER BY total_revenue ASC
LIMIT 1;

-- task-11: What is the average time for orders to get shipped after order is placed?
SELECT AVG(DATEDIFF(Ship_Date, Order_Date)) AS avg_ship_time
FROM superstore;

-- task-12: Which segment places the highest number of orders from each state and which segment places the largest individual orders from each state?
SELECT 
    State, 
    MAX(segment_order_count) AS highest_order_segment, 
    MAX(segment_order_value) AS highest_value_segment
FROM (
    SELECT 
        State, 
        Segment, 
        COUNT(DISTINCT Order_ID) AS segment_order_count, 
        SUM(Sales) AS segment_order_value
    FROM superstore
    GROUP BY State, Segment
) AS subquery
GROUP BY State;


-- task-13: Find all the customers who individually ordered on 3 consecutive days where each day’s total order was more than 50 in value. **
SELECT DISTINCT s1.Customer_Name
FROM superstore s1
JOIN superstore s2 ON s1.Customer_Name = s2.Customer_Name AND s2.Order_Date = DATE_ADD(s1.Order_Date, INTERVAL 1 DAY)
JOIN superstore s3 ON s1.Customer_Name = s3.Customer_Name AND s3.Order_Date = DATE_ADD(s2.Order_Date, INTERVAL 1 DAY)
WHERE s1.Sales > 50 AND s2.Sales > 50 AND s3.Sales > 50
GROUP BY s1.Customer_Name, s1.Order_Date
HAVING COUNT(DISTINCT s1.Order_Date) >= 3;

-- task-14: Find the maximum number of days for which total sales on each day kept rising.**
SELECT COUNT(*)
AS Days_of_Increasing_Sales
FROM (
SELECT
Order_Date,
SUM(Sales) AS Total_Sales,
LAG(SUM(Sales)) OVER (ORDER BY Order_Date) AS Prev_Total_Sales
FROM
superstore
GROUP BY
Order_Date
) subquery
WHERE Total_Sales > Prev_Total_Sales;
















