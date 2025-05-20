-- DIFICULTAD: Muy fácil
-- 1- Devuelve todas las películas
SELECT * FROM movies;
-- 2- Devuelve todos los géneros existentes
SELECT * FROM genres;
-- 3- Devuelve la lista de todos los estudios de grabación que estén activos
SELECT * FROM studios WHERE  STUDIO_ACTIVE = 1;
-- 4- Devuelve una lista de los 20 últimos miembros en anotarse a la plataforma select top20
SELECT USER_ID, USER_NAME, USER_JOIN_DATE
FROM USERS
ORDER BY USER_JOIN_DATE DESC
LIMIT 20;

SELECT top 20 USER_ID, USER_NAME, USER_JOIN_DATE
FROM USERS
ORDER BY USER_JOIN_DATE DESC;
-- DIFICULTAD: Fácil
-- 5- Devuelve las 20 duraciones de películas más frecuentes, ordenados de mayor a menor
SELECT MOVIE_DURATION, COUNT(*) AS Frecuencia
FROM MOVIES
GROUP BY MOVIE_DURATION
ORDER BY Frecuencia DESC
LIMIT 20;
-- 6- Devuelve las películas del año 2000 en adelante que empiecen por la letra A.
SELECT MOVIE_NAME, MOVIE_RELEASE_DATE
FROM MOVIES
WHERE MOVIE_NAME LIKE 'A%'
AND YEAR(MOVIE_RELEASE_DATE) >= 2000;

-- 7- Devuelve los actores nacidos un mes de Junio
SELECT actor_name, actor_birth_date FROM actors WHERE Month(actor_birth_date) = 6;

-- 8- Devuelve los actores nacidos cualquier mes que no sea Junio y que sigan vivos
SELECT actor_name, actor_birth_date , actor_dead_date FROM actors WHERE Month(actor_birth_date) <> 6 AND actor_dead_date IS null;
-- 9- Devuelve el nombre y la edad de todos los directores menores o iguales de 50 años que estén vivos
 -- Filtra aún más para incluir solo a los directores donde la fecha de defunción es nula (es decir, están vivos).
-- cast para si es un numero lo convierta en fecha para hacer la comprobación que queramos o tb se puede extraer si es un afecha para convertirlo en numero 
-- tb el strackt con year from
SELECT d.director_name, DATEDIFF(YEAR, d.director_birth_date, CURDATE()) AS edad 
FROM PUBLIC.PUBLIC.directors d 
WHERE DATEDIFF(YEAR, d.director_birth_date, CURDATE())<=50 AND director_dead_date IS NULL;
-- Timestamp es solo para tb horas 
-- 10- Devuelve el nombre y la edad de todos los actores menores de 50 años que hayan fallecido
SELECT actor_name, DATEDIFF(YEAR, actor_birth_date, actor_dead_date) AS edad FROM actors 
WHERE (DATEDIFF(YEAR, actor_birth_date, actor_dead_date) < 50) AND actor_dead_date IS NOT NULL;

-- 11- Devuelve el nombre de todos los directores menores o iguales de 40 años que estén vivos
SELECT d.DIRECTOR_NAME 
FROM PUBLIC.PUBLIC.DIRECTORS d 
WHERE datediff(YEAR, d.DIRECTOR_BIRTH_DATE, CURDATE())<=40 AND d.DIRECTOR_DEAD_DATE IS null;

-- 12- Indica la edad media de los directores vivos
SELECT avg(datediff(YEAR, d.DIRECTOR_BIRTH_DATE, CURDATE()))
FROM PUBLIC.PUBLIC.DIRECTORS d 
WHERE DIRECTOR_DEAD_DATE IS NULL;

-- 13- Indica la edad media de los actores que han fallecido
SELECT avg(datediff(YEAR, d.DIRECTOR_BIRTH_DATE, CURDATE()))
FROM PUBLIC.PUBLIC.DIRECTORS d 
WHERE DIRECTOR_DEAD_DATE IS not NULL;



-- DIFICULTAD: Media
-- 14- Devuelve el nombre de todas las películas y el nombre del estudio que las ha realizado
-- la tabla mas grande con mas datos primero
SELECT m.MOVIE_NAME, s.STUDIO_NAME
FROM MOVIES m
INNER JOIN STUDIOS s ON m.STUDIO_ID = s.STUDIO_ID;
-- 15- Devuelve los miembros que accedieron al menos una película entre el año 2010 y el 2015
SELECT DISTINCT u.USER_ID, u.USER_NAME
FROM USERS u
JOIN USER_MOVIE_ACCESS uma ON u.USER_ID = uma.USER_ID
WHERE uma.ACCESS_DATE LIKE '2010-%'
   OR uma.ACCESS_DATE LIKE '2011-%'
   OR uma.ACCESS_DATE LIKE '2012-%'
   OR uma.ACCESS_DATE LIKE '2013-%'
   OR uma.ACCESS_DATE LIKE '2014-%'
   OR uma.ACCESS_DATE LIKE '2015-%';
-- 16- Devuelve cuantas películas hay de cada país
SELECT n.NATIONALITY_NAME, COUNT(m.MOVIE_ID) AS NumeroPeliculas
FROM MOVIES m
INNER JOIN NATIONALITIES n ON m.NATIONALITY_ID = n.NATIONALITY_ID
GROUP BY n.NATIONALITY_NAME
ORDER BY NumeroPeliculas DESC;
-- 17- Devuelve todas las películas que hay de género documental
SELECT m.MOVIE_NAME
FROM MOVIES m
JOIN GENRES g ON m.GENRE_ID = g.GENRE_ID
WHERE g.GENRE_NAME = 'Documentary';


-- 18- Devuelve todas las películas creadas por directores nacidos a partir de 1980 y que todavía están vivos
SELECT m.MOVIE_NAME, d.director_name, DIRECTOR_BIRTH_DATE, d.DIRECTOR_DEAD_DATE 
FROM MOVIES m
INNER JOIN DIRECTORS d ON m.DIRECTOR_ID = d.DIRECTOR_ID
WHERE YEAR(d.DIRECTOR_BIRTH_DATE) >= 1980
  AND d.DIRECTOR_DEAD_DATE IS NULL;

-- 19- Indica si hay alguna coincidencia de nacimiento de ciudad (y si las hay, indicarlas) entre los miembros de la plataforma y los directores
SELECT DISTINCT u.USER_TOWN AS Ciudad_Usuario, d.DIRECTOR_BIRTH_PLACE AS Ciudad_Director
FROM USERS u
JOIN DIRECTORS d ON u.USER_TOWN = d.DIRECTOR_BIRTH_PLACE
WHERE u.USER_TOWN IS NOT NULL AND d.DIRECTOR_BIRTH_PLACE IS NOT NULL;

-- Para indicar si hay alguna coincidencia (sin listar las ciudades):para encontrar las ciudades que aparecen en ambas tablas y luego cuenta si hay alguna.
SELECT CASE WHEN COUNT(*) > 0 THEN 'Sí' ELSE 'No' END AS Hay_Coincidencia
FROM (
    SELECT DISTINCT USER_TOWN FROM USERS WHERE USER_TOWN IS NOT NULL
    INTERSECT
    SELECT DISTINCT DIRECTOR_BIRTH_PLACE FROM DIRECTORS WHERE DIRECTOR_BIRTH_PLACE IS NOT NULL
);
-- 20- Devuelve el nombre y el año de todas las películas que han sido producidas por un estudio que actualmente no esté activo
SELECT m.MOVIE_NAME, YEAR(m.MOVIE_RELEASE_DATE) AS Anio_Lanzamiento
FROM MOVIES m
INNER JOIN STUDIOS s ON m.STUDIO_ID = s.STUDIO_ID
WHERE s.STUDIO_ACTIVE = 0;
-- 21- Devuelve una lista de las últimas 10 películas a las que se ha accedido
SELECT m.MOVIE_NAME, uma.ACCESS_DATE
FROM USER_MOVIE_ACCESS uma
JOIN MOVIES m ON uma.MOVIE_ID = m.MOVIE_ID
ORDER BY uma.ACCESS_DATE DESC
LIMIT 10;
-- 22- Indica cuántas películas ha realizado cada director antes de cumplir 41 años
SELECT d.DIRECTOR_NAME, COUNT(m.MOVIE_ID) AS Numero_Peliculas
FROM DIRECTORS d
JOIN MOVIES m ON d.DIRECTOR_ID = m.DIRECTOR_ID
WHERE YEAR(m.MOVIE_RELEASE_DATE) < YEAR(d.DIRECTOR_BIRTH_DATE)  41
GROUP BY d.DIRECTOR_NAME;
-- 23- Indica cuál es la media de duración de las películas de cada director
SELECT d.DIRECTOR_NAME, AVG(m.MOVIE_DURATION) AS Duracion_Media
FROM DIRECTORS d
JOIN MOVIES m ON d.DIRECTOR_ID = m.DIRECTOR_ID
GROUP BY d.DIRECTOR_NAME;
-- 24- Indica cuál es la el nombre y la duración mínima de las películas a las que se ha accedido en los últimos 2 años por los miembros del plataforma (La “fecha de ejecución” de esta consulta es el 25-01-2019)

SELECT MOVIE_NAME, MOVIE_DURATION FROM MOVIES WHERE MOVIE_DURATION =
(SELECT MIN(m.MOVIE_DURATION) AS Duracion_Minima
FROM USER_MOVIE_ACCESS uma
JOIN MOVIES m ON uma.MOVIE_ID = m.MOVIE_ID
WHERE uma.ACCESS_DATE >= DATE '2017-01-25' AND uma.ACCESS_DATE <= DATE '2019-01-25');

-- 25- Indica el número de películas que hayan hecho los directores durante las décadas de los 60, 70 y 80 que contengan la palabra “The” en cualquier parte del título
SELECT d.DIRECTOR_NAME, COUNT(m.MOVIE_ID) AS Numero_Peliculas
FROM DIRECTORS d
JOIN MOVIES m ON d.DIRECTOR_ID = m.DIRECTOR_ID
WHERE (YEAR(m.MOVIE_RELEASE_DATE) BETWEEN 1960 AND 1969
   OR YEAR(m.MOVIE_RELEASE_DATE) BETWEEN 1970 AND 1979
   OR YEAR(m.MOVIE_RELEASE_DATE) BETWEEN 1980 AND 1989)
  AND LOWER(m.MOVIE_NAME) LIKE '%the%'
GROUP BY d.DIRECTOR_NAME;


-- DIFICULTAD: Difícil
-- 26- Lista nombre, nacionalidad y director de todas las películas
SELECT
    m.MOVIE_NAME AS NombrePelicula,
    n.NATIONALITY_NAME AS NacionalidadPelicula,
    d.DIRECTOR_NAME AS NombreDirector
FROM
    MOVIES m
JOIN
    NATIONALITIES n ON m.NATIONALITY_ID = n.NATIONALITY_ID
JOIN
    DIRECTORS d ON m.DIRECTOR_ID = d.DIRECTOR_ID;
-- 27- Muestra las películas con los actores que han participado en cada una de ellas
SELECT
    m.MOVIE_NAME AS NombrePelicula,
    a.ACTOR_NAME AS ActorParticipante
FROM
    MOVIES m
JOIN
    MOVIES_ACTORS ma ON m.MOVIE_ID = ma.MOVIE_ID
JOIN
    ACTORS a ON ma.ACTOR_ID = a.ACTOR_ID;
-- 28- Indica cual es el nombre del director del que más películas se ha accedido
SELECT
    d.DIRECTOR_NAME AS DirectorMasAccesos
FROM
    DIRECTORS d
JOIN
    MOVIES m ON d.DIRECTOR_ID = m.DIRECTOR_ID
JOIN
    USER_MOVIE_ACCESS uma ON m.MOVIE_ID = uma.MOVIE_ID
GROUP BY
    d.DIRECTOR_NAME
HAVING
    COUNT(uma.MOVIE_ID) = (
        SELECT
            MAX(AccessCount)
        FROM (
            SELECT
                COUNT(uma2.MOVIE_ID) AS AccessCount
            FROM
                DIRECTORS d2
            JOIN
                MOVIES m2 ON d2.DIRECTOR_ID = m2.DIRECTOR_ID
            JOIN
                USER_MOVIE_ACCESS uma2 ON m2.MOVIE_ID = uma2.MOVIE_ID
            GROUP BY
                d2.DIRECTOR_NAME
        ) AS DirectorAccessCounts
    );
-- 29- Indica cuantos premios han ganado cada uno de los estudios con las películas que han creado
SELECT
    s.STUDIO_NAME AS NombreEstudio,
    SUM(aw.AWARD_WIN) AS PremiosGanados
FROM
    STUDIOS s
JOIN
    MOVIES m ON s.STUDIO_ID = m.STUDIO_ID
JOIN
    AWARDS aw ON m.MOVIE_ID = aw.MOVIE_ID
GROUP BY
    s.STUDIO_NAME
ORDER BY
    PremiosGanados DESC;
-- 30- Indica el número de premios a los que estuvo nominado un actor, pero que no ha conseguido 
-- (Si una película está nominada a un premio, su actor también lo está)


SELECT
    a.ACTOR_NAME AS NombreActor,
    SUM(aw.AWARD_ALMOST_WIN) AS NominacionesPerdidas
FROM
    ACTORS a
JOIN
    MOVIES_ACTORS ma ON a.ACTOR_ID = ma.ACTOR_ID
JOIN
    MOVIES m ON ma.MOVIE_ID = m.MOVIE_ID
JOIN
    AWARDS aw ON m.MOVIE_ID = aw.MOVIE_ID
--WHERE
    --aw.AWARD_WIN = 0
GROUP BY
    a.ACTOR_NAME
ORDER BY
    NominacionesPerdidas DESC;
-- 31- Indica cuantos actores y directores hicieron películas para los estudios no activos en general de los estudios

SELECT
    'Actores' AS Rol,
    COUNT(DISTINCT a.ACTOR_ID) AS NumeroActores  
FROM
    ACTORS a
JOIN
    MOVIES_ACTORS ma ON a.ACTOR_ID = ma.ACTOR_ID
JOIN
    MOVIES m ON ma.MOVIE_ID = m.MOVIE_ID
JOIN
    STUDIOS s ON m.STUDIO_ID = s.STUDIO_ID
WHERE
    s.STUDIO_ACTIVE = 0

UNION ALL

SELECT
    'Directores' AS Rol,
    COUNT(DISTINCT d.DIRECTOR_ID) AS NumeroPersonas
FROM
    DIRECTORS d
JOIN
    MOVIES m ON d.DIRECTOR_ID = m.DIRECTOR_ID
JOIN
    STUDIOS s ON m.STUDIO_ID = s.STUDIO_ID
WHERE
    s.STUDIO_ACTIVE = 0;


-- 32- Indica el nombre, ciudad, y teléfono de todos los miembros de la plataforma que hayan accedido 
-- películas que hayan sido nominadas a más de 150 premios y ganaran menos de 50
SELECT DISTINCT
    u.USER_NAME AS NombreMiembro,
    u.USER_TOWN AS CiudadMiembro,
    u.USER_PHONE AS TelefonoMiembro
FROM
    USERS u
JOIN
    USER_MOVIE_ACCESS uma ON u.USER_ID = uma.USER_ID
JOIN
    MOVIES m ON uma.MOVIE_ID = m.MOVIE_ID
JOIN
    AWARDS aw ON m.MOVIE_ID = aw.MOVIE_ID
WHERE
    m.MOVIE_ID IN (SELECT MOVIE_ID from AWARDS WHERE AWARD_NOMINATION  > 150 AND AWARD_WIN < 50);
-- 33- Comprueba si hay errores en la BD entre las películas y directores (un director muerto en el 76 no puede dirigir una película en el 88)
SELECT
    d.DIRECTOR_NAME AS NombreDirector,
    d.DIRECTOR_DEAD_DATE AS FechaFallecimientoDirector,
    m.MOVIE_NAME AS NombrePelicula,
    m.MOVIE_RELEASE_DATE AS FechaLanzamientoPelicula
FROM
    DIRECTORS d
JOIN
    MOVIES m ON d.DIRECTOR_ID = m.DIRECTOR_ID
WHERE
    d.DIRECTOR_DEAD_DATE IS NOT NULL AND YEAR(d.DIRECTOR_DEAD_DATE) < YEAR(m.MOVIE_RELEASE_DATE)
ORDER BY
    d.DIRECTOR_NAME;
-- 34- Utilizando la información de la sentencia anterior, modifica la fecha de defunción a un año más tarde del estreno de la película (mediante sentencia SQL)
UPDATE PUBLIC.PUBLIC.DIRECTORS di
SET di.DIRECTOR_DEAD_DATE = TIMESTAMPADD(YEAR, 1, 
    (SELECT m.MOVIE_RELEASE_DATE 
     FROM PUBLIC.PUBLIC.MOVIES m 
     WHERE m.DIRECTOR_ID = di.DIRECTOR_ID 
     ORDER BY m.MOVIE_RELEASE_DATE DESC 
     LIMIT 1)
)
WHERE di.DIRECTOR_ID = (SELECT director_id FROM PUBLIC.PUBLIC.MOVIES mo INNER JOIN PUBLIC.PUBLIC.DIRECTORS dir ON m.DIRECTOR_ID =dir.DIRECTOR_ID WHERE dir.DIRECTOR_DEAD_DATE IS NOT NULL AND dir.DIRECTOR_DEAD_DATE < mo.MOVIE_RELEASE_DATE ) ; 

/*UPDATE DIRECTORS
SET DIRECTOR_DEAD_DATE = DATEADD('YEAR', 1, m.MOVIE_RELEASE_DATE)
FROM MOVIES m
WHERE DIRECTORS.DIRECTOR_ID = m.MOVIE_ID
  AND DIRECTORS.DIRECTOR_DEAD_DATE IS NOT NULL
  AND YEAR(DIRECTORS.DIRECTOR_DEAD_DATE) < YEAR(m.MOVIE_RELEASE_DATE);*/

SELECT m.MOVIE_RELEASE_DATE FROM PUBLIC.PUBLIC.MOVIES m INNER JOIN PUBLIC.PUBLIC.DIRECTORS d ON m.DIRECTOR_ID =d.DIRECTOR_ID 
WHERE d.DIRECTOR_DEAD_DATE IS NOT NULL AND d.DIRECTOR_DEAD_DATE < m.MOVIE_RELEASE_DATE 
ORDER BY m.MOVIE_RELEASE_DATE DESC LIMIT 1;

UPDATE PUBLIC.PUBLIC.DIRECTORS di
SET di.DIRECTOR_DEAD_DATE = DATEADD(YEAR, 1,
    (SELECT m.MOVIE_RELEASE_DATE
     FROM PUBLIC.PUBLIC.MOVIES m
     WHERE m.DIRECTOR_ID = di.DIRECTOR_ID
     ORDER BY m.MOVIE_RELEASE_DATE DESC
     LIMIT 1)
)
WHERE di.DIRECTOR_ID = (SELECT director_id FROM PUBLIC.PUBLIC.MOVIES mo INNER JOIN PUBLIC.PUBLIC.DIRECTORS dir ON m.DIRECTOR_ID =dir.DIRECTOR_ID WHERE dir.DIRECTOR_DEAD_DATE IS NOT NULL AND dir.DIRECTOR_DEAD_DATE < mo.MOVIE_RELEASE_DATE ) ;



-- DIFICULTAD: Berserk mode (enunciados simples, mucha diversión…)
-- 35- Indica cuál es el género favorito de cada uno de los directores cuando dirigen una película
-- asumiendo que el mas repetido es el que mas le gusta

SELECT d.DIRECTOR_NAME, mo.genre_id FROM PUBLIC.PUBLIC.DIRECTORS d INNER JOIN PUBLIC.PUBLIC.MOVIES mo ON mo.DIRECTOR_ID = d.DIRECTOR_ID WHERE mo.genre_id = SELECT mov.genre_id FROM pu;  

SELECT  m.GENRE_ID , count(m.GENRE_ID) FROM PUBLIC.PUBLIC.MOVIES m INNER JOIN PUBLIC.PUBLIC.GENRES g ON g.GENRE_ID = m.GENRE_ID  GROUP BY (g.GENRE_NAME) ORDER BY (count(m.GENRE_ID)) DESC LIMIT 1;
-- 36- Indica cuál es la nacionalidad favorita de cada uno de los estudios en la producción de las películas
-- 37- Indica cuál fue la primera película a la que accedieron los miembros de la plataforma cuyos teléfonos tengan como último dígito el ID de alguna nacionalidad









-- shutdown














