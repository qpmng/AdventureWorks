# AdventureWorks Database Analysis
## Introduction
The point of this analysis is to utilize the online and reseller sales data to determine which products or product categories keep customers coming back to AdventureWorks.

## Prepare
The AdventureWorks database can be found [here](https://docs.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver16&tabs=ssms).
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
We use a similar SQL query to check for duplicate values in the online sales and customer tables. Fortunately, based on the result, there are no duplicate orders and no duplicate customer information. Thus, we can move on to processing the data.

## Process
The process phase allows us to transform the data into meaningful patterns for analysis. The following SQL query returns the top 5 best selling products of all time. This query also includes subqueries to find the top 5 best selling products in each division.
```
SELECT TOP 5
	ProductSales.ProductKey, 
	EnglishProductName AS ProductName,
	TotalProductsPurchased
FROM 
	(
		SELECT
			COALESCE(OnlineSales.ProductKey,ResellerSales.ProductKey) AS ProductKey,
			CASE
				WHEN OnlineSales.NoProductsPurchasedOnline IS NULL 
					THEN ResellerSales.NumberOfProductsPurchased
				WHEN ResellerSales.NumberOfProductsPurchased IS NULL 
					THEN OnlineSales.NoProductsPurchasedOnline
				ELSE OnlineSales.NoProductsPurchasedOnline+ResellerSales.NumberOfProductsPurchased 
			END AS TotalProductsPurchased
		FROM 
			(
				SELECT
					ProductKey,
					COUNT(ProductKey) AS NoProductsPurchasedOnline
				FROM 
					AdventureWorksDW2019.dbo.FactInternetSales
				GROUP BY
					ProductKey
			) AS OnlineSales
			LEFT JOIN
			(
				SELECT
					ProductKey,
					COUNT(ProductKey) AS NumberOfProductsPurchased
				FROM 
					AdventureWorksDW2019.dbo.FactResellerSales
				GROUP BY
					ProductKey
			) AS ResellerSales
			ON OnlineSales.ProductKey=ResellerSales.ProductKey
	) AS ProductSales
	LEFT JOIN AdventureWorksDW2019.dbo.DimProduct
	ON ProductSales.ProductKey=AdventureWorksDW2019.dbo.DimProduct.ProductKey
ORDER BY
	TotalProductsPurchased DESC
;
```


