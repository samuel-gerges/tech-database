/* 9-------------- (GROUP BY + HAVING (2)) Le nom de la classe et la moyenne des prix de ses produits quand cette dernière est au moins 500€ */

SELECT nom_classe, avg(prix) FROM Classe
NATURAL JOIN ClasseContientProduit
NATURAL JOIN Produit
GROUP BY nom_classe
HAVING avg(prix) >= 500.0;
