# AdventureWorks Database Analysis
## Introduction
The point of this analysis is to utilize the online and reseller sales data to determine which products or product categories keep customers coming back to AdventureWorks.

## Prepare
The prepare phase helps ensure data credibility and data integrity. Checking if the raw data is free of duplicate values allows the data to be unbiased and credible. The following SQL query checks for duplicate values in the sales table:
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
```
