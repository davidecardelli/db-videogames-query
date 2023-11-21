-- ! GROUP BY

-- 1- Contare quante software house ci sono per ogni paese (3)
SELECT country, COUNT(*) as n_software_houses
FROM software_houses
GROUP BY country;

-- 2- Contare quante recensioni ha ricevuto ogni videogioco (del videogioco vogliamo solo l'ID) (500)
SELECT videogame_id, COUNT(*) as n_reviews
FROM reviews
GROUP BY videogame_id;

-- 3- Contare quanti videogiochi hanno ciascuna classificazione PEGI (della classificazione PEGI vogliamo solo l'ID) (13)
SELECT pegi_label_id, COUNT(*) as n_videogames
FROM pegi_label_videogame
GROUP BY pegi_label_id;

-- 4- Mostrare il numero di videogiochi rilasciati ogni anno (11)
SELECT YEAR(release_date) as release_year, COUNT(*) as n_videogames
FROM videogames
GROUP BY release_year;

-- 5- Contare quanti videogiochi sono disponbiili per ciascun device (del device vogliamo solo l'ID) (7)
SELECT device_id, COUNT(*) as n_videogames
FROM device_videogame
GROUP BY device_id;

-- 6- Ordinare i videogame in base alla media delle recensioni (del videogioco vogliamo solo l'ID) (500)
SELECT videogame_id, AVG(rating) as average_rating
FROM reviews
GROUP BY videogame_id
ORDER BY average_rating DESC;