SELECT
	ProductKey,
	COUNT (ProductKey) AS NoProductsPurchasedOnline
FROM AdventureWorksDW2019.dbo.FactInternetSales
GROUP BY
	ProductKey
ORDER BY
	NoProductsPurchasedOnline DESC