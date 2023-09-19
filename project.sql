-- Task: Create a list that shows the "average customer lifetime value" grouped by the different districts.
-- Example:
-- If there are two customers in "District 1" where one customer has a total (lifetime) spent of $1000 and 
-- the second customer has a total spent of $2000 then the "average customer lifetime spent" in this district is $1500.
-- So, first, you need to calculate the total per customer and then the average of these totals per district.
-- Question: Which district has the highest average customer lifetime value?
-- Answer: Saint-Denis with an average customer lifetime value of 216.54.

SELECT
district,
ROUND(AVG(total),2)
FROM (SELECT
p.customer_id,
district,
SUM(amount) AS total
FROM customer c
JOIN payment p
ON p.customer_id = c.customer_id
JOIN address a
ON a.address_id = c.address_id 
GROUP BY p.customer_id, district) AS sub
GROUP BY district
ORDER by AVG(total) DESC

-- Task: Create a list that shows all payments including the payment_id, amount, and the film category (name) plus 
-- the total amount that was made in this category. 
-- Order the results ascendingly by the category (name) and as second order criterion by the payment_id ascendingly.
-- Question: What is the total revenue of the category 'Action' and what is the lowest payment_id in that category 'Action'?
-- Answer: Total revenue in the category 'Action' is 4375.85 and the lowest payment_id in that category is 16055.

SELECT
title,
payment_id,
amount,
name,
(SELECT SUM(amount) 
FROM payment p
LEFT JOIN rental r
ON p.rental_id = r.rental_id
LEFT JOIN inventory i
ON i.inventory_id = r.inventory_id
LEFT JOIN film f
ON f.film_id = i.film_id
LEFT JOIN film_category fc
ON fc.film_id = i.film_id
LEFT JOIN category c2
ON c2.category_id = fc.category_id
WHERE c.name = c2.name)

FROM payment p
LEFT JOIN rental r
ON p.rental_id = r.rental_id
LEFT JOIN inventory i
ON i.inventory_id = r.inventory_id
LEFT JOIN film f
ON f.film_id = i.film_id
LEFT JOIN film_category fc
ON fc.film_id = i.film_id
LEFT JOIN category c
ON c.category_id = fc.category_id
ORDER BY name

