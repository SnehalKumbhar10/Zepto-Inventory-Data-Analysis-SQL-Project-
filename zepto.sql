show databases;
use zepto_project;

-- data exploration
select * from zepto limit 10;

-- total no of row
select count(*) from zepto;

-- checking null values 
select * from zepto
where mrp IS NULL
OR discountPercent IS NULL
OR availableQuantity IS NULL
OR discountedSellingPrice IS NULL
OR weightInGms IS NULL
OR outOfStock IS NULL
OR quantity IS NULL;

-- checking duplicates
Select name, COUNT(*)
from zepto
group by name
having COUNT(*) > 1;


-- Check incorrect values
select * from zepto
where mrp < 0 
   OR discountedSellingPrice > mrp 
   OR discountPercent > 100;

-- distinct category names
select distinct category
from zepto;

-- boolean col check
select distinct outOfStock
from zepto;

-- data cleaning
Alter table zepto
change ï»¿Category Category text;

-- product with mrp =0
select * from zepto 
where mrp =0;
delete from zepto
where mrp =0;

-- convert Currency(paise to Rupee)
update zepto 
set mrp = mrp /100.0 ,
discountedSellingPrice  = discountedSellingPrice /100.0;

-- category distribution

select category, count(*) as total_products
from zepto
group by category
order by total_products desc;

-- price statstics 
select min(mrp),max(mrp),avg(mrp)
from zepto;

-- stock overview
SELECT outOfStock,count(*)
from zepto 
group by outOfStock;

-- Inventory & Stock 
select * from zepto limit 10;
-- How many products are currently out of stock?
SELECT outOfStock ,count(*)
FROM zepto 
WHERE outOfStock = "True";

SELECT Name,outOfStock
FROM zepto 
WHERE outOfStock = "True";

-- Which products have very low stock (below a threshold)?
select distinct availableQuantity
FROM Zepto;
SELECT name,availableQuantity
FROM zepto
Where availableQuantity < 3;

-- Which top 5 category has the highest number of out-of-stock products?
SELECT Category,count(*) as outofstockcount
FROM Zepto
WHERE outOfStock = "true"
GROUP BY Category
ORDER BY outofstockcount DESC
limit 5;

-- What is the total available inventory per category? 
SELECT Category,sum(availableQuantity) as Availableinventory
FROM Zepto
WHERE availableQuantity > 0
GROUP BY Category;

-- 🔹 Pricing & Discounts
-- Which products have the highest discount percentage?
SELECT Category,name, discountPercent 
from zepto
ORDER BY discountPercent DESC;

-- What is the average discount percentage per category?
SELECT Category, avg(discountPercent) AS Averagediscount
FROM Zepto 
GROUP BY Category
ORDER BY Averagediscount DESC;

-- Which products offer the maximum discount amount (₹)?
SELECT name,(mrp-discountedSellingPrice) As Discount_amt
FROM Zepto
order by Discount_amt desc
limit 5 ;

-- Which category gives the highest average discount?
SELECT Category, avg(discountPercent) AS Averagediscount
FROM Zepto 
GROUP BY Category
ORDER BY Averagediscount DESC
limit 5;
-- 🔹 Sales & Revenue
-- Which products generate the highest total revenue?
SELECT name,discountedSellingPrice,quantity,(discountedSellingPrice*quantity) as Revenue
FROM zepto
ORDER BY Revenue DESC
LIMIT 10;

-- What is the total revenue generated per category?
SELECT Category,sum(discountedSellingPrice*quantity) as Revenue
FROM zepto
group by Category
ORDER BY Revenue DESC;

-- Which products have high price but low sales volume?
SELECT name,mrp,quantity
FROM Zepto 
order by mrp desc , quantity asc ;


-- Which products have low price but high sales volume?
SELECT name, mrp, quantity
FROM zepto
WHERE mrp < 100
  AND quantity > 500
ORDER BY quantity DESC;

-- 🔹 Demand vs Supply
SELECT * FROM zepto limit 10;

-- Which products have high demand but low stock?

SELECT 
    MIN(quantity), MAX(quantity), AVG(quantity),
    MIN(availableQuantity), MAX(availableQuantity), AVG(availableQuantity)
FROM zepto;

SELECT name,quantity,availableQuantity
FROM zepto
where quantity > (SELECT AVG(quantity)FROM zepto)
And availableQuantity < (SELECT AVG(availableQuantity)FROM Zepto)
order by quantity desc;

-- Which products have low demand but high stock?
SELECT name,quantity,availableQuantity
FROM zepto
WHERE quantity < (SELECT AVG(quantity) FROM zepto)
AND availableQuantity > (SELECT AVG(availableQuantity) FROM zepto)
order by quantity desc;

-- Identify potential stockout risk products based on demand and availability.
SELECT name, quantity, availableQuantity,
       (quantity / availableQuantity) AS risk_ratio
FROM zepto
WHERE availableQuantity > 0
ORDER BY risk_ratio DESC;

-- 🔹 Category Performance
-- Which category has the highest total sales quantity?
SELECT Category,sum(quantity) AS TotalSalesquantity
FROM zepto
GROUP BY Category
ORDER BY TotalSalesquantity Desc
limit 1;

-- Which category has the lowest average stock availability?
SELECT Category,avg(availableQuantity) AS StockAvailable
FROM zepto
GROUP BY Category
ORDER BY StockAvailable ASC
limit 1;
-- Which category contributes the most to total revenue?
SELECT Category, SUM(discountedSellingPrice * quantity) AS total_revenue
FROM zepto
GROUP BY Category
ORDER BY total_revenue DESC
LIMIT 1;
-- 🔹 Business Decision Insights
-- Identify products where high discounts are not improving sales.
SELECT name,discountPercent,quantity
FROM zepto 
Where discountPercent > (SELECT AVG(discountPercent) FROM zepto)
and quantity < (SELECT AVG(quantity) FROM zepto)
ORDER BY discountPercent DESC;

-- Identify products that are selling well without heavy discounts. 
SELECT name, discountPercent, quantity
FROM zepto
WHERE discountPercent < (SELECT AVG(discountPercent) FROM zepto)
  AND quantity > (SELECT AVG(quantity) FROM zepto)
  ORDER BY quantity DESC;

