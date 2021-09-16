/* 14-------------- (LOWER ET LIKE) Les id, les noms et les avis des appareils photos ayant une note moyenne inférieure à 2.2/5 et dont l'avis contient la chaîne de caractère "je ne recommande pas" ou "je recommande pas" */

SELECT pid, nom_prod, avis FROM Produit
NATURAL JOIN AppareilPhoto
NATURAL JOIN Avis
WHERE LOWER(avis) LIKE '%médiocre%'
OR LOWER(avis) LIKE '%insatisfait%'
GROUP BY (pid, nom_prod, avis)
HAVING avg(note) < 2.2;
