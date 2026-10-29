CREATE TABLE hr_combined AS
SELECT h1.*, h2.MonthlyIncome, h2.MonthlyRate, h2.NumCompaniesWorked, h2.Over18, h2.OverTime,
       h2.PercentSalaryHike, h2.PerformanceRating, h2.RelationshipSatisfaction, h2.StandardHours,
       h2.StockOptionLevel, h2.TotalWorkingYears, h2.TrainingTimesLastYear, h2.WorkLifeBalance,
       h2.YearsAtCompany, h2.YearsInCurrentRole, h2.YearsSinceLastPromotion, h2.YearsWithCurrManager
FROM hr_1 h1 JOIN hr_2 h2 ON h1.EmployeeNumber = h2.Employee_ID;
-- KPI 1: Attrition rate by department
SELECT Department,
       ROUND(AVG(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END)*100,2) AS Attrition_Rate
FROM hr_combined GROUP BY Department;

-- KPI 2: Average hourly rate of male Research Scientists
SELECT ROUND(AVG(HourlyRate),2) AS Average_Hourly_Rate
FROM hr_combined WHERE Gender='Male' AND JobRole='Research Scientist';

-- KPI 3: Attrition rate vs monthly income (banded; raw income has too many distinct values)
SELECT CASE WHEN MonthlyIncome < 10000 THEN '1) < 10k'
            WHEN MonthlyIncome < 20000 THEN '2) 10k-20k'
            WHEN MonthlyIncome < 30000 THEN '3) 20k-30k'
            WHEN MonthlyIncome < 40000 THEN '4) 30k-40k'
            ELSE '5) 40k+' END AS Income_Band,
       ROUND(AVG(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END)*100,2) AS Attrition_Rate
FROM hr_combined GROUP BY Income_Band ORDER BY Income_Band;

-- KPI 4: Average working years by department
SELECT Department, ROUND(AVG(TotalWorkingYears),2) AS Average_WorkingYears
FROM hr_combined GROUP BY Department;

-- KPI 5: Job role vs work-life balance
SELECT JobRole, ROUND(AVG(WorkLifeBalance),2) AS Average_WorkLifeBalance
FROM hr_combined GROUP BY JobRole ORDER BY Average_WorkLifeBalance DESC;

-- KPI 6: Attrition rate vs years since last promotion
SELECT YearsSinceLastPromotion,
       ROUND(AVG(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END)*100,2) AS Attrition_Rate
FROM hr_combined GROUP BY YearsSinceLastPromotion ORDER BY YearsSinceLastPromotion;
