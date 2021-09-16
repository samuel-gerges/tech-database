Modélisation projet de BD6
==========================

Auteurs
-------

GERGES Samuel 71804327
JAMI Adam 71803537

Choix des produits à vendre
---------------------------

Nous avons choisi de modéliser et d'implémenter une base de données pour un site de vente de produits électroniques. Les produits peuvent être répartis dans plusieurs classes telles que :
* Informatique (Ordinateurs (portables ou pas), tablettes)
* Téléphonie et objets connectés (téléphones et accessoires, Smartwatches, etc...)
* TV, Son, Photo (TV, casques, enceintes, caméras)



Digramme E/R + contraintes externes
-----------------------------------

#Diagramme

Le diagramme E/R est disponible dans le dépôt sous le nom `diagramme.png`. Les noms des entités sont pour la plupart parlant, quelques précisions tout de même :
* `Bon` représente un bon de commande qu'un client peut obtenir en accumulant des points, points qu'il accumule en achetant sur le site.
* `EtatProd` représente, pour chaque produit d'une commande, son état avec des dates qui sont précisées (ou pas) selon l'état du produit.

#Contraintes externes

Voici pour chaque entité, les contraintes externes associées. Il nous a été dit qu'il fallait y indiquer ce que nous modélisons par des `CHECK` en sql.

* Client :
 - cid, numero, date_naiss, points > 0
 - date_naiss >= current_timestamp(0)
 - email doit être de la forme : '%___@___%'

* CommandeEncours :
 - coid, date_comm > 0
 - date_comm >= current_timestamp(0)
 - char_length(conf_cheque)<=6000

* CommandeTerminee :
 - coid, date_comm > 0
 - date_comm >= current_timestamp(0)
 - char_length(conf_cheque)<=6000

* Demande de retour :
 - date_retour < coid.date_comm + 30 jours

* Annulation :
 - date_retour < date_exp qui se trouve dans EtatProd

* Facture :
 - fid, numero, prix_total > 0
 - date_envoi >= current_timestamp(0)
 - char_length(carac_fac)<=6000

* EtatProd :
 - coid, pid, etat_prod > 0
 - date_expe >= current_timestamp(0)
 - date_livr >= current_timestamp(0)
 - date_livr_entrepot >= current_timestamp(0)
 - char_length(raison_annu)<=6000

* Bon :
 - cid, montant > 0
 - date_limite >= current_timestamp(0)

* Avis :
 - aid, note > 0
 - char_length(avis)<=6000
 - date_publi, date_achat >= current_timestamp(0)
 - Un client peut donner un avis seulement sur un produit qu'il a commandé

* Panier :
 - cid > 0

* Produit :
 - pid, prix, dimensions, poids > 0
 - disponibilite NOT NULL
 - delai >= current_timestamp(0)
 - char_length(caract_supp)<=6000
 - quantite_disp  >= 0

EvolutionPrix :
 - pid, prix  > 0
 - date_changement >= current_timestamp(0)

* Ordinateur :
 - capacite_stockage, ram > 0

* Laptop :
 - taille_ecran > 0
 - char_length(carac_ecran)<=6000

* Tablette :
 - capacite_stockage, poids et dimensions > 0

* Telephone :
 - capacite_stockage, memoire, autonomie et resolution > 0

* Television :
 - taille_ecran, consommation > 0

* AppareilPhoto :
 - taille_ecran, resolution > 0

* Enceinte :
 - puissance, autonomie, portee > 0

* Casque :
 - reduction_bruit > 0