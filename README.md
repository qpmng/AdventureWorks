# AdventureWorks
A thorough analysis of the AdventureWorks database from Microsoft

AdventureWorks is an imaginary company founded by Microsoft. It is one of the most popular sample databases for testing, examining, and analyzing.
```
SELECT 
	SalesOrderNumber,
	ProductKey,
	COUNT(*)
FROM 
	AdventureWorksDW2019.dbo.FactResellerSales
GROUP BY
	SalesOrderNumber,
	ProductKey
HAVING
	COUNT(*)>1
```
