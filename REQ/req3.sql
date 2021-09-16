/* 3-------------- (SOUS-REQUÊTE DANS LE WHERE) Les noms des produits n'ayant jamais été commandé */

SELECT nom_prod FROM Produit
WHERE NOT EXISTS (SELECT pid FROM ElementAExpedier WHERE Produit.pid = ElementAExpedier.pid)
AND NOT EXISTS (SELECT pid FROM ElementEnLivraison WHERE Produit.pid = ElementEnLivraison.pid)
AND NOT EXISTS (SELECT pid FROM ElementLivre WHERE Produit.pid = ElementLivre.pid);
