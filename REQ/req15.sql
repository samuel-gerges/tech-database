/* 15-------------- (LEFT JOIN) Les noms des produits de la classe informatique et le maximum de leur évolution de prix (les noms des produits sont affichés même s'ils n'ont pas d'évolution de prix, grâce au LEFT JOIN) */

SELECT nom, max(nouveau_prix-ancien_prix)
FROM Produit
LEFT JOIN EvolutionPrix ON (Produit.pid = EvolutionPrix.pid)
NATURAL JOIN ClasseContientProduit
NATURAL JOIN Classe
WHERE Classe.nom = 'Informatique';
