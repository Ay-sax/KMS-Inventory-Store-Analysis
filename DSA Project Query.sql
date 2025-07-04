SELECT *
FROM KMS_data

-- Checking for null values
SELECT * 
FROM KMS_data
WHERE Row_ID IS NULL
	OR Order_ID IS NULL
	OR Order_Date IS NULL
	OR Order_Priority IS NULL
	OR Order_Quantity IS NULL
	OR Sales IS NULL
	OR Discount IS NULL
	OR Ship_Mode IS NULL
	OR Profit IS NULL 
	OR Unit_Price IS NULL
	OR Shipping_Cost IS NULL
	OR Customer_Name IS NULL
	OR Province IS NULL
	OR Region IS NULL
	OR Customer_Segment IS NULL
	OR Product_Category IS NULL
	OR Product_Sub_Category IS NULL
	OR Product_Name IS NULL
	OR Product_Container IS NULL
	OR Product_Base_Margin IS NULL
	OR Ship_Date IS NULL

-- Delete Product_base_Margin column
ALTER TABLE KMS_data
DROP COLUMN Product_Base_Margin

----------- Analysis --------------
-- Product Category with the highest sales
SELECT Product_Category, SUM(Sales) AS Total_Sales
FROM KMS_data
GROUP BY Product_Category
ORDER BY Total_Sales DESC

-- Top 3 Regions in terms of Sales
SELECT TOP 3
	Region, SUM(Sales) AS Total_Sales
FROM KMS_data
GROUP BY Region
ORDER BY Total_Sales DESC

-- Bottom 3 Regions in terms of Sales
SELECT TOP 3
	Region, SUM(Sales) AS Total_Sales
FROM KMS_data
GROUP BY Region
ORDER BY Total_Sales

-- Total Sales of Appliances in Ontario
SELECT Region, Product_Sub_Category, SUM(Sales) AS Total_Sales
FROM KMS_data
Where Region = 'Ontario' AND Product_Sub_Category = 'Appliances'
GROUP BY Region, Product_Sub_Category

-- Bottom 10 Customers (Revenue)
SELECT TOP 10
Customer_Name, SUM(Sales) AS Total_Revenue,
	MIN(Region) AS Region, 
	MIN(Customer_Segment) AS Customer_Segment, 
	MIN(Product_Category) AS Product_Category1,
	MAX(Product_Category) AS Product_Category2,
	COUNT(Order_Id) AS [No. of Items Ordered]
FROM KMS_data
GROUP BY Customer_Name
ORDER BY Total_Revenue

-- Shipping Cost by Shipping Methods
SELECT Ship_Mode, SUM(Shipping_Cost) AS Shipping_Cost
FROM KMS_data
GROUP BY Ship_Mode
ORDER BY Shipping_Cost DESC

-- Top Customers by Revenue
SELECT TOP 10
	Customer_Name, SUM(Sales) AS Total_Revenue
FROM KMS_data
GROUP BY Customer_Name
ORDER BY Total_Revenue DESC

-- The Products or Services They Typically Purchase
SELECT
	Customer_Name,
	Product_Name, 
	COUNT(*) AS Times_Purchased,
	SUM(Sales) AS Total_Spent
FROM KMS_data
WHERE Customer_Name IN (
	SELECT TOP 10 Customer_Name
	FROM KMS_data
	GROUP BY Customer_Name
	ORDER BY SUM(Sales) DESC
	)
GROUP BY Customer_Name, Product_Name
ORDER BY Customer_Name, Total_Spent DESC

-- Small Business Customer with the Highest Sales
SELECT TOP 10 
	Customer_Name,
	Customer_Segment,
	SUM(Sales) AS Sales
FROM KMS_data
WHERE Customer_Segment = 'Small Business'
GROUP BY Customer_Name, Customer_Segment
ORDER BY Sales DESC

-- Corporate Customer that Placed the Most Orders in 2009 to 2012
SELECT TOP 10
	Customer_Name, 
	Customer_Segment, 
	COUNT(DISTINCT Order_Id) AS [No. of Orders]
FROM KMS_data
WHERE Customer_Segment = 'Corporate'AND Order_Date BETWEEN '2009-01-01' AND '2012-12-31'
GROUP BY Customer_Name, Customer_Segment
ORDER BY [No. of Orders] DESC

-- Most Profitable Consumer Customer
SELECT TOP 10
	Customer_Name, 
	Customer_Segment, 
	SUM(Profit) AS [Total Profit]
FROM KMS_data
WHERE Customer_Segment = 'Consumer'
GROUP BY Customer_Name, Customer_Segment
ORDER BY [Total Profit] DESC

-- Analyzing Customers that Returned Products and the Segments they Belonged to
-- After importing order status data...
SELECT *
FROM Order_Status

-- Join the Order Status to the KMS_data Table
CREATE VIEW Vw_KMS_Data
AS
SELECT
	KMS_data.Order_ID,
	KMS_data.Customer_Name,
	KMS_data.Customer_Segment,
	Order_Status.Status
FROM KMS_data
JOIN Order_Status ON KMS_data.Order_ID = Order_Status.Order_ID

-- To Know the customers returned Products
SELECT
	DISTINCT Order_ID,
	Customer_Name,
	Customer_Segment,
	Status
FROM Vw_KMS_Data

-- To analyze if the company appropriately spent shipping costs based on order priority
SELECT
	Order_Priority,
	Ship_Mode,
	COUNT(DISTINCT Order_ID) AS Total_Orders,
	SUM(Shipping_Cost) AS Total_Shipping_Cost,
	AVG(Shipping_Cost) AS Avg_Shipping_Cost_Per_Order
FROM KMS_data
GROUP BY Order_Priority, Ship_Mode
ORDER BY Order_Priority, Total_Shipping_Cost DESC