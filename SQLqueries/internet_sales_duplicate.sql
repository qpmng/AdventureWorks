SELECT 
	SalesOrderNumber,
	ProductKey,
	COUNT(*)
FROM 
	AdventureWorksDW2019.dbo.FactInternetSales
GROUP BY
	SalesOrderNumber,
	ProductKey
HAVING
	COUNT(*)>1