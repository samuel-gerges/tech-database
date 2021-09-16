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
