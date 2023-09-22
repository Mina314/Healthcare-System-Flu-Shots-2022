/*
Objectives
Come up with flu shots dashboard for 2022 that does the following

1.) Total % of patients getting flu shots (patient is 6 months or older) stratified by
   a.) Age
   b.) Race
   c.) County (On a Map)
   d.) Overall
2.) Running Total of Flu Shots over the course of 2022
3.) Total number of Flu shots given in 2022
4.) A list of Patients that show whether or not they received the flu shots
   
Requirements:

Patients must have been "Active at our hospital"
*/

with active_patients as
(
	SELECT DISTINCT patient
	FROM encounters e
	JOIN patients p
	ON e.patient = p.id
	WHERE start between '2022-01-01' and '2023-01-01'
	AND p.deathdate is null
	AND extract(month from age('2022-12-31', p.birthdate)) >= 6
),

flu_shot_2022 as
(
	SELECT
	patient,
	min(date) AS first_flu_shot_2022
	FROM immunizations
	WHERE code = '5302'
	AND date between '2022-01-01' and '2023-01-01'
	GROUP BY patient
	ORDER by first_flu_shot_2022
)

SELECT
	id,
	first,
	last,
	birthdate,
	extract(year from age('2022-12-31', birthdate)) AS age,
	race,
	gender,
	ethnicity,
	county,
	zip,
	f.first_flu_shot_2022,
	CASE WHEN f.patient is not null THEN 1
	ELSE 0
	END as flu_shot_2022
FROM 
patients p
LEFT JOIN flu_shot_2022 f
ON p.id = f.patient
WHERE p.id IN (SELECT patient FROM active_patients)
