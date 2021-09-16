/* 7-------------- (SOUS-REQUÊTE DANS LE FROM) La moyenne des prix et la moyenne des pourcentages des remboursements, par rapport au prix, des éléments de commandes annulés en 2020 */

SELECT avg(p) as prix, avg(r) as rembours FROM
(SELECT prix as p, remboursement as r FROM Produit
NATURAL JOIN ElementAExpedier
WHERE annulation = true
AND date_annu >= timestamp '2021-01-01 00:00:00') as x;
