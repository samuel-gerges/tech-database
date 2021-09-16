/* 13-------------- (EXCEPT) Les numéros de factures et les clients associés à ces factures, lorsqu'ils ont acheté pour plus de 5000€ (toute année confondue) et dont le destinataire n'est pas le nom du client */

(SELECT numero_fact, nom FROM Facture
NATURAL JOIN Commande
NATURAL JOIN Client
GROUP BY numero_fact, nom
HAVING sum(prix_total) > 5000.0)
EXCEPT
(SELECT numero_fact, nom FROM Facture
NATURAL JOIN Commande
NATURAL JOIN Client
WHERE nom = destinataire);
