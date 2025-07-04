# Topic: KULTRA MEGA STORES INVENTORY ANALYSIS
## Project Overview
Kultra Mega Stores (KMS), headquartered in Lagos, specializes in office supplies and furniture. Its customer base includes individual consumers, small businesses (retail), and large corporate clients (wholesale) across Lagos, Nigeria.

You have been engaged as a Business Intelligence Analyst to support the Abuja division of KMS. The Business Manager has shared an Excel file containing order data from 2009 to 2012 and has requested that you analyze the data and present your key insights and findings.

Apply your SQL skills from the DSA Data Analysis class and solve both case scenarios 
as shared in the document. 

**Case Scenario I** 
1. Which product category had the highest sales? 
2. What are the Top 3 and Bottom 3 regions in terms of sales? 
3. What were the total sales of appliances in Ontario? 
4. Advise the management of KMS on what to do to increase the revenue from the bottom 10 customers 
5. KMS incurred the most shipping cost using which shipping method? 

**Case Scenario II** 

6. Who are the most valuable customers, and what products or services do they typically purchase? 
7. Which small business customer had the highest sales? 
8. Which Corporate Customer placed the most number of orders in 2009 – 2012? 
9. Which consumer customer was the most profitable one? 
10. Which customer returned items, and what segment do they belong to? 
11. If the delivery truck is the most economical but the slowest shipping method and Express Air is the fastest but the most expensive one, do you think the company appropriately spent shipping costs based on the Order Priority? Explain your answer

## Data Cleaning

Firstly, I opened the file I would be using in Microsoft Excel to get a good grasp of it and for appropriate cleaning measures.

I decided to rename the columns putting ‘_’ between two word columns for easy identification in SQL during analysis.
Upon studying the data further, I discovered that there were duplicate Order IDs which did not necessarily mean that the rows were duplicated but that the same customer ordered for more than one item and they were computed separately.

I checked for missing values using the filter tool and only the Product_Base_Margin column had some missing values.
Upon further study if the data, I discovered that there were duplicates that had the same Order ID, Order Date, Customer Name and Product Name but different Order Quantities in the dataset using the remove duplicates tool. To further detect which orders had almost exact duplicates I used the IF and COUNTIF function:

``` Excel
=IF(COUNTIFS($B$2:$B$8400, $B2, $C$2:$C$8400, $C2, $L$2:$L$8400, $L2, $R$2:$R$8400, $R2)>1, "Duplicate", " ")
```

After executing this function, I discovered that orders with the Order Id 37603 (row 5567) and 32800 (row 8075) had the same Order ID, Order Date, Customer Name and Product Name but different Order Quantities. I speculated that this could mean that the customer made a modification to his/her order and it was then recorded as a different row or it was a split shipment but this could not be confirmed from the company hereby serving as a limitation in my analysis.

## Data Ingestion
I was experiencing a lot of errors while trying to import the csv file so I had to change the file type to .Xls, re-format the dataset and save as .csv before importing again.

![SQL Error](https://github.com/user-attachments/assets/880e0e62-19e0-4758-8758-4497529e5c60)

## Data Cleaning in SQL

To have a view of what my data looked like in SQL, I called up my dataset.

``` SQL
SELECT *
FROM KMS_data 
I checked for missing values.
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
```

I discovered that only the product base margin column had missing values. This column was not needed for analysis so I deleted it from my table.

``` SQL
ALTER TABLE KMS_data
DROP COLUMN Product_Base_Margin
```

## Data Analysis

To analyze the product category with the highest sales:

``` SQL
-- Product Category with the highest sales
SELECT Product_Category, SUM(Sales) AS Total_Sales
FROM KMS_data
GROUP BY Product_Category
ORDER BY Total_Sales DESC
```
![1](https://github.com/user-attachments/assets/e181013e-b9a5-486b-bca2-06486f470b85)

From this, we can categorically say that the products in the Technology category made the highest sales.

To analyze the top 3 regions in terms of sales:

```SQL
-- Top 3 Regions in terms of Sales
SELECT TOP 3
	Region, SUM(Sales) AS Total_Sales
FROM KMS_data
GROUP BY Region
ORDER BY Total_Sales DESC
```
![2](https://github.com/user-attachments/assets/c7ef3194-bb9f-4865-855d-067e224d7211)

From my result, the West, Ontario and Prarie regions of Canada have the highest sales.

To analyze the lowest regions in terms of sales:

``` SQL
-- Bottom 3 Regions in terms of Sales
SELECT TOP 3
	Region, SUM(Sales) AS Total_Sales
FROM KMS_data
GROUP BY Region
ORDER BY Total_Sales
```
![3](https://github.com/user-attachments/assets/0c2f08ee-b007-443d-b621-f94e1d9673fa)

From my result, the lowest regions in terms of sales are Nunavut, Northwest Territories and Yukon.

To get the total sales of appliances in Ontario:

``` SQL
-- Total Sales of Appliances in Ontario
SELECT Region, Product_Sub_Category, SUM(Sales) AS Total_Sales
FROM KMS_data
Where Region = 'Ontario' AND Product_Sub_Category = 'Appliances'
GROUP BY Region, Product_Sub_Category
```
![4](https://github.com/user-attachments/assets/2abdbdf5-186b-44f2-a21b-3f55626fb6c0)

About $202,346.84 worth of appliances were sold in Ontario.

Then I analyzed the bottom 10 customers to see if I could figure out any pattern in their purchase behavior:

``` SQL
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
```
![5](https://github.com/user-attachments/assets/489f6117-1eaf-4c9e-8ed3-8e04be6c4749)

### Findings

I noticed that the customers that purchased least mostly belonged to customer segments like small business, consumer, home office and corporate and they purchased from products in office supplies mostly. Furthermore, I noticed that they did not order a lot of items which means they are most likely occasional buyers.

### Recommendations

Due to my findings, I would highly recommend the following:
1.	Loyalty programs and email reminders should be introduced to re-engage customers.
2.	Discount or bundled offers should be introduced to customers buying office supplies so entice them to buy more.
3.	Cross sell recommendations could also be initiated for the customers to buy more.
4.	The management could also consider better shipping offers for customers buying office supplies and also customers in the said regions as well.
5.	Marketing campaigns could be tailored specifically towards their segment needs.

I also wanted to analyze to find out the shipping method that cost the company most money:

``` SQL
-- Shipping Cost by Shipping Methods
SELECT Ship_Mode, SUM(Shipping_Cost) AS Shipping_Cost
FROM KMS_data
GROUP BY Ship_Mode
ORDER BY Shipping_Cost DESC
```
![6](https://github.com/user-attachments/assets/f6240e3b-2740-4df9-b205-7d9ed5e786f3)

From my result, shipping by road (Delivery Truck) cost the company most money.

Then I analyzed to show the most valuable customers and what products and services they typically purchase.

``` SQL
-- Top Customers by Revenue
SELECT TOP 10
	Customer_Name, SUM(Sales) AS Total_Revenue
FROM KMS_data
GROUP BY Customer_Name
ORDER BY Total_Revenue DESC
```
![7](https://github.com/user-attachments/assets/8165d925-d267-4c2e-8d17-bf0559b0c028)

The table above shows the top 10 most valuable customers to the company. 

Furthermore, I wanted to know what products or services they had purchased so far.

 ``` SQL
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
```
![7 1](https://github.com/user-attachments/assets/24e85806-8124-4c9c-b171-ba9f94dd4f95)

This table explicitly shows the different products each top customer has purchased, the number of times purchased, and the revenue gained by the company.

I also analysed to get the customer that haad the highest sales for a small business.

``` SQL
-- Small Business Customer with the Highest Sales
SELECT TOP 10 
	Customer_Name,
	Customer_Segment,
	SUM(Sales) AS Sales
FROM KMS_data
WHERE Customer_Segment = 'Small Business'
GROUP BY Customer_Name, Customer_Segment
ORDER BY Sales DESC
```
![8](https://github.com/user-attachments/assets/285b9127-4544-4bcd-a446-dba398d8699e)

From my result, Dennis Kane is the most valuable customer in the small business segment.

I analyzed to figure out the corporate customer that placed the most orders between 2009 and 2012.

``` SQL
-- Corporate Customer that Placed the Most Orders in 2009 to 2012
SELECT TOP 10
	Customer_Name, 
	Customer_Segment, 
	COUNT(DISTINCT Order_Id) AS [No. of Orders]
FROM KMS_data
WHERE Customer_Segment = 'Corporate'AND Order_Date BETWEEN '2009-01-01' AND '2012-12-31'
GROUP BY Customer_Name, Customer_Segment
ORDER BY [No. of Orders] DESC
```
![9](https://github.com/user-attachments/assets/84deb12c-3538-45e3-82fc-f2e20848819a)

From my results, Adam Hart and Roy Skaria are the corporate customers that placed the most orders between 2019 and 2012.

I analyzed to get the most profitable consumer customer.

``` SQL
-- Most Profitable Consumer Customer
SELECT TOP 10
	Customer_Name, 
	Customer_Segment, 
	SUM(Profit) AS [Total Profit]
FROM KMS_data
WHERE Customer_Segment = 'Consumer'
GROUP BY Customer_Name, Customer_Segment
ORDER BY [Total Profit] DESC
```
![10](https://github.com/user-attachments/assets/e2eabbc1-3b4c-4d51-a241-96fadb3a25b1)

From my result, the most profitable customer in the consumer segment is Emily Phan.

Next, I analyzed the customers that returned products and what segments they belonged to.

Firstly, I had to import a .csv containing information about customers that returned goods.

``` SQL
-- After importing order status data...
SELECT *
FROM Order_Status
```

I ran this code to have an overview of my data before analysis.

Then I created a view to save the tables I would be joining for further analysis.

``` SQL
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
```
![11](https://github.com/user-attachments/assets/c891d4c6-4c87-4f69-ad0a-06b69c31cecc)

To figure out the customers that returned orders and their segments:

```SQL
-- To Know the customers returned Products
SELECT
	DISTINCT Order_ID,
	Customer_Name,
	Customer_Segment,
	Status
FROM Vw_KMS_Data
```
![12](https://github.com/user-attachments/assets/19f8c913-6cd3-458b-9447-c23fcf1dd7fa)

From my result, 573 customers returned their orders and their names and segments are written above.

Lastly, I wanted to analyze if the company appropriately spent shipping costs based on order priority.
 
``` SQL
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
```
![13](https://github.com/user-attachments/assets/a2a06462-f116-40d3-99af-08d3511af56b)

From my result, the company did overspend because low and medium priority orders had really high costs via air, which was the same case with orders that priority levels were not specified. High and critical priority orders were slightly under utilized. So no, shipping costs were not appropriately utilized based on order priority.

## Recommendation
I would recommend restricting express air and regular air to critical or high priorities only and shifting low priority orders to economical options like delivery truck.

