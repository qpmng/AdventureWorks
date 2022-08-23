WITH
	Res AS (
		SELECT 
			CASE 
				WHEN CAST(SUBSTRING(CAST(OrderDateKey AS CHAR),5,2) AS INT) BETWEEN 1 AND 3 
					THEN LEFT(OrderDateKey, 4) + 'Q1'
				WHEN CAST(SUBSTRING(CAST(OrderDateKey AS CHAR),5,2) AS INT) BETWEEN 4 AND 6  
					THEN LEFT(OrderDateKey, 4) + 'Q2'
				WHEN CAST(SUBSTRING(CAST(OrderDateKey AS CHAR),5,2) AS INT) BETWEEN 7 AND 9 
					THEN LEFT(OrderDateKey, 4) + 'Q3'
				ELSE LEFT(OrderDateKey, 4) + 'Q4'
			END AS SalesQuarter,
			ROUND(SUM(SalesAmount),0) AS Sales
		FROM AdventureWorksDW2019.dbo.FactResellerSales
		WHERE SalesTerritoryKey BETWEEN 1 AND 5
		GROUP BY OrderDateKey
	),
	Onl AS (	
		SELECT 
			CASE 
				WHEN CAST(SUBSTRING(CAST(OrderDateKey AS CHAR),5,2) AS INT) BETWEEN 1 AND 3 
					THEN LEFT(OrderDateKey, 4) + 'Q1'
				WHEN CAST(SUBSTRING(CAST(OrderDateKey AS CHAR),5,2) AS INT) BETWEEN 4 AND 6  
					THEN LEFT(OrderDateKey, 4) + 'Q2'
				WHEN CAST(SUBSTRING(CAST(OrderDateKey AS CHAR),5,2) AS INT) BETWEEN 7 AND 9 
					THEN LEFT(OrderDateKey, 4) + 'Q3'
				ELSE LEFT(OrderDateKey, 4) + 'Q4'
			END AS SalesQuarter,
			ROUND(SUM(SalesAmount),0) AS Sales
		FROM AdventureWorksDW2019.dbo.FactInternetSales
		WHERE SalesTerritoryKey BETWEEN 1 AND 5
		GROUP BY OrderDateKey
	)
SELECT 
	COALESCE(Res.SalesQuarter,Onl.SalesQuarter) AS SalesPeriod,
	COALESCE(SUM(Res.Sales), 0) AS ResellerSales,
	COALESCE(SUM(Onl.Sales), 0) AS OnlineSales,
	COALESCE(SUM(Onl.Sales), 0)+COALESCE(SUM(Res.Sales), 0) AS Sales
FROM 
	Res 
	FULL OUTER JOIN
	Onl ON Res.SalesQuarter=Onl.SalesQuarter
WHERE LEFT(COALESCE(Res.SalesQuarter,Onl.SalesQuarter),4) BETWEEN 2011 AND 2013
GROUP BY COALESCE(Res.SalesQuarter,Onl.SalesQuarter)
ORDER BY SalesPeriod;