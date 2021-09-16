/* 18-------------- (NULL (1)) Les enceintes ayant une portée supérieure à celle de tous les casques */

SELECT nom_prod FROM Produit
NATURAL JOIN Enceinte
WHERE Enceinte.portee > all(SELECT Casque.portee FROM Casque);
