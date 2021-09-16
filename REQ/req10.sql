/* 10--------------  (SOUS-REQUÊTE CORRÉLÉE) Le nom des téléphones n'ayant pas de note en-dessous de 2/5 */

SELECT DISTINCT nom_prod FROM Produit
NATURAL JOIN Telephone
WHERE NOT EXISTS(SELECT Avis.pid FROM Avis WHERE note < 2 AND Avis.pid = Produit.pid);
