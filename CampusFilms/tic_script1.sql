-- DIFICULTAD: Muy fácil
-- 1- Devuelve todas las películas
SELECT * FROM movies;
-- 2- Devuelve todos los géneros existentes
SELECT * FROM genres;
-- 3- Devuelve la lista de todos los estudios de grabación que estén activos
SELECT * FROM studios WHERE  STUDIO_ACTIVE = 1;
-- 4- Devuelve una lista de los 20 últimos miembros en anotarse a la plataforma select top20
SELECT USER_ID AS ID, USER_NAME AS NAME, USER_JOIN_DATE AS DATE
FROM USERS
ORDER BY USER_JOIN_DATE DESC
LIMIT 20;

SELECT top 20 USER_ID, USER_NAME, USER_JOIN_DATE
FROM USERS
ORDER BY USER_JOIN_DATE DESC;
-- DIFICULTAD: Fácil
-- 5- Devuelve las 20 duraciones de películas más frecuentes, ordenados de mayor a menor
SELECT MOVIE_DURATION, COUNT(*) AS FREQUENCY
FROM MOVIES
GROUP BY MOVIE_DURATION
ORDER BY FREQUENCY DESC
LIMIT 20;
-- 6- Devuelve las películas del año 2000 en adelante que empiecen por la letra A.
SELECT MOVIE_NAME, MOVIE_RELEASE_DATE
FROM MOVIES
WHERE MOVIE_NAME LIKE 'A%'
AND YEAR(MOVIE_RELEASE_DATE) >= 2000;

-- 7- Devuelve los actores nacidos un mes de Junio
SELECT actor_name AS NAME , actor_birth_date AS BIRTHDAY FROM actors WHERE Month(actor_birth_date) = 6;

-- 8- Devuelve los actores nacidos cualquier mes que no sea Junio y que sigan vivos
SELECT actor_name, actor_birth_date , actor_dead_date FROM actors WHERE Month(actor_birth_date) <> 6 AND actor_dead_date IS null;
-- 9- Devuelve el nombre y la edad de todos los directores menores o iguales de 50 años que estén vivos
 -- Filtra aún más para incluir solo a los directores donde la fecha de defunción es nula (es decir, están vivos).
-- cast para si es un numero lo convierta en fecha para hacer la comprobación que queramos o tb se puede extraer si es un afecha para convertirlo en numero 
-- tb el strackt con year from
SELECT d.director_name AS NAME, DATEDIFF(YEAR, d.director_birth_date, today()) AS AGE 
FROM PUBLIC.PUBLIC.directors d 
WHERE DATEDIFF(YEAR, d.director_birth_date, today())<=50 AND director_dead_date IS NULL;
-- Timestamp es solo para tb horas 
-- 10- Devuelve el nombre y la edad de todos los actores menores de 50 años que hayan fallecido
SELECT actor_name, DATEDIFF(YEAR, actor_birth_date, actor_dead_date) AS Age FROM actors 
WHERE (DATEDIFF(YEAR, actor_birth_date, actor_dead_date) < 50) AND actor_dead_date IS NOT NULL;

-- 11- Devuelve el nombre de todos los directores menores o iguales de 40 años que estén vivos
SELECT d.DIRECTOR_NAME AS NAME
FROM PUBLIC.PUBLIC.DIRECTORS d 
WHERE datediff(YEAR, d.DIRECTOR_BIRTH_DATE, today())<=40 AND d.DIRECTOR_DEAD_DATE IS null;

-- 12- Indica la edad media de los directores vivos
SELECT avg(datediff(YEAR, d.DIRECTOR_BIRTH_DATE, CURDATE())) 
FROM PUBLIC.PUBLIC.DIRECTORS d 
WHERE DIRECTOR_DEAD_DATE IS NULL;

-- 13- Indica la edad media de los actores que han fallecido
SELECT avg(DATEDIFF(YEAR, a.ACTOR_BIRTH_DATE, a.ACTOR_DEAD_DATE))
FROM ACTORS a
WHERE ACTOR_DEAD_DATE IS NOT NULL;



-- DIFICULTAD: Media
-- 14- Devuelve el nombre de todas las películas y el nombre del estudio que las ha realizado
-- la tabla mas grande con mas datos primero
SELECT m.MOVIE_NAME AS MOVIE, s.STUDIO_NAME AS STUDIO
FROM MOVIES m
INNER JOIN STUDIOS s ON m.STUDIO_ID = s.STUDIO_ID;
-- 15- Devuelve los miembros que accedieron al menos una película entre el año 2010 y el 2015
SELECT DISTINCT u.USER_ID AS ID, u.USER_NAME AS NAME
FROM USERS u
JOIN USER_MOVIE_ACCESS uma ON u.USER_ID = uma.USER_ID
WHERE uma.ACCESS_DATE LIKE '2010-%'
   OR uma.ACCESS_DATE LIKE '2011-%'
   OR uma.ACCESS_DATE LIKE '2012-%'
   OR uma.ACCESS_DATE LIKE '2013-%'
   OR uma.ACCESS_DATE LIKE '2014-%'
   OR uma.ACCESS_DATE LIKE '2015-%';


-- 16- Devuelve cuantas películas hay de cada país
SELECT n.NATIONALITY_NAME AS NATIONALITY, COUNT(m.MOVIE_ID) AS NUM_MOVIES
FROM MOVIES m
INNER JOIN NATIONALITIES n ON m.NATIONALITY_ID = n.NATIONALITY_ID
GROUP BY n.NATIONALITY_NAME
ORDER BY NUM_MOVIES DESC;

-- 17- Devuelve todas las películas que hay de género documental
SELECT m.MOVIE_NAME AS MOVIE
FROM MOVIES m
JOIN GENRES g ON m.GENRE_ID = g.GENRE_ID
WHERE g.GENRE_NAME = 'Documentary';


-- 18- Devuelve todas las películas creadas por directores nacidos a partir de 1980 y que todavía están vivos
SELECT m.MOVIE_NAME AS MOVIE, d.director_name AS DIRECTOR, DIRECTOR_BIRTH_DATE AS DIRECTOR_BIRTHDAY, d.DIRECTOR_DEAD_DATE  AS DIRECTOR_DEADDAY
FROM MOVIES m
INNER JOIN DIRECTORS d ON m.DIRECTOR_ID = d.DIRECTOR_ID
WHERE YEAR(d.DIRECTOR_BIRTH_DATE) >= 1980
  AND d.DIRECTOR_DEAD_DATE IS NULL;

-- 19- Indica si hay alguna coincidencia de nacimiento de ciudad (y si las hay, indicarlas) entre los miembros de la plataforma y los directores
SELECT DISTINCT u.USER_TOWN AS TOWN_USER, d.DIRECTOR_BIRTH_PLACE AS TOWN_DIRECTOR
FROM USERS u
JOIN DIRECTORS d ON u.USER_TOWN = d.DIRECTOR_BIRTH_PLACE
WHERE u.USER_TOWN IS NOT NULL AND d.DIRECTOR_BIRTH_PLACE IS NOT NULL;

-- Para indicar si hay alguna coincidencia (sin listar las ciudades):para encontrar las ciudades que aparecen en ambas tablas y luego cuenta si hay alguna.
SELECT CASE WHEN COUNT(*) > 0 THEN 'Sí' ELSE 'No' END AS EXISTS_SIMILAR
FROM (
    SELECT DISTINCT USER_TOWN FROM USERS WHERE USER_TOWN IS NOT NULL
    INTERSECT
    SELECT DISTINCT DIRECTOR_BIRTH_PLACE FROM DIRECTORS WHERE DIRECTOR_BIRTH_PLACE IS NOT NULL
);

-- 20- Devuelve el nombre y el año de todas las películas que han sido producidas por un estudio que actualmente no esté activo
SELECT m.MOVIE_NAME, YEAR(m.MOVIE_RELEASE_DATE) AS YEAR_RELEASE
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

SELECT
    d.DIRECTOR_NAME,
    COUNT(m.MOVIE_ID) AS Num_Movies
FROM
    DIRECTORS d
JOIN
    MOVIES m ON d.DIRECTOR_ID = m.DIRECTOR_ID
WHERE
    m.MOVIE_RELEASE_DATE < DATEADD('YEAR', 41, d.DIRECTOR_BIRTH_DATE)
GROUP BY
    d.DIRECTOR_NAME;


-- 23- Indica cuál es la media de duración de las películas de cada director
SELECT d.DIRECTOR_NAME, AVG(m.MOVIE_DURATION) AS AVG_DURATION
FROM DIRECTORS d
JOIN MOVIES m ON d.DIRECTOR_ID = m.DIRECTOR_ID
GROUP BY d.DIRECTOR_NAME
ORDER BY DIRECTOR_NAME;

-- 24- Indica cuál es la el nombre y la duración mínima de las películas a las que se ha accedido en los últimos 2 años por los miembros del plataforma (La “fecha de ejecución” de esta consulta es el 25-01-2019)

SELECT MOVIE_NAME, MOVIE_DURATION FROM MOVIES WHERE MOVIE_DURATION IN
(SELECT MIN(m.MOVIE_DURATION) AS Duracion_Minima
FROM USER_MOVIE_ACCESS uma
JOIN MOVIES m ON uma.MOVIE_ID = m.MOVIE_ID
WHERE uma.ACCESS_DATE >= DATE '2017-01-25' AND uma.ACCESS_DATE <= DATE '2019-01-25');


-- 25- Indica el número de películas que hayan hecho los directores durante las décadas de los 60, 70 y 80 que contengan la palabra “The” en cualquier parte del título
SELECT d.DIRECTOR_NAME, COUNT(m.MOVIE_ID) AS NUM_MOVIES
FROM DIRECTORS d
JOIN MOVIES m ON d.DIRECTOR_ID = m.DIRECTOR_ID
WHERE (YEAR(m.MOVIE_RELEASE_DATE) BETWEEN 1960 AND 1989)
  AND LOWER(m.MOVIE_NAME) LIKE '%the%'
GROUP BY d.DIRECTOR_NAME;


-- DIFICULTAD: Difícil
-- 26- Lista nombre, nacionalidad y director de todas las películas
SELECT
    m.MOVIE_NAME ,
    n.NATIONALITY_NAME ,
    d.DIRECTOR_NAME 
FROM
    MOVIES m
JOIN
    NATIONALITIES n ON m.NATIONALITY_ID = n.NATIONALITY_ID
JOIN
    DIRECTORS d ON m.DIRECTOR_ID = d.DIRECTOR_ID;

-- 27- Muestra las películas con los actores que han participado en cada una de ellas
SELECT
    m.MOVIE_NAME ,
    GROUP_CONCAT(a.ACTOR_NAME)
FROM
    MOVIES m
JOIN
    MOVIES_ACTORS ma ON m.MOVIE_ID = ma.MOVIE_ID
JOIN
    ACTORS a ON ma.ACTOR_ID = a.ACTOR_ID
GROUP BY(m.MOVIE_NAME);

-- 28- Indica cual es el nombre del director del que más películas se ha accedido
SELECT
    d.DIRECTOR_NAME
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
    s.STUDIO_NAME AS NAME_studio,
    SUM(aw.AWARD_WIN) AS AWARDS_WIN
FROM
    STUDIOS s
JOIN
    MOVIES m ON s.STUDIO_ID = m.STUDIO_ID
JOIN
    AWARDS aw ON m.MOVIE_ID = aw.MOVIE_ID
GROUP BY
    s.STUDIO_NAME
ORDER BY
    AWARDS_WIN DESC;

-- 30- Indica el número de premios a los que estuvo nominado un actor, pero que no ha conseguido 
-- (Si una película está nominada a un premio, su actor también lo está)

SELECT
    a.ACTOR_NAME ,
    SUM(aw.AWARD_ALMOST_WIN) 
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
    SUM(aw.AWARD_ALMOST_WIN) DESC;

-- 31- Indica cuantos actores y directores hicieron películas para los estudios no activos en general de los estudios

SELECT
    'Actors' AS Rol,
    COUNT(DISTINCT a.ACTOR_ID) AS NUMBER_ACTORS  
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
    'Directors' AS Rol,
    COUNT(DISTINCT d.DIRECTOR_ID) AS NUMBER_DIRECTORS
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
    u.USER_NAME ,
    u.USER_TOWN ,
    u.USER_PHONE 
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
    d.DIRECTOR_NAME,
    d.DIRECTOR_DEAD_DATE,
    m.MOVIE_NAME,
    m.MOVIE_RELEASE_DATE
FROM
    DIRECTORS d
JOIN
    MOVIES m ON d.DIRECTOR_ID = m.DIRECTOR_ID
WHERE
    d.DIRECTOR_DEAD_DATE IS NOT NULL
    AND m.MOVIE_RELEASE_DATE = (
        SELECT
            MAX(m2.MOVIE_RELEASE_DATE)
        FROM
            MOVIES m2
        WHERE
            m2.DIRECTOR_ID = d.DIRECTOR_ID
            AND YEAR(d.DIRECTOR_DEAD_DATE) < YEAR(m2.MOVIE_RELEASE_DATE)
    )
ORDER BY
    d.DIRECTOR_NAME;

-- 34- Utilizando la información de la sentencia anterior, modifica la fecha de defunción a un año más tarde del estreno de la película (mediante sentencia SQL)


UPDATE DIRECTORS
SET DIRECTOR_DEAD_DATE = DATEADD(YEAR, 1, (
    SELECT MAX(M.MOVIE_RELEASE_DATE)
    FROM MOVIES AS M
    WHERE M.DIRECTOR_ID = DIRECTORS.DIRECTOR_ID
))
WHERE
    DIRECTORS.DIRECTOR_DEAD_DATE IS NOT NULL
    AND EXISTS (
        SELECT 1
        FROM MOVIES AS M_Check
        WHERE M_Check.DIRECTOR_ID = DIRECTORS.DIRECTOR_ID
          AND DIRECTORS.DIRECTOR_DEAD_DATE < M_Check.MOVIE_RELEASE_DATE
    );



-- DIFICULTAD: Berserk mode (enunciados simples, mucha diversión…)
-- 35- Indica cuál es el género favorito de cada uno de los directores cuando dirigen una película
-- asumiendo que el mas repetido es el que mas le gusta
-- En esta opción falta concatenarlo
SELECT 
    D.DIRECTOR_NAME,
    G.GENRE_NAME AS FavoriteGenre,
    COUNT(M.MOVIE_ID) AS MovieCount
FROM
    DIRECTORS AS D
JOIN
    MOVIES AS M ON D.DIRECTOR_ID = M.DIRECTOR_ID
JOIN
    GENRES AS G ON M.GENRE_ID = G.GENRE_ID
GROUP BY
    D.DIRECTOR_ID, D.DIRECTOR_NAME, G.GENRE_NAME
HAVING
    COUNT(M.MOVIE_ID) = (
        SELECT
            MAX(T2.GenreMovieCount)
        FROM (
            SELECT
                D2.DIRECTOR_ID,
                G2.GENRE_NAME,
                COUNT(M2.MOVIE_ID) AS GenreMovieCount
            FROM
                DIRECTORS AS D2
            JOIN
                MOVIES AS M2 ON D2.DIRECTOR_ID = M2.DIRECTOR_ID
            JOIN
                GENRES AS G2 ON M2.GENRE_ID = G2.GENRE_ID
            WHERE
                D2.DIRECTOR_ID = D.DIRECTOR_ID -- Correlate with outer query
            GROUP BY
                D2.DIRECTOR_ID, G2.GENRE_NAME
        ) AS T2
    )
ORDER BY
    D.DIRECTOR_NAME, MovieCount DESC, FavoriteGenre ASC;

-- Otra forma de hacerlo ya completa:

WITH count_genre as(
	SELECT d.DIRECTOR_ID AS DIRECTOR,
	g.GENRE_NAME AS GENERO,
	count(g.GENRE_ID) AS SUMA
	FROM PUBLIC.DIRECTORS d
	JOIN PUBLIC.MOVIES m ON m.DIRECTOR_ID = d.DIRECTOR_ID
	JOIN PUBLIC.GENRES g ON g.GENRE_ID = m.GENRE_ID
	GROUP BY d.DIRECTOR_ID, G.GENRE_ID
)
SELECT d.DIRECTOR_NAME AS "Director",
GROUP_CONCAT(cg.GENERO SEPARATOR ', ')  AS "Genero"
FROM PUBLIC.DIRECTORS d
JOIN count_genre cg ON cg.DIRECTOR = d.DIRECTOR_ID
WHERE cg.SUMA = (SELECT MAX(SUMA) FROM count_genre WHERE d.DIRECTOR_ID = DIRECTOR)
GROUP BY d.DIRECTOR_NAME;
 

-- opcion con dos with:

WITH DirectorGenreCounts AS (
    SELECT
        d.DIRECTOR_ID,
        d.DIRECTOR_NAME,
        g.GENRE_NAME,
        COUNT(g.GENRE_ID) AS GenreMovieCount
    FROM
        DIRECTORS AS d
    JOIN
        MOVIES AS m ON m.DIRECTOR_ID = d.DIRECTOR_ID
    JOIN
        GENRES AS g ON g.GENRE_ID = m.GENRE_ID
    GROUP BY
        d.DIRECTOR_ID, d.DIRECTOR_NAME, g.GENRE_ID, g.GENRE_NAME
),
MaxGenreCountPerDirector AS (
    SELECT
        DIRECTOR_ID,
        MAX(GenreMovieCount) AS MaxCount
    FROM
        DirectorGenreCounts
    GROUP BY
        DIRECTOR_ID
)
SELECT
    dgc.DIRECTOR_NAME AS "Director",
    STRING_AGG(dgc.GENRE_NAME, ', ') WITHIN GROUP (ORDER BY dgc.GENRE_NAME ASC) AS "Favorite_Genres"
FROM
    DirectorGenreCounts AS dgc
JOIN
    MaxGenreCountPerDirector AS mgcpd ON dgc.DIRECTOR_ID = mgcpd.DIRECTOR_ID
WHERE
    dgc.GenreMovieCount = mgcpd.MaxCount
GROUP BY
    dgc.DIRECTOR_ID, dgc.DIRECTOR_NAME
ORDER BY
    dgc.DIRECTOR_NAME;


-- Otra forma:
WITH Genre_counts AS (
    SELECT
        d.DIRECTOR_ID,
        d.DIRECTOR_NAME,
        g.GENRE_NAME,
        COUNT(g.GENRE_ID) AS NUM_MOVIES
    FROM
        DIRECTORS AS d
    JOIN
        MOVIES AS m ON m.DIRECTOR_ID = d.DIRECTOR_ID
    JOIN
        GENRES AS g ON g.GENRE_ID = m.GENRE_ID
    GROUP BY
        d.DIRECTOR_ID,  g.GENRE_ID
),
MAX_VALUES AS(
SELECT 
DIRECTOR_ID,
MAX(NUM_MOVIES) AS MAX_MOVIES
FROM Genre_counts
GROUP BY DIRECTOR_ID)
SELECT gc.DIRECTOR_NAME, GROUP_CONCAT(gc.GENRE_NAME) FROM Genre_counts gc JOIN MAX_VALUES MV ON
gc.DIRECTOR_ID = MV.DIRECTOR_ID AND gc.NUM_MOVIES=MV.MAX_MOVIES
GROUP BY(gc.DIRECTOR_NAME);


-- 36- Indica cuál es la nacionalidad favorita de cada uno de los estudios en la producción 
-- de las películas

WITH TOT_NAT AS (
SELECT
	S.STUDIO_ID,
	S.STUDIO_NAME,
	N.NATIONALITY_ID,
	N.NATIONALITY_NAME,
	COUNT(N.NATIONALITY_ID) AS NUM_MOVIES
FROM
	MOVIES M
JOIN NATIONALITIES N ON
	M.NATIONALITY_ID = N.NATIONALITY_ID
JOIN PUBLIC.STUDIOS S ON
	S.STUDIO_ID = M.STUDIO_ID
GROUP BY
	S.STUDIO_ID,
	N.NATIONALITY_ID
ORDER BY
    S.STUDIO_ID ASC,
    NUM_MOVIES DESC),
MAX_NAT AS (
SELECT
		STUDIO_ID,
		MAX(NUM_MOVIES) AS MAX_MOVIES
	FROM
		TOT_NAT
	GROUP BY
		STUDIO_ID
		)
  SELECT
      STUDIO_NAME,
      GROUP_CONCAT(NATIONALITY_NAME) AS NATIONALITY_NAME
  FROM
      TOT_NAT AS TN
  INNER JOIN MAX_NAT MN ON
      TN.STUDIO_ID = MN.STUDIO_ID
      AND TN.NUM_MOVIES = MN.MAX_MOVIES
  GROUP BY
      STUDIO_NAME





-- 37- Indica cuál fue la primera película a la que accedieron los miembros de la plataforma cuyos teléfonos tengan como último dígito el ID de alguna nacionalidad
SELECT
    U.USER_NAME,
    M.MOVIE_NAME AS FirstAccessedMovie,
    UMA.ACCESS_DATE
FROM
    USERS AS U
JOIN
    USER_MOVIE_ACCESS AS UMA ON U.USER_ID = UMA.USER_ID
JOIN
    MOVIES AS M ON UMA.MOVIE_ID = M.MOVIE_ID
WHERE
    CAST(SUBSTR(U.USER_PHONE, LENGTH(U.USER_PHONE), 1) AS INT) IN (SELECT NATIONALITY_ID FROM NATIONALITIES)
    AND
    UMA.ACCESS_DATE = (
        SELECT
            MIN(UMA2.ACCESS_DATE)
        FROM
            USER_MOVIE_ACCESS AS UMA2
        WHERE
            UMA2.USER_ID = U.USER_ID
    )
    AND
    UMA.ACCESS_ID = (
        SELECT
            MIN(UMA3.ACCESS_ID)
        FROM
            USER_MOVIE_ACCESS AS UMA3
        WHERE
            UMA3.USER_ID = U.USER_ID
            AND UMA3.ACCESS_DATE = UMA.ACCESS_DATE
    )
ORDER BY
    U.USER_NAME;





















-- shutdown












