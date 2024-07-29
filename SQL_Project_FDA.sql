use fda;

## Task 1: Identifying Approval Trends

## 1.Determine the number of drugs approved each year and provide insights into the yearly trends.
SELECT YEAR(DocDate) AS YEAR, COUNT(ActionType) AS Approved_Drugs,
LAG(COUNT(ActionType),1,0) OVER(ORDER BY COUNT(ActionType) ASC) AS Previous_Yearly_Approved_Drugs
FROM appdoc WHERE ActionType = "AP" GROUP BY YEAR ORDER BY YEAR;


## 2.Identify the top three years that got the highest and lowest approvals, in descending and ascending order, respectively.
SELECT YEAR(DocDate) AS YEAR, COUNT(ActionType) AS Highest_Approved_Drugs
FROM appdoc WHERE ActionType = "AP" GROUP BY YEAR ORDER BY Highest_Approved_Drugs DESC LIMIT 3;

SELECT YEAR(DocDate) AS YEAR, COUNT(ActionType) AS Lowest_Approved_Drugs
FROM appdoc WHERE ActionType = "AP" GROUP BY YEAR ORDER BY Lowest_Approved_Drugs ASC LIMIT 3;


## 3.Explore approval trends over the years based on sponsors.
SELECT YEAR(a.DocDate) AS YEAR, COUNT(a.ActionType) AS Approved_Drugs, ap.SponsorApplicant
FROM appdoc AS a INNER JOIN application AS ap
ON a.ApplNo = ap.ApplNo
WHERE a.ActionType = "AP" GROUP BY YEAR, ap.SponsorApplicant ORDER BY YEAR;


## 4.Rank sponsors based on the total number of approvals they received each year between 1939 and 1960.
SELECT YEAR(a.DocDate) AS YEAR, COUNT(a.ActionType) AS Approved_Drugs, ap.SponsorApplicant,
DENSE_RANK() OVER (PARTITION BY YEAR(a.DocDate) ORDER BY ap.SponsorApplicant DESC) AS "Sponsor_Rank" 
FROM appdoc AS a INNER JOIN application AS ap
ON a.ApplNo = ap.ApplNo
WHERE a.ActionType = "AP" AND YEAR(a.DocDate) BETWEEN 1939 AND 1960
GROUP BY YEAR, ap.SponsorApplicant ORDER BY YEAR;

#-------------------------------------------------------------------------------------------------------------------------------------------------------#

## Task 2: Segmentation Analysis Based on Drug MarketingStatus

## 1.Group products based on MarketingStatus. Provide meaningful insights into the segmentation patterns.
SELECT drugname AS Product_DrugName, activeingred AS Active_Ingredient_Product, Form AS Formulation_Of_Product, Dosage,
(CASE WHEN ProductMktStatus = 1 THEN "Active_Product"  WHEN ProductMktStatus = 3 THEN "Under_Regulatory_Review" ELSE "Others" END) AS "Marketing_Status"
FROM product;


## 2.Calculate the total number of applications for each MarketingStatus year-wise after the year 2010.
SELECT YEAR(a.DocDate) AS YEAR, COUNT(a.ApplNo) AS Applications_Number, 
(CASE WHEN p.ProductMktStatus =1 THEN "Active_Product" WHEN p.ProductMktStatus =3 THEN "Under_Regulatory_Review" ELSE "Others" END) AS "Marketing_Status"
FROM appdoc AS a INNER JOIN product AS p
ON a.ApplNo = p.ApplNo WHERE YEAR(a.DocDate) > 2010 GROUP BY YEAR,p.ProductMktStatus ORDER BY YEAR;


## 3.Identify the top MarketingStatus with the maximum number of applications and analyze its trend over time.
SELECT YEAR(a.DocDate)AS YEAR, MONTHNAME(a.DocDate) AS MONTH, MAX(a.ApplNo) AS MAX_Applications_Number, 
(CASE WHEN p.ProductMktStatus =1 THEN "Active_Product" WHEN p.ProductMktStatus =3 THEN "Under_Regulatory_Review" ELSE "Others" END) AS "Marketing_Status"
FROM appdoc AS a INNER JOIN product AS p
ON a.ApplNo = p.ApplNo GROUP BY MONTH,YEAR,p.ProductMktStatus ORDER BY MAX(a.ApplNo) DESC;

#-------------------------------------------------------------------------------------------------------------------------------------------------------#

## Task 3: Analyzing Products

## 1.Categorize Products by dosage form and analyze their distribution.
SELECT p.drugname, a.SponsorApplicant, p.Dosage, p.Form,
(CASE WHEN p.ProductMktStatus =1 THEN "Authorization_FOR_Sale" WHEN p.ProductMktStatus =3 THEN "Not_Authorization_FOR_Sale" ELSE "Others" END) AS "Distribution"
FROM product AS p INNER JOIN application AS a
ON p.ApplNo = a.ApplNo; 


## 2.Calculate the total number of approvals for each dosage form and identify the most successful forms.
SELECT p.Form,p.Dosage , COUNT(a.ActionType) AS Approved 
FROM appdoc AS a INNER JOIN product AS p
ON a.ApplNo = p.ApplNo WHERE a.ActionType = "AP" GROUP BY p.Form,p.Dosage ORDER BY Approved DESC;


## 3.Investigate yearly trends related to successful forms.
SELECT YEAR(a.DocDate)AS YEAR, p.Form, COUNT(a.ActionType) AS Approved 
FROM appdoc AS a INNER JOIN product AS p
ON a.ApplNo = p.ApplNo WHERE a.ActionType = "AP" GROUP BY YEAR, p.Form ORDER BY Approved DESC;

#-------------------------------------------------------------------------------------------------------------------------------------------------------#

## Task 4: Exploring Therapeutic Classes and Approval Trends

## 1.Analyze drug approvals based on therapeutic evaluation code (TE_Code).
SELECT p.TECode, COUNT(a.ActionType) AS Approved 
FROM appdoc AS a INNER JOIN product_tecode AS p
ON a.ApplNo = p.ApplNo WHERE a.ActionType = "AP" GROUP BY p.TECode ORDER BY Approved DESC;


## 2.Determine the therapeutic evaluation code (TE_Code) with the highest number of Approvals in each year.
SELECT YEAR(a.DocDate)AS YEAR, p.TECode, COUNT(a.ActionType) AS Approved 
FROM appdoc AS a INNER JOIN product_tecode AS p
ON a.ApplNo = p.ApplNo WHERE a.ActionType = "AP" GROUP BY YEAR, p.TECode ORDER BY Approved DESC;

#-------------------------------------------------------------------------------------------------------------------------------------------------------#


CREATE VIEW Task AS
SELECT a.ApplNo, a.SeqNo, a.DocType, YEAR(a.DocDate),a.ActionType,
p.ProductNo , p.Form , p.Dosage , p.ProductMktStatus , p.TECode , p.drugname , p.activeingred
FROM appdoc AS a INNER JOIN product AS p
ON a.ApplNo = p.ApplNo;


SELECT * FROM application;
SELECT * FROM appdoc;
SELECT * FROM appdoctype_lookup;
SELECT * FROM chemtypelookup;
SELECT * FROM doctype_lookup;
SELECT * FROM product;
SELECT * FROM product_tecode;
SELECT * FROM regactiondate;
SELECT * FROM reviewclass_lookup;









































