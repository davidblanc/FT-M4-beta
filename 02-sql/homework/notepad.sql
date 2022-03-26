-- Buscá todas las películas filmadas en el año que naciste.

SELECT name FROM movies WHERE year=1979;

-- Cuantas películas hay en la DB que sean del año 1982?

SELECT count(*) FROM movies WHERE year=1982;

-- Buscá actores que tengan el substring stack en su apellido.

SELECT first_name, last_name FROM actors WHERE last_name LIKE '%stack%';

-- Buscá los 10 nombres y apellidos más populares entre los actores. Cuantos actores tienen cada uno de esos nombres y apellidos? AMBOS A LA VEZ


SELECT first_name, last_name, COUNT(*) AS total
FROM actors
GROUP BY LOWER(first_name), LOWER(last_name)
ORDER BY total DESC
LIMIT 10;

-- Listá el top 100 de actores más activos junto con el número de roles que haya realizado.

SELECT first_name, last_name, COUNT(*) AS cant 
FROM actors
JOIN roles ON actors.id = roles.actor_id
GROUP BY first_name, last_name
ORDER BY cant DESC
LIMIT 10;

-- Cuantas películas tiene IMDB por género? Ordená la lista por el género menos popular.

SELECT genre, count(genre) as cant
FROM movies_genres
GROUP BY genre
ORDER BY cant DESC
LIMIT 10; 

-- Listá el nombre y apellido de todos los actores que trabajaron en la película "Braveheart" de 1995, ordená la lista alfabéticamente por apellido.

SELECT first_name, last_name
FROM actors 
JOIN roles ON actors.id = roles.actor_id
JOIN movies ON roles.movie_id = movies.id
WHERE movies.name = 'Braveheart' AND movies.year = 1995
ORDER BY last_name DESC;

-- Listá todos los directores que dirigieron una película de género 'Film-Noir' en un año bisiesto (para reducir la complejidad, asumí que cualquier año divisible por cuatro es bisiesto). Tu consulta debería devolver el nombre del director, el nombre de la peli y el año. Todo ordenado por el nombre de la película.


SELECT d.first_name, d.last_name, m.name, m.year
FROM directors AS d
JOIN movies_directors as md ON d.id = md.director_id
JOIN movies AS m ON m.id = md.movie_id
JOIN movies_genres as mg ON m.id = mg.movie_id
WHERE mg.genre = 'Film-Noir' AND m.year % 4 = 0
ORDER BY m.name;

-- Listá todos los actores que hayan trabajado con Kevin Bacon en películas de Drama (incluí el título de la peli). Excluí al señor Bacon de los resultados.

-- primer todas las películas donde trabajo KB

SELECT m.id 
FROM movies as m
JOIN roles as r ON m.id = r.movie_id
JOIN actors as a ON r.actor_id = a.id
WHERE a.first_name= 'Kevin' AND a.last_name= 'Bacon';

SELECT DISTINCT a.first_name, a.last_name
FROM actors as a
JOIN roles as r ON a.id = r.actor_id
JOIN movies as m ON r.movie_id = m.id
JOIN movies_genres as mg ON m.id = mg.movie_id
WHERE mg.genre = 'Drama' AND m.id IN (
SELECT m.id 
FROM movies as m
JOIN roles as r ON m.id = r.movie_id
JOIN actors as a ON r.actor_id = a.id
WHERE a.first_name= 'Kevin' AND a.last_name= 'Bacon'  
) AND (a.first_name || ' ' || a.last_name != 'Kevin Bacon')
ORDER BY a.last_name;


-- Qué actores actuaron en una película antes de 1900 y también en una película después del 2000?

-- actores antes de 1900

SELECT r.actor_id
FROM roles as r
JOIN movies as m ON r.movie_id = m.id
WHERE m.year < 1900

SELECT r.actor_id
FROM roles as r
JOIN movies as m ON r.movie_id = m.id
WHERE m.year > 2000

SELECT * 
FROM actors as a
WHERE id IN (
    SELECT r.actor_id
    FROM roles as r
    JOIN movies as m ON r.movie_id = m.id
    WHERE m.year < 1900
) AND id IN (
    SELECT r.actor_id
    FROM roles as r
    JOIN movies as m ON r.movie_id = m.id
    WHERE m.year > 2000
);


-- Buscá actores que actuaron en cinco o más roles en la misma película después del año 1990. Noten que los ROLES pueden tener duplicados ocasionales, sobre los cuales no estamos interesados: queremos actores que hayan tenido cinco o más roles DISTINTOS (DISTINCT cough cough) en la misma película. Escribí un query que retorne los nombres del actor, el título de la película y el número de roles (siempre debería ser > 5).


SELECT a.first_name, a.last_name, m.name, COUNT(DISTINCT role) as total_roles
FROM actors as a
JOIN roles as r ON a.id = r.actor_id
JOIN movies as m ON r.movie_id = m.id
WHERE m.year = 1900
GROUP BY a.id, m.id
HAVING total_roles > 5;


-- Para cada año, contá el número de películas en ese años que sólo tuvieron actrices femeninas.

SELECT r.movie_id
FROM roles as r
JOIN actors as a ON r.actor_id = a.id
WHERE a.gender = 'M'


SELECT year, COUNT(DISTINCT id) as total
FROM movies as m
WHERE id NOT IN (
    SELECT r.movie_id
    FROM roles as r
    JOIN actors as a ON r.actor_id = a.id
    WHERE a.gender = 'M'
)
GROUP BY year
ORDER BY year DESC;



-- SELECT first_name, count(first_name) as Cantidad FROM actors GROUP BY first_name order by cantidad desc LIMIT 15;



-- SELECT last_name, count(last_name) as Cantidad FROM actors GROUP BY last_name order by cantidad desc LIMIT 15;

-- SELECT first_name, count(first_name) as Cantidad FROM actors GROUP BY first_name order by cantidad desc LIMIT 15;




-- SELECT first_name, last_name FROM actors 
-- JOIN roles ON actors.id = roles.actor_id
-- JOIN 