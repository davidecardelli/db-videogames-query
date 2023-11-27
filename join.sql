-- !JOIN

-- 1- Selezionare i dati di tutti giocatori che hanno scritto almeno una recensione, mostrandoli una sola volta (996)

SELECT DISTINCT `players`.*
FROM `players` 
JOIN `reviews` ON `players`.`id` = `reviews`.`player_id`;

-- 2- Sezionare tutti i videogame dei tornei tenuti nel 2016, mostrandoli una sola volta (226)

SELECT DISTINCT `videogames`.*
FROM `videogames`
JOIN `tournament_videogame` ON `videogames`.`id` = `tournament_videogame`.`videogame_id`
JOIN `tournaments` ON `tournament_videogame`.`tournament_id` = `tournaments`.`id`
WHERE `tournaments`.`year` = 2016;

-- 3- Mostrare le categorie di ogni videogioco (1718)

SELECT `videogames`.`id` AS `id_videogioco`, `categories`.`name` AS `categoria`
FROM `videogames` 
JOIN `category_videogame` ON `videogames`.`id` = `category_videogame`.`videogame_id`
JOIN `categories` ON `category_videogame`.`category_id` = `categories`.`id`;

-- 4- Selezionare i dati di tutte le software house che hanno rilasciato almeno un gioco dopo il 2020, mostrandoli una sola volta (6)

SELECT DISTINCT `software_houses`.*
FROM `software_houses`
JOIN `videogames` ON `software_houses`.`id` = `videogames`.`software_house_id`
WHERE YEAR(`videogames`.`release_date`) > 2020

-- 5- Selezionare i premi ricevuti da ogni software house per i videogiochi che ha prodotto (55)

SELECT
    `software_houses`.`name`,
    `awards`.`name`
FROM
    `software_houses`
JOIN
    `videogames` ON `software_houses`.`id` = `videogames`.`software_house_id`
JOIN
    `award_videogame` ON `videogames`.`id` = `award_videogame`.`videogame_id`
JOIN
    `awards` ON `award_videogame`.`award_id` = `awards`.`id`;

-- 6- Selezionare categorie e classificazioni PEGI dei videogiochi che hanno ricevuto recensioni da 4 e 5 stelle, mostrandole una sola volta (3363)

SELECT DISTINCT
    `categories`.`name` AS `categoria`,
    `pegi_labels`.`name` AS `classificazione_pegi`,
    `videogames`.`name` AS `videogames_name`
FROM
    `videogames`
JOIN
    `category_videogame` ON `videogames`.`id` = `category_videogame`.`videogame_id`
JOIN
    `categories` ON `category_videogame`.`category_id` = `categories`.`id`
JOIN
    `pegi_label_videogame` ON `videogames`.`id` = `pegi_label_videogame`.`videogame_id`
JOIN
    `pegi_labels` ON `pegi_label_videogame`.`pegi_label_id` = `pegi_labels`.`id`
JOIN
    `reviews` ON `videogames`.`id` = `reviews`.`videogame_id`
WHERE
    `reviews`.`rating` IN (4, 5);

-- 7- Selezionare quali giochi erano presenti nei tornei nei quali hanno partecipato i giocatori il cui nome inizia per 'S' (474)

SELECT DISTINCT
    `videogames`.*
FROM
    `videogames`
JOIN
    `tournament_videogame` ON `videogames`.`id` = `tournament_videogame`.`videogame_id`
JOIN
    `tournaments` ON `tournament_videogame`.`tournament_id` = `tournaments`.`id`
JOIN
    `player_tournament` ON `tournaments`.`id` = `player_tournament`.`tournament_id`
JOIN
    `players` ON `player_tournament`.`player_id` = `players`.`id`
WHERE
    `players`.`name` LIKE 'S%';

-- 8- Selezionare le città in cui è stato giocato il gioco dell'anno del 2018 (36)

SELECT DISTINCT
    t.`city`
FROM
    `tournaments` t
JOIN
    `tournament_videogame` tv ON t.`id` = tv.`tournament_id`
JOIN
    `videogames` vg ON tv.`videogame_id` = vg.`id`
JOIN
    `award_videogame` av ON vg.`id` = av.`videogame_id`
JOIN
    `awards` a ON av.`award_id` = a.`id`

WHERE
    a.`name` = "Gioco dell'anno"
    AND av.`year` = 2018;


-- 9- Selezionare i giocatori che hanno giocato al gioco più atteso del 2018 in un torneo del 2019 (991)

SELECT DISTINCT
    p.`nickname`
FROM
    `players` p
JOIN
    `player_tournament` pt ON p.`id` = pt.`player_id`
JOIN
    `tournaments` t ON pt.`tournament_id` = t.`id`
JOIN
    `tournament_videogame` tv ON t.`id` = tv.`tournament_id`
JOIN
    `videogames` vg ON tv.`videogame_id` = vg.`id`
JOIN
    `award_videogame` av ON vg.`id` = av.`videogame_id`
JOIN
    `awards` a ON av.`award_id` = a.`id`
WHERE
    a.`name` = 'Gioco più atteso'
    AND av.`year` = 2018
    AND t.`year` = 2019;

-- *********** BONUS ***********

-- 10- Selezionare i dati della prima software house che ha rilasciato un gioco, assieme ai dati del gioco stesso (software house id : 5)

SELECT
    sh.*,
    vg.*
FROM
    `software_houses` sh
JOIN
    `videogames` vg ON sh.`id` = vg.`software_house_id`
ORDER BY
    vg.`release_date`
LIMIT 1;

-- 11- Selezionare i dati del videogame (id, name, release_date, totale recensioni) con più recensioni (videogame id : potrebbe uscire 449 o 398, sono entrambi a 20)

SELECT
    vg.`id` AS game_id,
    vg.`name` AS game_name,
    vg.`release_date` AS release_date,
    COUNT(r.`id`) AS total_reviews
FROM
    `videogames` vg
JOIN
    `reviews` r ON vg.`id` = r.`videogame_id`
GROUP BY
    vg.`id`, vg.`name`, vg.`release_date`
ORDER BY
    total_reviews DESC
LIMIT 1;

-- 12- Selezionare la software house che ha vinto più premi tra il 2015 e il 2016 (software house id : potrebbe uscire 3 o 1, sono entrambi a 3)

SELECT
    sh.`id` AS software_house_id,
    sh.`name` AS software_house_name,
    COUNT(DISTINCT a.`id`) AS total_awards
FROM
    `software_houses` sh
JOIN
    `videogames` vg ON sh.`id` = vg.`software_house_id`
JOIN
    `award_videogame` av ON vg.`id` = av.`videogame_id`
JOIN
    `awards` a ON av.`award_id` = a.`id`
WHERE
    av.`year` BETWEEN 2015 AND 2016
GROUP BY
    sh.`id`, sh.`name`
ORDER BY
    total_awards DESC
LIMIT 1;

-- 13- Selezionare le categorie dei videogame i quali hanno una media recensioni inferiore a 2 (10)

SELECT DISTINCT
    c.`name` AS category_name
FROM
    `categories` c
JOIN
    `category_videogame` cvg ON c.`id` = cvg.`category_id`
JOIN
    `videogames` vg ON cvg.`videogame_id` = vg.`id`
JOIN
    `reviews` r ON vg.`id` = r.`videogame_id`
GROUP BY
    vg.`id`, c.`name`
HAVING
    AVG(r.`rating`) < 2;