/* 1-------------- (REQUÊTE SUR AU MOINS 3 TABLES) Les commandes (cid) qui contiennent un ordinateur (qui a été livré) noté à 3 en moyenne ou plus */

SELECT coid, avg(note) as note_moyenne FROM ElementLivre
NATURAL JOIN Produit
NATURAL JOIN Ordinateur
NATURAL JOIN Avis
GROUP BY coid
HAVING avg(note) >= 3;
