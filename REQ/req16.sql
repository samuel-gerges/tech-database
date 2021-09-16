/* 16-------------- Le nom, l'e-mail et le numero des clients ayant commandé une tablette n'ayant pas été retournée ni refusée et un casque n'ayant pas été retourné ni refusé */

SELECT Client.nom, email, numero
FROM Client
NATURAL JOIN Commande
NATURAL JOIN ElementLivre
NATURAL JOIN Produit
NATURAL JOIN Tablette
WHERE retour_ou_refus IS NULL
AND coid IN (SELECT coid FROM Commande NATURAL JOIN ElementLivre NATURAL JOIN Casque WHERE retour_ou_refus IS NULL);
