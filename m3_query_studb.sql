/**************************************************************
* This script queries the stu_db database
***************************************************************/

-- Initial question: How do family size, cohabitation status, reason for choosing the school 
-- (for the case of "close to home"), and family educational support relate to the familial 
-- relationship quality score given by a student?

# Let's start by looking at the raw data and seeing if anything pops out at us
USE stu_db;
SELECT sid, famsize, Pstatus, edu.reason, supp.famsup, famrel
FROM fam
JOIN edu USING (sid)
JOIN supp USING (sid)
WHERE reason='home'
ORDER by famrel;

# There are a lot of variables, so I'm going to narrow it closer to education & family
USE stu_db;
SELECT CONCAT("closer to ", reason) "Reason for choosing this school", famrel "Family Relationship Score (1-5)", 
       CONCAT(ROUND(100 * SUM(CASE WHEN famsup='yes' THEN 1 ELSE 0 END) / COUNT(*)), "%") AS "Percent of students with family education support",
       COUNT(*) "Sample Size"
FROM fam
JOIN edu USING (sid)
JOIN supp USING (sid)
WHERE reason='home'
GROUP BY famrel, reason
ORDER BY famrel;

# Hm what about comparing to the reason of course instead of home!
USE stu_db;
SELECT reason "Reason for choosing this school", famrel "Family Relationship Score (1-5)", 
       CONCAT(ROUND(100 * SUM(CASE WHEN famsup='yes' THEN 1 ELSE 0 END) / COUNT(*)), "%") AS "Percent of students with family education support",
       COUNT(*) "Sample Size"
FROM fam
JOIN edu USING (sid)
JOIN supp USING (sid)
GROUP BY famrel, reason
ORDER BY reason, famrel
LIMIT 10;

# What if we compared percentage of family support across reasons
SELECT 
reason "Reason for choosing this school", 
ROUND(AVG(famrel), 2) "Average family relationship score (1-5)",
SUM(CASE WHEN famrel=1 OR famrel=2 THEN 1 ELSE 0 END) "Number of relationship scores < 3",
CONCAT(ROUND(100 * SUM(CASE WHEN famsup='yes' THEN 1 ELSE 0 END) / COUNT(*)), "%") AS "Percent of students with family education support", 
COUNT(*) "Sample Size"
	FROM fam
	JOIN edu USING (sid)
	JOIN supp USING (sid)
	GROUP BY reason
	ORDER BY AVG(famrel);