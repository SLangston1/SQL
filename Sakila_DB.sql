USE sakila;
#1a
SELECT first_name,last_name FROM actor;
#1b
SELECT UPPER(CONCAT(first_name,' ',last_name)) AS 'Actor Name'FROM actor;

#2a
SELECT actor_id,first_name,last_name FROM actor WHERE first_name = 'Joe';
#2b
SELECT first_name,last_name FROM actor WHERE last_name LIKE '%GEN%';
#2c
SELECT first_name,last_name FROM actor WHERE last_name LIKE '%LI%' ORDER BY last_name,first_name;
#2d
SELECT country_id,country FROM country WHERE country IN ('Afghanistan','Bangladesh','China');

#3a
ALTER TABLE actor
ADD COLUMN middle_name VARCHAR(45) AFTER first_name;
#3b
ALTER TABLE actor
CHANGE middle_name middle_name BLOB;
#3c
ALTER TABLE actor
DROP COLUMN middle_name;

#4a
SELECT last_name, COUNT(*) FROM actor GROUP BY last_name;
#4b
SELECT last_name, COUNT(*) FROM actor GROUP BY last_name HAVING COUNT(*) > 1;
#4c
UPDATE actor 
SET first_name = 'HARPO' 
WHERE last_name = 'WILLIAMS' AND first_name = 'GROUCHO';
#4d
UPDATE actor 
SET first_name = 
CASE WHEN first_name ='HARPO' 
     THEN 'MUCHO GROUCHO'
     ELSE first_name
END
WHERE actor_id = 172;

#5a
SHOW CREATE TABLE address;

#6a
SELECT s.first_name,s.last_name,a.address
FROM staff AS s
INNER JOIN address AS a
ON s.address_id = a.address_id;
#6b
SELECT s.first_name,s.last_name,SUM(p.amount)
FROM staff AS s
INNER JOIN payment AS p
ON s.staff_id = p.staff_id
WHERE month(p.payment_date) = 08 and year(p.payment_date) = 2005
GROUP BY s.staff_id;
#6c
SELECT f.title, COUNT(*) AS 'Actor Count'
FROM film AS f
INNER JOIN film_actor AS a
ON f.film_id = a.film_id
GROUP BY f.title;
#6d
SELECT f.title,COUNT(*) AS 'Inventory Count'
FROM film AS f
INNER JOIN inventory AS i
ON f.film_id = i.film_id
WHERE f.title = 'Hunchback Impossible';
#6e
SELECT c.first_name,c.last_name, SUM(p.amount) AS 'Total Payment'
FROM customer AS c
INNER JOIN payment AS p
ON c.customer_id = p.customer_id
GROUP BY c.customer_id
ORDER BY c.last_name;

#7a
SELECT f.title,f.language_id 
FROM film f
WHERE (f.title like 'K%' 
OR f.title like 'Q%')
AND f.language_id IN
(
SELECT language_id
FROM language
WHERE language_id = 1
);
#7b
SELECT first_name,last_name
FROM actor
WHERE actor_id IN
( 
 SELECT actor_id
 FROM film_actor
 WHERE film_id IN 
  (
   SELECT film_id 
   FROM film
   WHERE title = 'Alone Trip'
   )
);
#7c
SELECT cl.name, c.email
FROM customer_list AS cl
INNER JOIN customer AS c
ON c.customer_id = cl.id
WHERE cl.country = 'Canada';
#7d
SELECT title, description 
FROM film_list
WHERE category = 'Family';
#7e
SELECT f.title,COUNT(*) AS 'Rental Frequency'
FROM film AS f
INNER JOIN inventory AS i ON i.film_id = f.film_id
INNER JOIN rental AS r ON r.inventory_id = i.inventory_id
GROUP BY i.film_id
ORDER BY COUNT(*) DESC;
#7f
SELECT store, total_sales FROM sales_by_store;

SELECT i.store_id, SUM(p.amount) AS 'Total Sales'
FROM payment AS p
INNER JOIN rental AS r ON r.rental_id = p.rental_id
INNER JOIN inventory AS i ON i.inventory_id = r.inventory_id
GROUP BY i.store_id;
#7g
SELECT s.store_id, ct.city,co.country 
FROM store as s
INNER JOIN address AS a ON s.address_id = a.address_id
INNER JOIN city AS ct ON ct.city_id = a.city_id 
INNER JOIN country co ON co.country_id = ct.country_id;
#7h
SELECT c.name AS 'Genre', SUM(p.amount) AS 'Gross Revenue'
FROM film_category as fc
INNER JOIN category AS c ON c.category_id = fc.category_id
INNER JOIN inventory AS i ON i.film_id = fc.film_id
INNER JOIN rental AS r ON i.inventory_id = r.inventory_id
INNER JOIN payment AS p ON p.rental_id = r.rental_id
GROUP BY c.name
ORDER BY SUM(p.amount) desc
LIMIT 5;

#8a
CREATE  VIEW TopFiveGenres AS
SELECT c.name AS 'Genre', SUM(p.amount) AS 'Gross Revenue'
FROM film_category as fc
INNER JOIN category AS c ON c.category_id = fc.category_id
INNER JOIN inventory AS i ON i.film_id = fc.film_id
INNER JOIN rental AS r ON i.inventory_id = r.inventory_id
INNER JOIN payment AS p ON p.rental_id = r.rental_id
GROUP BY c.name
ORDER BY SUM(p.amount) desc
LIMIT 5;
#8b
SELECT * FROM TopFiveGenres;
#8c
DROP VIEW TopFiveGenres;
