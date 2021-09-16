/* 5-------------- (SOUS-REQUÊTE CORRÉLÉE SANS AGRÉGAT) Les ordinateurs ayant un prix plus élévé que tous les laptops de la même marque */

SELECT P1.nom_prod FROM Produit P1 NATURAL JOIN Ordinateur
WHERE P1.prix > all(SELECT P2.prix FROM Produit P2 NATURAL JOIN Laptop WHERE P1.marque = P2.marque);
