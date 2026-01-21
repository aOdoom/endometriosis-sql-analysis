-- ============================================================
-- Endometriosis Symptom & Risk Analysis
-- Dataset: https://www.kaggle.com/datasets/michaelanietie/endometriosis-dataset
-- ============================================================

-- ============================================================
-- PART 1: EXPLORATORY ANALYSIS
-- ============================================================

-- View the first 20 rows of data
SELECT *
FROM endo_data
LIMIT 20;

-- List all column names and data types
DESCRIBE endo_data;

/*
Column Descriptions:
- Age: integer, individual's age
- Menstrual_Irregularity: integer, cycle regularity (binary: 0 = regular, 1 = irregular)
- Chronic_Pain_Level: double, pain level from 0-10
- Hormone_Level_Abnormality: integer (binary: 0 = normal, 1 = abnormal)
- Infertility: integer (binary: 0 = no, 1 = yes)
- BMI: double, body mass index (range: 15-40)
- Diagnosis: integer, endometriosis diagnosis (binary: 0 = no, 1 = yes)

Variable Categories:
- Demographics: age
- Symptom indicators: menstrual_irregularity, chronic_pain_level, hormone_level_abnormality, infertility, BMI
- Outcome variable: diagnosis
*/

-- ============================================================
-- PART 2: MAIN ANALYSIS
-- ============================================================

-- Q1: What is the average chronic pain level for individuals with endo compared to those without?
SELECT diagnosis, 
       AVG(chronic_pain_level) AS avg_pain_lvl
FROM endo_data
GROUP BY diagnosis
ORDER BY diagnosis DESC;
-- Result: With endo = 5.31, without endo = 4.84

-- Q2: Do individuals with endo have a higher BMI than those without?
SELECT diagnosis, 
       AVG(bmi) AS avg_bmi
FROM endo_data
GROUP BY diagnosis
ORDER BY diagnosis DESC;
-- Result: With endo = 23.4, without endo = 22.8

-- Q3: What are the earliest and average ages of those with endo and infertility compared to those without endo and fertile?
SELECT diagnosis, 
       infertility, 
       MIN(age) AS min_age, 
       AVG(age) AS avg_age
FROM endo_data
GROUP BY diagnosis, infertility
ORDER BY diagnosis, infertility DESC;
-- Result: Endo + infertile (min: 18, avg: 33.9) vs No endo + fertile (min: 18, avg: 33.75)

-- Verify minimum age in dataset
SELECT MIN(age) AS dataset_min_age
FROM endo_data;
-- Result: 18 (potential limitation - may miss adolescent onset)

-- Q4: What is the average menstrual irregularity score by fertility status?
SELECT infertility, 
       AVG(menstrual_irregularity) AS avg_irreg
FROM endo_data
GROUP BY infertility
ORDER BY infertility DESC;
-- Result: Infertile = 0.689, Fertile = 0.701

-- Q5: How many individuals have endo diagnosis + abnormal hormone levels + menstrual irregularity?
SELECT COUNT(*) AS patient_count
FROM endo_data
WHERE diagnosis = 1
  AND hormone_level_abnormality = 1
  AND menstrual_irregularity = 1;
-- Result: 2,145 patients

-- Context: Total patients with endometriosis
SELECT COUNT(*) AS total_endo_patients
FROM endo_data
WHERE diagnosis = 1;
-- Result: 4,079 patients
-- Therefore: 2,145/4,079 = 52.6% of endo patients have this symptom cluster
