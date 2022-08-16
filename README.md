# AdventureWorks Database Analysis
## Introduction
The point of this analysis is to utilize the online and reseller sales data to determine which products or product categories keep customers coming back to AdventureWorks.

## Prepare
The prepare phase helps ensure data credibility and data integrity. Checking if the raw data is free of duplicate values allows the data to be unbiased and credible. The following SQL query checks for duplicate values in the reseller sales table:
```
SELECT 
	SalesOrderNumber,
	ProductKey,
	COUNT(*)
FROM 
	AdventureWorksDW2019.dbo.FactResellerSales
GROUP BY
	SalesOrderNumber,
	ProductKey
HAVING
	COUNT(*)>1
;
```
We use a similar SQL query to check for duplicate values in the online sales and customer tables. Based on the result, there are no duplicate orders and no duplicate customer information. Thus, we can move on to processing the data.

## Process
The process phase allows us to transform the data into meaningful patterns for analysis. The following SQL query returns the top 10 best selling products 
