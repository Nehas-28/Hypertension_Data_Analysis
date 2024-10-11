SELECT * FROM uncleaned_hypertension_data;

SET SQL_SAFE_UPDATES = 0;

DELETE FROM uncleaned_hypertension_data
WHERE `Discharge Date` < `Admit Date`;

DELETE FROM uncleaned_hypertension_data
WHERE `Billing Amount` IS NULL OR `Patient ID` IS NULL;

SELECT * FROM uncleaned_hypertension_data
ORDER BY `Patient ID` ASC;

SELECT COUNT(*) AS Total_Rows
FROM uncleaned_hypertension_data;

#Query 1: Distribution of Patients by Age Group and Gender
SELECT 
    CASE
        WHEN Age BETWEEN 0 AND 20 THEN '0-20'
        WHEN Age BETWEEN 21 AND 40 THEN '21-40'
        WHEN Age BETWEEN 41 AND 60 THEN '41-60'
        WHEN Age BETWEEN 61 AND 80 THEN '61-80'
        ELSE '80+'
    END AS Age_Group,
    Gender,
    COUNT(*) AS Patient_Count
FROM uncleaned_hypertension_data
GROUP BY Age_Group, Gender;

#Query 2: Average Length of Stay for Each Bed Type (General, Private, ICU)
SELECT 
    `Bed Occupancy`, 
    AVG(DATEDIFF(`Discharge Date`, `Admit Date`)) AS Avg_Length_of_Stay
FROM uncleaned_hypertension_data
WHERE `Discharge Date` IS NOT NULL AND `Admit Date` IS NOT NULL
GROUP BY `Bed Occupancy`;

#Query 3: Percentage of Total Billing Covered by Health Insurance
SELECT 
    SUM(`Health Insurance Amount`) / SUM(`Billing Amount`) * 100 AS Insurance_Coverage_Percentage
FROM uncleaned_hypertension_data
WHERE `Billing Amount` IS NOT NULL AND `Health Insurance Amount` IS NOT NULL;

#Query 4: Count of Emergency Cases and Their Average Length of Stay
SELECT 
    COUNT(*) AS Emergency_Case_Count,
    AVG(DATEDIFF(`Discharge Date`, `Admit Date`)) AS Avg_Emergency_Length_of_Stay
FROM uncleaned_hypertension_data
WHERE `Disease Status` = 'Emergency Case'
  AND `Discharge Date` IS NOT NULL
  AND `Admit Date` IS NOT NULL;

#Query 5: Count of Patients by Disease Status (Stage 1, Stage 2, Emergency)
SELECT 
    `Disease Status`, 
    COUNT(*) AS Patient_Count
FROM uncleaned_hypertension_data
GROUP BY `Disease Status`;

#Query 6: Total Unpaid Billing Amount Where Health Insurance Didn’t Cover Full Bill
SELECT 
    SUM(`Billing Amount` - `Health Insurance Amount`) AS Total_Unpaid_Amount
FROM uncleaned_hypertension_data
WHERE `Billing Amount` > `Health Insurance Amount`
  AND `Billing Amount` IS NOT NULL
  AND `Health Insurance Amount` IS NOT NULL;

#Query 7:ICU Occupancy Rates
SELECT 
    COUNT(*) AS ICU_Occupancy,
    COUNT(*) / (SELECT COUNT(*) FROM uncleaned_hypertension_data) * 100 AS ICU_Occupancy_Percentage
FROM uncleaned_hypertension_data
WHERE `Bed Occupancy` = 'ICU';

#Query 8: Seasonal Trends in Admissions
SELECT 
    MONTH(`Admit Date`) AS Month, 
    COUNT(*) AS Admission_Count
FROM uncleaned_hypertension_data
GROUP BY MONTH(`Admit Date`);

SELECT * FROM uncleaned_hypertension_data;