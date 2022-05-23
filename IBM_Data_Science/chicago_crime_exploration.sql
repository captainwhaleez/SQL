-- Databases and SQL for Data Science with Python - IBM Data Science Certificate

/* You have been hired by an organization that strives to improve educational outcomes for children and young people in Chicago.
Your job is to analyze the census, crime, and school data for a given neighborhood or district.
You will identify causes that impact the enrollment, safety, health, environment ratings of schools.
You will be required to answer questions similar to what a real life data analyst or data scientist would be tasked with. 
You will be assessed both on the correctness of your SQL queries and results. */

-- Problem 1: Find the total number of crimes recorded in the CRIME table.
SELECT COUNT(*) AS total_crimes
FROM chicago_crime;

-- Problem 2: List community areas with per capita income less than 11000.
SELECT community_area_name
FROM chicago_socioeconomic_data
WHERE per_capita_income < 11000;

-- Problem 3: List all case numbers for crimes  involving minors?
-- (children are not considered minors for the purposes of crime analysis)
SELECT case_number
FROM chicago_crime
WHERE description LIKE '%minor%';

-- Problem 4: List all kidnapping crimes involving a child?
SELECT case_number, primary_type, description
FROM chicago_crime
WHERE primary_type = 'KIDNAPPING';

-- Problem 5: What kind of crimes were recorded at schools?
SELECT DISTINCT primary_type
FROM chicago_crime
WHERE location_description LIKE '%school%';

-- Problem 6: List the average safety score for all types of schools.
SELECT  `Elementary, Middle, or High School`, AVG(safety_score) AS avg_safety_score
FROM chicago_public_schools
GROUP BY `Elementary, Middle, or High School`;

-- Problem 7: List 5 community areas with highest % of households below poverty line.
SELECT community_area_number, community_area_name
FROM chicago_socioeconomic_data
ORDER BY PERCENT_HOUSEHOLDS_BELOW_POVERTY DESC
LIMIT 5;

-- Problem 8: Which community area(number) is most crime prone?
SELECT community_area_number, COUNT(case_number) AS number_cases
FROM chicago_crime
GROUP BY community_area_number
ORDER BY number_cases DESC LIMIT 1;

-- Problem 9: Use a sub-query to find the name of the community area with highest hardship index.
SELECT community_area_name
FROM chicago_socioeconomic_data
WHERE hardship_index = (
	SELECT MAX(hardship_index)
    FROM chicago_socioeconomic_data );

-- Problem 10: Use a sub-query to determine the Community Area Name with most number of crimes?
SELECT community_area_name
FROM chicago_socioeconomic_data
WHERE community_area_number = (    
    SELECT community_area_number
    FROM chicago_crime
    GROUP BY community_area_number
    ORDER BY COUNT(community_area_number) DESC
    LIMIT 1);


