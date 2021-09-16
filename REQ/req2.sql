/* 2-------------- (AUTO-JOINTURE) Les noms des produits dont l'id est égal au poids */

SELECT DISTINCT P2.nom_prod FROM Produit P1 JOIN Produit P2 ON (P1.pid = P2.poids);
