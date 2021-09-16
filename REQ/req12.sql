/* 12-------------- (INTERSECT) Les commandes composés de moins de 3 articles et dont le montant s'élève à plus de 3000€ */

(SELECT coid FROM Commande
NATURAL JOIN ElementAExpedier
NATURAL JOIN ElementEnLivraison
NATURAL JOIN ElementLivre
GROUP BY (coid)
HAVING count(pid) <= 0)
INTERSECT
(SELECT coid FROM Commande
NATURAL JOIN ElementAExpedier
NATURAL JOIN ElementEnLivraison
NATURAL JOIN ElementLivre
NATURAL JOIN Produit
GROUP BY coid
HAVING sum(prix) > 0);
