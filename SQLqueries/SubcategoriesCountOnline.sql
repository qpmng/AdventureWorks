SELECT 
	EnglishProductCategoryName AS Category,
	EnglishProductSubcategoryName AS Subcategory,
	COUNT(EnglishProductSubcategoryName) AS QuantitiesPurchasedOnline
FROM 
	(
		SELECT
			ProductKey,
			COUNT(ProductKey) AS QuantityPurchased
		FROM 
			AdventureWorksDW2019.dbo.FactInternetSales
		GROUP BY
			ProductKey
	) AS Onl
	LEFT JOIN
		AdventureWorksDW2019.dbo.DimProduct
		ON Onl.ProductKey=AdventureWorksDW2019.dbo.DimProduct.ProductKey
	LEFT JOIN
		AdventureWorksDW2019.dbo.DimProductSubcategory
		ON AdventureWorksDW2019.dbo.DimProduct.ProductSubcategoryKey
		=AdventureWorksDW2019.dbo.DimProductSubcategory.ProductSubcategoryKey
	LEFT JOIN
		AdventureWorksDW2019.dbo.DimProductCategory
		ON AdventureWorksDW2019.dbo.DimProductSubcategory.ProductCategoryKey
		=AdventureWorksDW2019.dbo.DimProductCategory.ProductCategoryKey
WHERE 
	EnglishProductCategoryName='Bikes'
GROUP BY
	EnglishProductCategoryName, 
	EnglishProductSubcategoryName
