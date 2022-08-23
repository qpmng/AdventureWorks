SELECT 
	EnglishProductCategoryName,
	EnglishProductSubcategoryName,
	COUNT(EnglishProductSubcategoryName) AS NoCategoriesPurchasedReseller
FROM 
	(
		SELECT
			ProductKey,
			COUNT(ProductKey) AS NumberOfProductsPurchased
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
	EnglishProductCategoryName, EnglishProductSubcategoryName
ORDER BY
	NoCategoriesPurchasedReseller DESC;
