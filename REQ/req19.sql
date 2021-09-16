/* 19-------------- (NULL (2)) Les enceintes ayant une portée supérieure à celle de tous les casques */

SELECT nom_prod FROM Produit
NATURAL JOIN Enceinte
WHERE Enceinte.portee > (SELECT max(Casque.portee) FROM Casque);
