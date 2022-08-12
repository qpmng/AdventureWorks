SELECT
	SalesAndID.EmployeeKey, 
	CASE 
		WHEN MiddleName IS NULL THEN "FirstName"+' '+ "LastName"
		ELSE "FirstName"+' '+"MiddleName"+'. '+"LastName"
		END AS EmployeeFullName,
	TotalSales
FROM 
	(
		SELECT 
			EmployeeKey,
			SUM(SalesAmountQuota) AS TotalSales
		FROM
			AdventureWorksDW2019.dbo.FactSalesQuota
		GROUP BY
			EmployeeKey
	) AS SalesAndID
	LEFT JOIN AdventureWorksDW2019.dbo.DimEmployee
	ON SalesAndID.EmployeeKey=AdventureWorksDW2019.dbo.DimEmployee.EmployeeKey
ORDER BY
	TotalSales DESC