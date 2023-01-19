CREATE TABLE EmployeeDemographics
	(EmployeeID int,
	FirstName varchar(50),
	LastName varchar(50),
	Age int,
	Gender varchar(50)
)

CREATE TABLE EmployeeSalary
	(EmployeeID int,
	JobTitle varchar(50),
	Salary int)

INSERT INTO EmployeeDemographics values
	(1001, 'Robert', 'Half', 25 , 'Male'),
  (1001, 'Robert', 'Half', 25 , 'Male'),
	(1002, 'Pam', 'Beasely', 30, 'Female'),
	(1003, 'Dwight', 'Schrute', 29, 'Male'),
	(1004, 'Angela','Martin', 31, 'Female'),
	(1005,'Toby', 'Flenderson', 32, 'Male'),
	(1006, 'Micheal', 'Scott', 35, 'Male'),
	(1007, 'Meredith', 'Palmer', 32, 'Female'),
	(1008, 'Stanley', 'Hudson', 38, 'Male'),
  (1009, 'Kevin', 'Malone', 31, 'Male')


-- Identifying duplicate columns using groupby。 Displays only rows having a count greater than 1. 
SELECT [FirstName], [LastName], [Age], [Gender],COUNT (*) AS CNT
FROM [SQL Tutorial].[dbo].[EmployeeDemographics]
GROUP BY [FirstName], [LastName], [Age], [Gender]
HAVING COUNT(*) >1


-- This method doesnt work because the Employee ID is also duplicated.
-- It would only work if the employee ID was in chronological order having no duplicates
-- Then the below query will elect the duplicate row with the maximum ID number. 
-- Say 1 row had ID 7 and the other had ID 2 . It would select the row with ID numer 7.
-- Then we could change the 'SELECT' command to 'DELETE' and it will permanently delete the row with ID number 7
SELECT EmployeeID, FirstName, LastName, Age, Gender
FROM [SQL Tutorial].[dbo].[EmployeeDemographics] 
WHERE EmployeeID NOT IN (SELECT MIN (EmployeeID) as MaxRecordID 
FROM [SQL Tutorial].[dbo].[EmployeeDemographics] 
GROUP BY EmployeeID, FirstName, LastName, Age, Gender)



-- Lets try a Common Table Expression.
-- This displays the Employee Demographics table with a column called Duplicatecount, that counts the number of times a row appeared.
WITH CTE (EmployeeID, FirstName, LastName, Age, Gender, Duplicatecount)
AS (SELECT EmployeeID, 
			FirstName,
			LastName, 
			Age, 
			Gender,
			ROW_NUMBER () OVER(PARTITION BY EmployeeID, 
											FirstName, 
											LastName, 
											Age, 
											Gender ORDER BY EmployeeID)AS Duplicatecount 
	FROM [SQL Tutorial].[dbo].[EmployeeDemographics])	
DELETE from CTE  WHERE Duplicatecount>1
SELECT * FROM [SQL Tutorial].[dbo].[EmployeeDemographics]




-- Getting the number of females over 30 years old
SELECT Gender, COUNT(Gender) AS femalesover30
FROM [SQL Tutorial].[dbo].[EmployeeDemographics]
WHERE Gender='Female' AND  Age>30
GROUP BY Gender
-- The number of females above 30 years old is 2


-- Getting the Avergae age in the organization. 
SELECT AVG(Age) FROM [SQL Tutorial].[dbo].[EmployeeDemographics]
-- The average age in the organization is 31 years old


-- Getting the Age range of the organization
SELECT MIN(AGE) AS youngest, MAX(Age) as Oldest
FROM [SQL Tutorial].[dbo].[EmployeeDemographics]
-- The Age range is 25-38


-- Retrieving the age distribution of the organization from Smallest to Oldest.
SELECT Age, COUNT (Age) as Agedistribution
FROM [SQL Tutorial].[dbo].[EmployeeDemographics]
GROUP BY Age
ORDER BY Age ASC

-- plotting a miniature distribution graph
SELECT Age, COUNT (Age) as Agedistribution,
		REPLICATE('_',	COUNT (Age)) AS Barchart
FROM [SQL Tutorial].[dbo].[EmployeeDemographics]
GROUP BY Age
ORDER BY Age ASC

Insert into [SQL Tutorial].[dbo].[EmployeeDemographics] VALUES
(1011, 'Ryan', 'Howard', 26, 'Male'),
(NULL, 'Holly','Flax', NULL, 'Male'),
(1013, 'Darryl', 'Philbin', NULL, 'Male')


Insert Into [SQL Tutorial].[dbo].[EmployeeSalary] VALUES
(1001, 'Salesman', 45000),
(1002, 'Receptionist', 36000),
(1003, 'Salesman', 63000),
(1004, 'Accountant', 47000),
(1005, 'HR', 50000),
(1006, 'Regional Manager', 65000),
(1007, 'Supplier Relations', 41000),
(1008, 'Salesman', 48000),
(1009, 'Accountant', 42000)

Insert into [SQL Tutorial].[dbo].[EmployeeSalary] VALUES
(1010, NULL, 47000),
(NULL, 'Salesman', 43000)

SELECT * FROM [SQL Tutorial].[dbo].[EmployeeSalary]
SELECT * FROM [SQL Tutorial].[dbo].[EmployeeDemographics]

-- Joining both tables
SELECT * from [SQL Tutorial].[dbo].[EmployeeDemographics] INNER JOIN [SQL Tutorial].[dbo].[EmployeeSalary]
ON [SQL Tutorial].[dbo].[EmployeeDemographics].[EmployeeID]= [SQL Tutorial].[dbo].[EmployeeSalary].[EmployeeID]

SELECT * from [SQL Tutorial].[dbo].[EmployeeDemographics] RIGHT JOIN [SQL Tutorial].[dbo].[EmployeeSalary]
ON [SQL Tutorial].[dbo].[EmployeeDemographics].[EmployeeID]= [SQL Tutorial].[dbo].[EmployeeSalary].[EmployeeID]

SELECT * from [SQL Tutorial].[dbo].[EmployeeDemographics] LEFT JOIN [SQL Tutorial].[dbo].[EmployeeSalary]
ON [SQL Tutorial].[dbo].[EmployeeDemographics].[EmployeeID]= [SQL Tutorial].[dbo].[EmployeeSalary].[EmployeeID]

-- Union and Union all is for merging data vertically, Joins are for horizontal merging.



-- Using case when to aggreagate multiple conditions 
SELECT MAX(CASE WHEN Gender='Female' THEN Age END) OldestFemale,
MAX(CASE WHEN Gender='Male' THEN Age END) OldestMale
FROM [SQL Tutorial].[dbo].[EmployeeDemographics]
-- The oldest female in the organization is 32, oldest male 38



-- Giving the sales team a 10% raise, Acountants a 5% raise, and everybody else a 2% raise.
SELECT EmployeeDemographics.EmployeeID, FirstName, LastName, JobTitle, Salary, 
CASE 
	WHEN JobTitle='Salesman' THEN Salary+(Salary*0.10)
	WHEN JobTitle='Accountant' THEN Salary+(Salary*0.05) 
	ELSE Salary+(Salary*0.02) 
	END AS AfterRaiseSalary
from [SQL Tutorial].[dbo].[EmployeeDemographics] INNER JOIN [SQL Tutorial].[dbo].[EmployeeSalary]
ON [SQL Tutorial].[dbo].[EmployeeDemographics].[EmployeeID]= [SQL Tutorial].[dbo].[EmployeeSalary].[EmployeeID]

-- THE END