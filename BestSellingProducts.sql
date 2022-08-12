SELECT 
	ProductSales.ProductKey, 
	EnglishProductName AS ProductName,
	TotalProductsPurchased
FROM 
	(
		SELECT
			COALESCE(OnlineSales.ProductKey,ResellerSales.ProductKey) AS ProductKey,
			CASE
				WHEN OnlineSales.NoProductsPurchasedOnline IS NULL THEN ResellerSales.NumberOfProductsPurchased
				WHEN ResellerSales.NumberOfProductsPurchased IS NULL THEN OnlineSales.NoProductsPurchasedOnline
				ELSE OnlineSales.NoProductsPurchasedOnline+ResellerSales.NumberOfProductsPurchased 
			END AS TotalProductsPurchased
		FROM 
			(
				SELECT
					ProductKey,
					COUNT (ProductKey) AS NoProductsPurchasedOnline
				FROM AdventureWorksDW2019.dbo.FactInternetSales
				GROUP BY
					ProductKey
			) AS OnlineSales
			FULL OUTER JOIN
			(
				SELECT
					ProductKey,
					COUNT (ProductKey) AS NumberOfProductsPurchased
				FROM AdventureWorksDW2019.dbo.FactResellerSales
				GROUP BY
					ProductKey
			) AS ResellerSales
			ON OnlineSales.ProductKey=ResellerSales.ProductKey
	) AS ProductSales
	LEFT JOIN AdventureWorksDW2019.dbo.DimProduct
	ON ProductSales.ProductKey=AdventureWorksDW2019.dbo.DimProduct.ProductKey
ORDER BY
	TotalProductsPurchased DESC