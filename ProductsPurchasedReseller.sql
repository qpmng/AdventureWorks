SELECT
	ProductKey,
	COUNT (ProductKey) AS NumberOfProductsPurchased
FROM AdventureWorksDW2019.dbo.FactResellerSales
GROUP BY
	ProductKey
ORDER BY
	NumberOfProductsPurchased DESC