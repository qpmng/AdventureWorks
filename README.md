# AdventureWorks Database Analysis
## Introduction
The point of this analysis is to utilize the online and reseller sales data to determine which products or product categories keep customers coming back to AdventureWorks. The company also wants to identify which product generates the highest revenue per one product quantity.<br/>\
Most data manipulation and transformation process will be done with SQL, while data visualization will be created with R and Tableau.

## Prepare
The AdventureWorks database can be found [here](https://docs.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver16&tabs=ssms). <br/>\
The prepare phase helps ensure data credibility and data integrity. Checking if the raw data is free of duplicate values allows the data to be unbiased and credible. The following SQL query checks for duplicate values in the reseller sales table - if a sales order number contains more than one product key, it is considered a duplicate order.
```sql
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
The process phase allows us to transform the data into meaningful patterns for analysis. The following SQL query returns the top 5 best-selling products of all time. This query also includes subqueries to find the top 5 best-selling products in each division.
```sql
SELECT TOP 5
	EnglishProductName AS ProductName,
	TotalProductsPurchased
FROM
	(
		SELECT								
			COALESCE(Onl.ProductKey,Res.ProductKey) AS ProductKey,
			CASE
				WHEN Onl.QuantityPurchased IS NULL 
					THEN Res.QuantityPurchased
				WHEN Res.QuantityPurchased IS NULL 
					THEN Onl.QuantityPurchased
				ELSE Onl.QuantityPurchased+Res.QuantityPurchased 
			END AS TotalProductsPurchased
		FROM 
			(
				SELECT
					ProductKey,
					COUNT(ProductKey) AS QuantityPurchased
				FROM 
					AdventureWorksDW2019.dbo.FactInternetSales
				GROUP BY
					ProductKey
			) AS Onl -- Best-selling products online
			LEFT JOIN
			(
				SELECT
					ProductKey,
					COUNT(ProductKey) AS QuantityPurchased
				FROM 
					AdventureWorksDW2019.dbo.FactResellerSales
				GROUP BY
					ProductKey
			) AS Res -- Best-selling products from resellers
			ON Onl.ProductKey=Res.ProductKey
	) AS ProductSales
	LEFT JOIN AdventureWorksDW2019.dbo.DimProduct
	ON ProductSales.ProductKey=AdventureWorksDW2019.dbo.DimProduct.ProductKey -- Return the product name
ORDER BY
	TotalProductsPurchased DESC
;
```
Each product has a category, and thís SQL query reports the number of products purchased in each type.
```sql
SELECT
	COALESCE(Res.Category, Onl.Category) AS Category,
	COALESCE(Res.CategoriesPurchased,0) AS ResPurchases,
	COALESCE(Onl.CategoriesPurchased,0) AS OnlPurchases
FROM
	(
		SELECT 
			EnglishProductCategoryName AS Category,
			COUNT(EnglishProductCategoryName) AS CategoriesPurchased
		FROM 
			(
				SELECT
					ProductKey,
					COUNT(ProductKey) AS QuantityPurchased
				FROM
					AdventureWorksDW2019.dbo.FactResellerSales
				GROUP BY
					ProductKey
			) AS TotalNoProducts
				LEFT JOIN
					AdventureWorksDW2019.dbo.DimProduct
					ON TotalNoProducts.ProductKey=AdventureWorksDW2019.dbo.DimProduct.ProductKey
				LEFT JOIN
					AdventureWorksDW2019.dbo.DimProductSubcategory
					ON AdventureWorksDW2019.dbo.DimProduct.ProductSubcategoryKey
					=AdventureWorksDW2019.dbo.DimProductSubcategory.ProductSubcategoryKey
				LEFT JOIN
					AdventureWorksDW2019.dbo.DimProductCategory
					ON AdventureWorksDW2019.dbo.DimProductSubcategory.ProductCategoryKey
					=AdventureWorksDW2019.dbo.DimProductCategory.ProductCategoryKey
		GROUP BY
			EnglishProductCategoryName
	) AS Res
	FULL OUTER JOIN
	(
		SELECT 
			EnglishProductCategoryName AS Category,
			COUNT(EnglishProductCategoryName) AS CategoriesPurchased
		FROM 
			(
				SELECT
					ProductKey,
					COUNT(ProductKey) AS QuantityPurchased
				FROM 
					AdventureWorksDW2019.dbo.FactInternetSales
				GROUP BY
					ProductKey
			) AS TotalNoProducts
			LEFT JOIN
				AdventureWorksDW2019.dbo.DimProduct
				ON TotalNoProducts.ProductKey=AdventureWorksDW2019.dbo.DimProduct.ProductKey
			LEFT JOIN
				AdventureWorksDW2019.dbo.DimProductSubcategory
				ON AdventureWorksDW2019.dbo.DimProduct.ProductSubcategoryKey
				=AdventureWorksDW2019.dbo.DimProductSubcategory.ProductSubcategoryKey
			LEFT JOIN
				AdventureWorksDW2019.dbo.DimProductCategory
				ON AdventureWorksDW2019.dbo.DimProductSubcategory.ProductCategoryKey
				=AdventureWorksDW2019.dbo.DimProductCategory.ProductCategoryKey
		GROUP BY
			EnglishProductCategoryName
	) AS Onl ON Res.Category=Onl.Category
```

