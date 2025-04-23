-- Queries for Rockbuster marketing promotion
    -- Competition Overview:
    -- Round 1: Locate top 10 countries by customer count
    -- Round 2: Locate top 10 cities of top 10 countries by customer count
    -- Round 3: Locate top 5 customers from these 10 cities by total spend

-- Query to find top 10 countries for Rockbuster in terms of customer numbers
SELECT D.country,
	COUNT(A.customer_id) AS no_customers
FROM customer A
INNER JOIN address B ON A.customer_id = B.address_id
INNER JOIN city C ON B.city_id = C.city_id
INNER JOIN country D ON C.country_id = D.country_id
GROUP BY D.country
ORDER BY no_customers DESC
LIMIT 10;

-- Query to find top 10 cities (by customer count) within the top 10 cities
WITH top10cntries AS ( 
	-- CTE for top 10 countries
    SELECT C.country_id,
		COUNT(A.customer_id) AS no_customers
	FROM customer A
	INNER JOIN address B ON A.customer_id = B.address_id
	INNER JOIN city C ON B.city_id = C.city_id
	GROUP BY C.country_id
	ORDER BY no_customers DESC
	LIMIT 10 
    )
SELECT C.city,
	D.country,
	COUNT(A.customer_id) AS no_of_customers
FROM customer A
INNER JOIN address B ON A.address_id = B.address_id
INNER JOIN city C ON B.city_id = C.city_id
INNER JOIN country D ON C.country_id = D.country_id
WHERE C.country_id IN 
	(SELECT country_id 
	FROM top10cntries)
GROUP BY C.city,
	D.country
ORDER BY no_of_customers DESC
LIMIT 10;


-- Create table with top 5 customers by total spend from top 10 cities from top 10 countries
    -- using combination of subqueries and CTEs
WITH top5cust (t5_customer_id, 
    t5_first_name, 
    t5_city, 
    t5_country, 
    t5_total_spent) AS
    (
    SELECT 
        A.customer_id,
        A.first_name,
        A.last_name,
        C.city,
        D.country,
        SUM(E.amount) AS total_spent
    FROM customer A
    INNER JOIN payment E ON A.customer_id = E.customer_id
    INNER JOIN address B ON A.address_id = B.address_id
    INNER JOIN city C ON B.city_id = C.city_id
    INNER JOIN country D ON C.country_id = D.country_id
    WHERE C.city IN (
        -- beginning of first subquery (getting top 10 cities)
        SELECT 
            C.city
        FROM customer A
        INNER JOIN address B ON A.address_id = B.address_id
        INNER JOIN city C ON B.city_id = C.city_id
        INNER JOIN country D ON C.country_id = D.country_id
        WHERE D.country IN (
            -- beginning of second subquery (getting top 10 countries)
            SELECT 
                D.country
            FROM customer A
            INNER JOIN address B ON A.address_id = B.address_id
            INNER JOIN city C ON B.city_id = C.city_id
            INNER JOIN country D ON C.country_id = D.country_id
            GROUP BY D.country
            ORDER BY COUNT(A.customer_id) DESC
            LIMIT 10
        ) -- end of second subquery (getting top 10 countries)
        GROUP BY C.city, D.country
        ORDER BY COUNT(A.customer_id) DESC
        LIMIT 10
    ) -- end of first subquery (getting top 10 cities)
    GROUP BY 
        A.customer_id, 
        A.first_name,
        A.last_name,
        C.city,
        D.country
    ORDER BY total_spent DESC
    LIMIT 5
) -- end of top5 cte

-- showing where the top 5 customers' countries are 
SELECT 
    D.country,
    COUNT(DISTINCT A.customer_id) AS all_customer_count,
    COUNT(DISTINCT top5cust.t5_customer_id) AS top_customer_count
FROM customer A
INNER JOIN address B ON A.address_id = B.address_id
INNER JOIN city C ON B.city_id = C.city_id
INNER JOIN country D ON C.country_id = D.country_id
LEFT JOIN top5cust ON A.customer_id = top5cust.t5_customer_id
GROUP BY D.country
ORDER BY top_customer_count DESC, 
    all_customer_count DESC;


-- Getting customer amount and total payments received from each country
SELECT D.country,
	SUM(E.amount) AS total_payment,
	COUNT(DISTINCT A.customer_id) AS customer_count
FROM customer A
INNER JOIN address B ON A.address_id = B.address_id
INNER JOIN city C ON B.city_id = C.city_id
INNER JOIN country D ON C.country_id = D.country_id
INNER JOIN payment E ON A.customer_id = E.customer_id
GROUP BY D.country
ORDER BY total_usd_generated DESC;

-- Checking average duration of film rentals by film genre
SELECT AVG(rental_duration) average_rental_length,
	C.name
FROM film F
INNER JOIN film_category FC ON F.film_id = FC.film_id
INNER JOIN category C ON FC.category_id = C.category_id
GROUP BY C.name
ORDER BY average_rental_length DESC;
	
