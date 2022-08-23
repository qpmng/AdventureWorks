SELECT 
	CustomerKey,
	COUNT(CustomerKey)
FROM 
	AdventureWorksDW2019.dbo.DimCustomer
GROUP BY
	CustomerKey
HAVING
	COUNT(CustomerKey)>1;
