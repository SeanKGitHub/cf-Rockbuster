-- Queries for checking the film and customer tables of Rockbuster data
-- Checks for duplicate rows, missing values and invalid/non-uniform values

    -- 'film' table
-- DUPLICATES  
SELECT film_id, 
    title, 
    description, 
    release_year, 
    language_id, 
    COUNT(*) 
FROM film 
GROUP BY film_id, 
    title, 
    description, 
    release_year, 
    language_id 
HAVING COUNT(*) > 1;

-- Selecting only unique observations
SELECT DISTINCT film_id, 
    title, 
    description, 
    release_year,
    language_id 
FROM film;

-- OUTLIERS
-- Checking film table for max and min values
SELECT MAX(release_year) max_release, 
    MIN(release_year) min_release, 
    MAX(language_id) max_lang, 
    MIN(language_id) min_lang 
FROM film;

-- NON-UNIFORM VALUES
-- Checking that all values of the rating column are one of the 5 valid responses
SELECT DISTINCT rating 
FROM film;

-- MISSING VALUES
SELECT * 
FROM film 
WHERE film_id IS NULL 
    OR title IS NULL 
    OR description IS NULL 
    OR release_year IS NULL 
    OR language_id IS NULL  
    OR rental_duration IS NULL 
    OR rental_rate IS NULL 
    OR replacement_cost IS NULL 
    OR rating IS NULL;

    -- 'customer' table
-- DUPLICATES
SELECT customer_id, 
    store_id, 
    first_name, 
    last_name, 
    email, 
    address_id, 
    COUNT(*) 
FROM customer 
GROUP BY customer_id, 
    store_id, 
    first_name, 
    last_name, 
    email, 
    address_id 
HAVING COUNT(*) > 1;

-- NON-UNIFORM VALUES
-- that all email addresses are in the form name@domain.domainExtension
SELECT customer_id, 
    email 
FROM customer 
WHERE email
    NOT LIKE '%@%.%'; 

-- MISSINGS
-- checking for missing values
SELECT COUNT(email) AS count_email, 
    COUNT(first_name) AS count_first, 
    COUNT(last_name) AS count_last, 
    COUNT(address_id) AS count_address, 
    COUNT(*) AS count_rows 
FROM customer;

