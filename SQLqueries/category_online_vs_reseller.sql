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
	) AS Onl ON Res.Category=Onl.Category;
