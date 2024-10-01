#create database work_module;
use work_module;
ALTER TABLE online_retail
MODIFY COLUMN invoicedate DATETIME;

-- describe online_retail;
-- What is the distribution of order values across all customers in the dataset?
select customerid, min(quantity*UnitPrice) as MinPurchase
from online_retail
group by customerid;

-- How many unique products has each customer purchased?

select customerid,count(distinct stockcode) as DistinctProduct
from online_retail
group by customerid
order by DistinctProduct;

-- Which customers have only made a single purchase from the company?
select customerid,count(distinct stockcode) as DistinctProduct
from online_retail
group by customerid
having DistinctProduct=1;

-- Which products are most commonly purchased together by customers in the dataset?
select t1.stockcode as product1,t2.stockcode as product2,count(*) as PurchasedTogether
from online_retail t1
join online_retail t2
on t1.InvoiceNo=t2.InvoiceNo 
and t1.StockCode>t2.StockCode
where t1.CustomerID=t2.CustomerID
group by t1.StockCode,t2.StockCode
order by PurchasedTogether desc;

-- ADVANCED QUERIES

-- Group customers into segments based on their purchase frequency, such as high, medium, and low frequency customers. 
select customerid, count(invoiceno) as Frequancy,
case
when count(invoiceno)>50 then 'High Frequency'
when count(invoiceno) between 20 and 50 then 'Medium Frequency'
else 'Low Frequency'
end as FrequancySegment
from online_retail
group by customerid;

-- Calculate the average order value for each country to identify where your most valuable customers are located.

select country, round(avg(quantity*unitprice),2) as AvgSale
from online_retail
group by country
order by AvgSale ;

-- Identify customers who haven't made a purchase in a specific period (e.g., last 6 months) to assess churn.
select customerid,max(invoicedate) as lastpurchase,
datediff((select max(invoicedate)),MIN(invoicedate)) as DaysSinceLastPurchase
from online_retail
group by customerid
having DaysSinceLastPurchase >180
order by lastpurchase;

select max(invoicedate) FROM ONLINE_RETAIL GROUP BY CUSTOMERID;

-- Determine which products are often purchased together by calculating the correlation between product purchases
SELECT a.StockCode AS Product1, b.StockCode AS Product2, COUNT(*) AS PurchaseCount
FROM online_retail a
JOIN online_retail b ON a.InvoiceNo = b.InvoiceNo AND a.StockCode <> b.StockCode
GROUP BY Product1, Product2
ORDER BY PurchaseCount DESC;

-- Explore trends in customer behavior over time, such as monthly or quarterly sales patterns
SELECT DATE_FORMAT(STR_TO_DATE(InvoiceDate, '%m/%d/%Y %H:%i'), '%Y-%m') AS Month, SUM(Quantity * UnitPrice) AS MonthlySales
FROM online_retail
WHERE InvoiceDate IS NOT NULL AND Quantity > 0  -- Exclude negative quantities
GROUP BY DATE_FORMAT(STR_TO_DATE(InvoiceDate, '%m/%d/%Y %H:%i'), '%Y-%m')
ORDER BY Month ASC;