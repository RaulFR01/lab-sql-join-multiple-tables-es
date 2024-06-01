use sakila;

show tables;

-- Consulta 1
-- Escribe una consulta para mostrar para cada tienda su ID de tienda, ciudad y país.

SELECT
	s.store_id,
    c.city,
    p.country
FROM
	store s
JOIN
	address a
ON
	s.address_id = a.address_id
JOIN
	city c
ON 
	a.city_id = c.city_id
JOIN 
	country p
ON
	c.country_id = p.country_id;

-- Consulta 2
-- Escribe una consulta para mostrar cuánto negocio, en dólares, trajo cada tienda.

SELECT
	s.store_id,
    SUM(p.amount)
FROM
	store s
JOIN
	customer c
ON
	s.store_id = c.store_id
JOIN
	payment p
ON 
	c.customer_id = p.customer_id
GROUP BY s.store_id;

-- Consulta 3
-- ¿Cuál es el tiempo de ejecución promedio de las películas por categoría?

SELECT 
	c.name,
    AVG(f.length) AS 'Tiempo promedio'
FROM 
	film f
JOIN 
	film_category fc
ON 
	f.film_id = fc.film_id
JOIN 
	category c
ON
	fc.category_id = c.category_id
GROUP BY c.name
ORDER BY AVG(f.length) DESC;

-- Consulta 4
-- ¿Qué categorías de películas son las más largas?

SELECT 
	c.name,
    AVG(f.length) AS 'Tiempo promedio'
FROM 
	film f
JOIN 
	film_category fc
ON 
	f.film_id = fc.film_id
JOIN 
	category c
ON
	fc.category_id = c.category_id
GROUP BY c.name
ORDER BY AVG(f.length) DESC
LIMIT 3;

-- Consulta 5
-- Muestra las películas más alquiladas en orden descendente.

SELECT 
	ft.title,
    COUNT(r.rental_id) AS 'Numero de alquileres'
FROM 
	film f
JOIN 
	film_text ft
ON 
	f.film_id = ft.film_id
JOIN 
	inventory i
ON
	f.film_id = i.film_id
JOIN
	rental r
ON 
	r.inventory_id = i.inventory_id
GROUP BY ft.title
ORDER BY COUNT(r.rental_id) DESC
LIMIT 3;

-- Consulta 6
-- Enumera los cinco principales géneros en ingresos brutos en orden descendente.

SELECT 
    c.name,
    SUM(sub.amount) AS 'Ingresos brutos'
FROM 
    category c
JOIN 
    film_category fc 
ON 
	c.category_id = fc.category_id
JOIN 
    film f 
ON 
	fc.film_id = f.film_id
JOIN 
    inventory i 
ON 
	f.film_id = i.film_id
JOIN (
    SELECT 
        r.inventory_id,
        p.amount
    FROM 
        rental r
    JOIN 
        payment p ON r.rental_id = p.rental_id
) sub 
ON 
	i.inventory_id = sub.inventory_id
GROUP BY 
    c.name
ORDER BY 
    SUM(sub.amount) DESC
LIMIT 3;

-- Consulta 7
-- ¿Está "Academy Dinosaur" disponible para alquilar en la Tienda 1?

SELECT 
	f.title,
	 IF(fm.inventory_id IS NOT NULL, 'Disponible', 'No Disponible') AS disponibilidad
FROM 
	film f
LEFT JOIN (
    select i.film_id, i.inventory_id
    from inventory i
    
    left join rental r
    on i.inventory_id = r.inventory_id AND r.return_date IS NULL
    where i.store_id = 1
) fm
ON f.film_id = fm.film_id
WHERE f.title = 'Academy Dinosaur';


