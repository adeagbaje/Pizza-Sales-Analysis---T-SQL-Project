/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (50) [pizza_id]
      ,[order_id]
      ,[pizza_name_id]
      ,[quantity]
      ,[order_date]
      ,[order_time]
      ,[unit_price]
      ,[total_price]
      ,[pizza_size]
      ,[pizza_category]
      ,[pizza_ingredients]
      ,[pizza_name]
  FROM [PizzaSalesDB].[dbo].[pizza_sales]

-- Total Revenue:
SELECT SUM(total_price) AS Total_Revenue
	FROM pizza_sales

-- Average Order Value:
/****** Since the dataset contains multiple items per order, and I want to avoid counting the same order multiple times, I decided to divide the total revenue 
by the distinct count of order_id******/

SELECT (SUM(total_price)/ COUNT(DISTINCT order_id)) AS Average_Order_Value 
	FROM pizza_sales

-- Total Pizzas Sold:
SELECT SUM(quantity) AS Total_Pizzas_Sold 
	FROM pizza_sales

-- Total Orders:
SELECT COUNT(DISTINCT order_id) AS Total_Orders 
	FROM pizza_sales

-- Average Pizzas Per Order:
SELECT CAST(CAST(SUM(quantity)AS DECIMAL(10,2))/CAST(COUNT(DISTINCT order_id) AS DECIMAL(10,2)) AS DECIMAL(10,2)) AS Average_Pizzas_Per_Order 
	FROM pizza_sales

-- Daily Trend for Total Orders
SELECT DATENAME(WEEKDAY, order_date) AS Order_Day, COUNT(DISTINCT order_id) AS Total_Orders FROM pizza_sales 
	GROUP BY DATENAME(WEEKDAY, order_date),DATEPART(WEEKDAY, order_date)
		ORDER BY Total_Orders

-- Monthly Trend for Orders
SELECT DATENAME(MONTH, order_date) AS Order_Day, COUNT(DISTINCT order_id) AS Total_Orders FROM pizza_sales 
	GROUP BY DATENAME(MONTH, order_date),DATEPART(MONTH, order_date)
		ORDER BY Total_Orders

-- Percentage(%) of Sales by Pizza Category

	WITH PizzaCategorySales AS (
    SELECT
        pizza_category,
        SUM(total_price) AS Category_Sales
    FROM
        pizza_sales
    GROUP BY
        pizza_category
)

SELECT
    pizza_category,
    Category_Sales,
    CAST(Category_Sales * 100.0 / SUM(Category_Sales) OVER () AS DECIMAL(10, 2)) AS Percentage_of_Sales
FROM
    PizzaCategorySales
ORDER BY
    Percentage_of_Sales DESC;

-- Percentage (%) of Sales by Pizza Size

	WITH PizzaSizeSales AS (
    SELECT
        pizza_size,
        SUM(total_price) AS size_sales
    FROM
        pizza_sales
    GROUP BY
        pizza_size
)

SELECT
    pizza_size,
    size_sales,
    CAST(size_sales * 100.0 / SUM(size_sales) OVER () AS DECIMAL(10, 2)) AS Percentage_of_Size
FROM
    PizzaSizeSales
ORDER BY
    Percentage_of_Size DESC;


-- Total Pizzas Sold by Pizza Category
SELECT pizza_category, SUM(quantity) AS Total_Pizzas_Sold 
	FROM pizza_sales
	GROUP BY pizza_category

-- Top 5 Pizzas by Revenue
SELECT TOP 5 pizza_name, SUM(total_price) AS Total_Pizzas_Revenue 
	FROM pizza_sales
	GROUP BY pizza_name
	ORDER BY Total_Pizzas_Revenue DESC

-- Bottom 5 Pizzas by Revenue
SELECT TOP 5 pizza_name, SUM(total_price) AS Total_Pizzas_Revenue 
	FROM pizza_sales
	GROUP BY pizza_name
	ORDER BY Total_Pizzas_Revenue

-- Top 5 Pizzas by Quantity
SELECT TOP 5 pizza_name, SUM(quantity) AS Total_Pizzas_Quantity 
	FROM pizza_sales
	GROUP BY pizza_name
	ORDER BY Total_Pizzas_Quantity DESC

-- Bottom 5 Pizzas by Quantity
SELECT TOP 5 pizza_name, SUM(quantity) AS Total_Pizzas_Qantity 
	FROM pizza_sales
	GROUP BY pizza_name
	ORDER BY Total_Pizzas_Qantity

-- Top 5 Pizzas by Total Orders
SELECT TOP 5 pizza_name, COUNT(DISTiNCT order_id) AS Total_Pizzas_Ordered
	FROM pizza_sales
	GROUP BY pizza_name
	ORDER BY Total_Pizzas_Ordered DESC

-- Bottom 5 Pizzas by Total Orders
SELECT TOP 5 pizza_name, COUNT(DISTiNCT order_id) AS Total_Pizzas_Ordered
	FROM pizza_sales
	GROUP BY pizza_name
	ORDER BY Total_Pizzas_Ordered