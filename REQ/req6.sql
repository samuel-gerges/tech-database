/* 6-------------- (SOUS-REQUÊTE CORRÉLÉE AVEC AGRÉGAT) */

SELECT P1.nom_prod FROM Produit P1 NATURAL JOIN Ordinateur
WHERE P1.prix > (SELECT max(P2.prix) FROM Produit P2 NATURAL JOIN Laptop WHERE P1.marque = P2.marque);
