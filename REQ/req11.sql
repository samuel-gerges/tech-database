/* 11-------------- (ORDER BY) Le nom, la puissance et l'autonomie des casques à réduction de bruit, par ordre décroissant de disponibilité */

SELECT nom_prod, puissance, autonomie FROM Produit
NATURAL JOIN Casque
WHERE reduction_bruit = true
ORDER BY quantite_disp DESC;
