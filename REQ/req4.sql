/* 4-------------- (REQUÊTE AVEC 2 AGRÉGATS) La moyenne des points de fidélité des clients ayant commandé plus de 3 articles */

SELECT avg(points) FROM Client
WHERE cid IN (SELECT cid FROM Commande NATURAL JOIN ElementLivre WHERE Client.cid = Commande.cid GROUP BY cid
HAVING count(*) >= 3);
