/* 8-------------- (GROUP BY + HAVING (1)) Les paniers et leur montant total quand ce dernier est supérieur à 2000€ et quand les clients possèdent un bon d'au moins 100€ */

SELECT paid, sum(prix) FROM Panier
NATURAL JOIN PanierContient
NATURAL JOIN Produit
NATURAL JOIN Client
NATURAL JOIN Bon
GROUP BY paid, montant
HAVING (montant >= 0 AND sum(prix) > 2000.0);
