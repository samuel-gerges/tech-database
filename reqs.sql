/* 1-------------- (REQUÊTE SUR AU MOINS 3 TABLES) Les commandes (coid) qui contiennent un ordinateur (qui a été livré) noté à 3 en moyenne ou plus */

SELECT coid, avg(note) as note_moyenne FROM ElementLivre
NATURAL JOIN Produit
NATURAL JOIN Ordinateur
NATURAL JOIN Avis
GROUP BY coid
HAVING avg(note) >= 3;


/* 2-------------- (AUTO-JOINTURE) Les noms des produits dont l'id est égal au poids */

SELECT DISTINCT P2.nom_prod FROM Produit P1 JOIN Produit P2 ON (P1.pid = P2.poids);


/* 3-------------- (SOUS-REQUÊTE DANS LE WHERE) Les noms des produits n'ayant jamais été commandé */

SELECT nom_prod FROM Produit
WHERE NOT EXISTS (SELECT pid FROM ElementAExpedier WHERE Produit.pid = ElementAExpedier.pid)
AND NOT EXISTS (SELECT pid FROM ElementEnLivraison WHERE Produit.pid = ElementEnLivraison.pid)
AND NOT EXISTS (SELECT pid FROM ElementLivre WHERE Produit.pid = ElementLivre.pid);


/* 4-------------- (REQUÊTE AVEC 2 AGRÉGATS) La moyenne des points de fidélité des clients ayant commandé plus de 3 articles */

SELECT round(avg(points)) FROM Client
WHERE cid IN (SELECT cid FROM Commande NATURAL JOIN ElementLivre WHERE Client.cid = Commande.cid GROUP BY cid
HAVING count(*) >= 3);


/* 5-------------- (SOUS-REQUÊTE CORRÉLÉE SANS AGRÉGAT) Les ordinateurs ayant un prix plus élévé que tous les laptops de la même marque */

SELECT P1.nom_prod FROM Produit P1 NATURAL JOIN Ordinateur
WHERE P1.prix > all(SELECT P2.prix FROM Produit P2 NATURAL JOIN Laptop WHERE P1.marque = P2.marque);


/* 6-------------- (SOUS-REQUÊTE CORRÉLÉE AVEC AGRÉGAT) */

SELECT P1.nom_prod FROM Produit P1 NATURAL JOIN Ordinateur
WHERE P1.prix > (SELECT max(P2.prix) FROM Produit P2 NATURAL JOIN Laptop WHERE P1.marque = P2.marque);


/* 7-------------- (SOUS-REQUÊTE DANS LE FROM) La moyenne des prix et la moyenne des pourcentages des remboursements, par rapport au prix, des éléments de commandes annulés en 2020 */

SELECT avg(p) as prix, avg(r) as rembours FROM
(SELECT prix as p, remboursement as r FROM Produit
NATURAL JOIN ElementAExpedier
WHERE annulation = true
AND date_annu >= timestamp '2021-01-01 00:00:00') as x;


/* 8-------------- (GROUP BY + HAVING (1)) Les paniers et leur montant total quand ce dernier est supérieur à 2000€ et quand les clients possèdent un bon d'au moins 100€ */

SELECT paid, sum(prix) FROM Panier
NATURAL JOIN PanierContient
NATURAL JOIN Produit
NATURAL JOIN Client
NATURAL JOIN Bon
GROUP BY paid, Bon.montant
HAVING (Bon.montant >= 100 AND sum(prix) > 2000.0);


/* 9-------------- (GROUP BY + HAVING (2)) Le nom de la classe et la moyenne des prix de ses produits quand cette dernière est au moins 500€ */

SELECT nom_classe, avg(prix) FROM Classe
NATURAL JOIN ClasseContientProduit
NATURAL JOIN Produit
GROUP BY nom_classe
HAVING avg(prix) >= 500.0;


/* 10--------------  (SOUS-REQUÊTE CORRÉLÉE) Le nom des téléphones n'ayant pas de note en-dessous de 2/5 */

SELECT DISTINCT nom_prod FROM Produit
NATURAL JOIN Telephone
WHERE NOT EXISTS(SELECT Avis.pid FROM Avis WHERE note < 2 AND Avis.pid = Produit.pid);


/* 11-------------- (ORDER BY) Le nom, la puissance et l'autonomie des casques à réduction de bruit, par ordre décroissant de disponibilité */

SELECT nom_prod, puissance, autonomie FROM Produit
NATURAL JOIN Casque
WHERE reduction_bruit = true
ORDER BY quantite_disp DESC;


/* 12-------------- (INTERSECT) Les commandes composés d'au moins 3 articles et dont le montant s'élève à plus de 700€ */

(SELECT coid FROM Commande
NATURAL JOIN ElementLivre
GROUP BY (coid)
HAVING count(pid) >= 2)
INTERSECT
(SELECT coid FROM Commande
NATURAL JOIN ElementLivre
NATURAL JOIN Produit
GROUP BY coid
HAVING sum(prix) > 700);


/* 13-------------- (EXCEPT) Les numéros de factures et les clients associés à ces factures, lorsqu'ils ont acheté pour plus de 5000€ (toute année confondue) et dont le destinataire n'est pas le nom du client */

(SELECT numero_fact, nom FROM Facture
NATURAL JOIN Commande
NATURAL JOIN Client
GROUP BY numero_fact, nom
HAVING sum(prix_total) > 500.0)
EXCEPT
(SELECT numero_fact, nom FROM Facture
NATURAL JOIN Commande
NATURAL JOIN Client
WHERE nom = destinataire);


/* 14-------------- (LOWER ET LIKE) Les id, les noms et les avis des appareils photos ayant une note moyenne inférieure à 2.2/5 et dont l'avis contient la chaîne de caractère "je ne recommande pas" ou "je recommande pas" */

SELECT pid, nom_prod, avis FROM Produit
NATURAL JOIN AppareilPhoto
NATURAL JOIN Avis
WHERE LOWER(avis) LIKE '%médiocre%'
OR LOWER(avis) LIKE '%insatisfait%'
GROUP BY (pid, nom_prod, avis)
HAVING avg(note) < 2.2;


/* 15-------------- (LEFT JOIN) Les noms des produits de la classe informatique et le maximum de leur évolution de prix (les noms des produits sont affichés même s'ils n'ont pas d'évolution de prix, grâce au LEFT JOIN) */

SELECT nom, max(nouveau_prix-ancien_prix)
FROM Produit
LEFT JOIN EvolutionPrix ON (Produit.pid = EvolutionPrix.pid)
NATURAL JOIN ClasseContientProduit
NATURAL JOIN Classe
WHERE Classe.nom = 'Informatique';


/* 16-------------- Le nom, l'e-mail et le numero des clients ayant commandé une tablette n'ayant pas été retournée ni refusée et un casque n'ayant pas été retourné ni refusé */

SELECT Client.nom, email, numero
FROM Client
NATURAL JOIN Commande
NATURAL JOIN ElementLivre
NATURAL JOIN Produit
NATURAL JOIN Tablette
WHERE retour_ou_refus IS NULL
AND coid IN (SELECT coid FROM Commande NATURAL JOIN ElementLivre NATURAL JOIN Casque WHERE retour_ou_refus IS NULL);


/* 17-------------- Les 10 clients les plus vieux ayant plus de 50 ans */

SELECT nom, age(current_timestamp, date_naiss) FROM Client
WHERE age(current_timestamp, date_naiss) >= '50 years'
ORDER BY (age(current_timestamp, date_naiss)) DESC
LIMIT 10;


/* 18-------------- (NULL (1)) Les enceintes ayant une portée supérieure à celle de tous les casques */

SELECT nom_prod FROM Produit
NATURAL JOIN Enceinte
WHERE Enceinte.portee > all(SELECT Casque.portee FROM Casque);


/* 19-------------- (NULL (2)) Les enceintes ayant une portée supérieure à celle de tous les casques */

SELECT nom_prod FROM Produit
NATURAL JOIN Enceinte
WHERE Enceinte.portee > (SELECT max(Casque.portee) FROM Casque);


/* 20-------------- Les commandes comportant un téléphone de la marque Apple de couleur noir et dont le nom du destinataire sur la facture commence par la lettre 'a' */

SELECT Commande.coid, Client.prenom FROM Commande
JOIN ElementLivre ON (Commande.coid = ElementLivre.coid)
JOIN Client ON (Commande.cid = Client.cid)
JOIN Produit ON (ElementLivre.pid = Produit.pid)
JOIN Telephone ON (Produit.pid = Telephone.pid)
JOIN Facture ON (Commande.coid = Facture.coid)
WHERE marque = 'apple'
AND couleur = 'noir'
AND destinataire LIKE 'A%';





