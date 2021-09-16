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
   * cid, numero, date_naiss, points > 0
   * date_naiss >= current_timestamp(0)
   * email doit être de la forme : '%___@___%'


* CommandeEncours :
   * coid, date_comm > 0
   * date_comm >= current_timestamp(0)
   * char_length(conf_cheque)<=6000


* CommandeTerminee :
   * coid, date_comm > 0
   * date_comm >= current_timestamp(0)
   * char_length(conf_cheque)<=6000


* Demande de retour :
   * date_retour < coid.date_comm + 30 jours


* Annulation :
   * date_retour < date_exp qui se trouve dans EtatProd

* Facture :
   * fid, numero, prix_total > 0
   * date_envoi >= current_timestamp(0)
   * char_length(carac_fac)<=6000

* EtatProd :
   * coid, pid, etat_prod > 0
   * date_expe >= current_timestamp(0)
   * date_livr >= current_timestamp(0)
   * date_livr_entrepot >= current_timestamp(0)
   * char_length(raison_annu)<=6000

* Bon :
   * cid, montant > 0
   * date_limite >= current_timestamp(0)

* Avis :
   * aid, note > 0
   * char_length(avis)<=6000
   * date_publi, date_achat >= current_timestamp(0)

* Panier :
   * cid > 0


* Produit :
   * pid, prix, dimensions, poids > 0
   * disponibilite NOT NULL
   * delai >= current_timestamp(0)
   * char_length(caract_supp)<=6000
   * quantite_disp  >= 0

* EvolutionPrix :
   * pid, prix  > 0
   * date_changement >= current_timestamp(0)


* Ordinateur :
   * capacite_stockage, ram > 0


* Laptop :
   * taille_ecran > 0
   * char_length(carac_ecran)<=6000


* Tablette :
   * capacite_stockage, poids et dimensions > 0


* Telephone :
   * capacite_stockage, memoire, autonomie et resolution > 0


* Television :
   * taille_ecran, consommation > 0


* AppareilPhoto :
   * taille_ecran, resolution > 0


* Enceinte :
   * puissance, autonomie, portee > 0


* Casque :
   * reduction_bruit > 0


Tables
------

Nous avons également commencé à faire la traduction vers le schéma relationnel et voici le passage aux tables que nous optenons pour le moment. Nous sommes conscients qu'il manque probablement des contraintes de clés étrangères et peut-être même des attributs pour certaines tables, mais nous avons tout de même voulu vous montrer ce que nous obtenons pour avoir un retour. Merci d'avance pour vos commentaires.


**NB : - CONSTRAINT CHECK : contraintes d'attributs externes**
       - points : pour système de points de fidélité
       - carac_supp = caractériqtiques supplémentaires

```sql
Client  (
	_cid_  INT  AUTO_INCREMENT, 
	nom  NOT NULL VARCHAR(50),
	prenom  NOT NULL VARCHAR(50),
	adresse  NOT NULL VARCHAR(255),
	email  NOT NULL VARCHAR(255),
	numero  INT,
	date_naiss  NOT NULL TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	points  INT,
	PRIMARY KEY ( _cid_ ),

	CONSTRAINT cst_client CHECK(
		_cid_ > 0 AND 
		numero > 0 AND
		points > 0 AND
		date_naiss >= current_timestamp(0) AND
		email LIKE '%___@___%'
	    )
);


CommandeEnCours(
	_coid_  INT  AUTO_INCREMENT,
	date_comm  NOT NULL TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	adresse VARCHAR(255),
	conf_cheque NOT NULL BOOLEAN,
	date_livr_prevue NOT NULL TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY ( _coid_ ),
	FOREIGN KEY ( _cid_ ),

	CONSTRAINT cst_commandeencours CHECK (
		_coid_ > 0 AND 
		date_comm > 0 AND
		date_comm >= current_timestamp(0) AND
		char_length(conf_cheque)<=6000
	     )
);


CommandeTerminee(
	_coid_  INT  AUTO_INCREMENT,
	date_comm  NOT NULL TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	adresse VARCHAR(255),
	conf_cheque NOT NULL BOOLEAN,
	date_livr NOT NULL TIMESTAMP,
	PRIMARY KEY ( _coid_ ),
	FOREIGN KEY ( _cid_ ),

	CONSTRAINT cst_commandeterminee CHECK(
		_coid_ > 0 AND 
		date_comm > 0 AND
		date_comm >= current_timestamp(0) AND
		char_length(conf_cheque)<=6000
	     )
);


DemandeRetour(
	_coid INT , pid_ INT ,
	date_retour NOT NULL TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	raison_retour TEXT,
	remboursement INT,
	date_comm  NOT NULL TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	adresse VARCHAR(255),
	conf_cheque NOT NULL BOOLEAN,
	type VARCHAR(255),
	PRIMARY KEY (_coid,pid_),
	FOREIGN KEY ( date_retour) ,

	CONSTRAINT cst_retour CHECK(
		_coid > 0 AND 
		pid_ > 0 AND
		remboursement > 0 AND
		date_retour >= current_timestamp(0) AND
		date_retour < 
		char_length(raison_retour)<=6000
	     )

-- contraintes : date_retour doit être inférieure à coid.date_comm + 30 jours --

);


Annulation(
	_coid INT, pid_ INT ,
	date_annu NOT NULL TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	raison_annu TEXT,
	remboursement INT,
	date_comm  NOT NULL TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	adresse VARCHAR(255),
	conf_cheque NOT NULL BOOLEAN,
	PRIMARY KEY (_coid,pid_),
	FOREIGN KEY ( date_annu) ,

	CONSTRAINT cst_annulation CHECK(
		_coid > 0 AND 
		pid_ > 0 AND
		remboursement > 0 AND
		date_retour >= current_timestamp(0) AND
		char_length(raison_annu)<=6000
	     )

-- contrainte : date_annu doit être inférieure à date_exp qui se trouve dans EtatProd --

);


Facture(
	
	fid INT,
	numero INT,
	prix_total INT,
	destinataire VARCHAR(255),
	expediteur VARCHAR(255),
	entreprise VARCHAR(255),
	carac_fac TEXT,
	date_comm  NOT NULL TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	adresse VARCHAR(255),
	conf_cheque NOT NULL BOOLEAN,
	PRIMARY KEY(fid),
	
	CONSTRAINT cst_annulation CHECK(
		fid > 0 AND 
		numero > 0 AND
		prix_total > 0 AND
		date_envoi >= current_timestamp(0) AND
		char_length(carac_fac)<=6000
	     )
); 


EtatProd  (
	coid  INT,
	pid  INT,
	etat_prod  INT,
	date_expe  NOT NULL TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	date_livr  NOT NULL TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	date_livr_entrepot  TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	date_comm  NOT NULL TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	adresse VARCHAR(255),
	conf_cheque NOT NULL BOOLEAN,

	CONSTRAINT cst_etatprod CHECK (
		coid > 0 AND
		pid > 0 AND 
		etat_prod > 0 AND
		date_expe >= current_timestamp(0) AND
		date_livr >= current_timestamp(0) AND
		date_livr_entrepot >= current_timestamp(0) AND
		char_length(raison_annu)<=6000
	     )
);


Bon(
	_cid INT, *date_emission*_ NOT NULL TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	montant INT NOT NULL,
	date_limite NOT NULL TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	nom  NOT NULL VARCHAR(50),
	prenom  NOT NULL VARCHAR(50),
	adresse  NOT NULL VARCHAR(255),
	email  NOT NULL VARCHAR(255),
	numero  INT,
	date_naiss  NOT NULL TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	points  INT,
	PRIMARY KEY(_cid,date_emission),

	CONSTRAINT cst_bon CHECK(
		_cid > 0 AND
		montant > 0 AND
		date_limite >= current_timestamp(0)) 
	     )
);


Avis  (
	aid_  INT AUTO_INCREMENT,
	pseudo NOT NULL VARCHAR(50),
	pid   INT,
	note   INT,
	avis  NOT NULL TEXT,
	date_publi  NOT NULL TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	date_achat  NOT NULL TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY ( _aid_ ),

	CONSTRAINT cst_avis CHECK (
		_aid_ AND
		note > 0 AND
		pid > 0 AND
		char_length(avis)<=6000 AND
		date_publi >= current_timestamp(0) AND
		date_achat >= current_timestamp(0) 
	     			   )

);


Classe  (
	_claid_  INT AUTO_INCREMENT ,
	nom_classe  VARCHAR(255),
	PRIMARY KEY ( _claid_ ),

	CHECK(_claid_>0)
);


Produit  (
	_pid_  INT AUTO_INCREMENT,
	nom_prod  VARCHAR(255),
	prix  INT ,
	disponibilite  NOT NULL CHAR(10),
	quantite_disp  INT,
	delai  NOT NULL TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	etat  NOT NULL CHAR(10),
	couleur  VARCHAR(255),
	marque  VARCHAR(255),
	garantie  BOOLEAN,
	dimensions  POINT,
	poids  INT ,
	carac_supp	TEXT,
	PRIMARY KEY ( _pid_ ),

	CONSTRAINT cst_produit CHECK(
		_pid_ AND prix AND dimensions AND poids ) > 0 AND
		prix  > 0 AND
		poids  > 0 AND
		delai >= current_timestamp(0)) AND
		char_length(carac_supp)<=6000 AND
		quantite_disp  >= 0 AND
	     )
);


EvolutionPrix(
	_pid INT , *prix*_ INT ,
	date_changement NOT NULL TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (_pid,prix),

	CONSTRAINT cst_evolution CHECK(
		_pid_ > 0 AND
		prix  > 0 AND
		date_changement >= current_timestamp(0)) AND
	     )
);


Panier(
	_cid_ INT ,
	valide BOOLEAN,
	_cid_ INT AUTO_INCREMENT, 
	nom  NOT NULL VARCHAR(50),
	prenom  NOT NULL VARCHAR(50),
	adresse  NOT NULL VARCHAR(255),
	email  NOT NULL VARCHAR(255),
	numero  INT,
	date_naiss  NOT NULL TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	points INT,

	CHECK(_cid_ > 0)
);


Ordinateur  (
	_pid_  INT AUTO_INCREMENT,
	nom_prod  VARCHAR(255),
	prix  INT ,
	disponibilite  NOT NULL CHAR(10),
	quantite_disp  INT,
	delai  NOT NULL TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	etat  NOT NULL CHAR(10),
	couleur  VARCHAR(255),
	marque  VARCHAR(255),
	garantie  BOOLEAN,
	dimensions  POINT,
	poids  INT ,
	carac_supp TEXT,
	marque_cpu  VARCHAR(255),
	modele_cpu  VARCHAR(255),
	marque_gpu  VARCHAR(255),
	modele_gpu  VARCHAR(255),
	type_stockage  VARCHAR(255),
	capacite_stockage  INT ,
	type_ram  VARCHAR(255),
	ram  INT ,
	os  VARCHAR(100),

	CHECK(
		capacite_stockage > 0 AND
		ram > 0
	      )
);


Laptop  (
	_pid_  INT AUTO_INCREMENT,
	nom_prod  VARCHAR(255),
	prix  INT ,
	disponibilite  NOT NULL CHAR(10),
	quantite_disp  INT,
	delai  NOT NULL TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	etat  NOT NULL CHAR(10),
	couleur  VARCHAR(255),
	marque  VARCHAR(255),
	garantie  BOOLEAN,
	dimensions  POINT,
	poids  INT ,
	carac_supp TEXT,
	taille_ecran INT,
	carac_ecran  TEXT,
	webcam  BOOLEAN,
	carte_son  VARCHAR(255),

	CONSTRAINT cst_laptop CHECK(
		taille_ecran > 0 AND
		char_length(carac_ecran)<=6000
	     )
);


Tablette  (
	_pid_  INT AUTO_INCREMENT,
	nom_prod  VARCHAR(255),
	prix  INT ,
	disponibilite  NOT NULL CHAR(10),
	quantite_disp  INT,
	delai  NOT NULL TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	etat  NOT NULL CHAR(10),
	couleur  VARCHAR(255),
	marque  VARCHAR(255),
	garantie  BOOLEAN,
	dimensions  POINT,
	poids  INT ,
	carac_supp TEXT,
	processeur  VARCHAR(255),
	capacite_stockage  INT,
	cam_avant  BOOLEAN,
	cam_arriere  BOOLEAN,

	CHECK(
		capacite_stockage > 0 AND
		poids > 0
	 	)
);


Telephone  (
	_pid_  INT AUTO_INCREMENT,
	nom_prod  VARCHAR(255),
	prix  INT ,
	disponibilite  NOT NULL CHAR(10),
	quantite_disp  INT,
	delai  NOT NULL TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	etat  NOT NULL CHAR(10),
	couleur  VARCHAR(255),
	marque  VARCHAR(255),
	garantie  BOOLEAN,
	dimensions  POINT,
	poids  INT ,
	carac_supp TEXT,
	processeur  VARCHAR(255),
	capacite_stockage  INT,
	cam_avant  BOOLEAN,
	cam_arriere  BOOLEAN,
	autonomie  INT,

	CHECK(
		capacite_stockage > 0  
		memoire > 0  
		autonomie > 0  
	 	)
);


Television  (
	_pid_  INT AUTO_INCREMENT,
	nom_prod  VARCHAR(255),
	prix  INT ,
	disponibilite  NOT NULL CHAR(10),
	quantite_disp  INT,
	delai  NOT NULL TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	etat  NOT NULL CHAR(10),
	couleur  VARCHAR(255),
	marque  VARCHAR(255),
	garantie  BOOLEAN,
	dimensions  POINT,
	poids  INT ,
	carac_supp TEXT,
	taille_ecran  INT,
	definition  VARCHAR(255),
	entrees_video  VARCHAR(255),
	sorties_audio  VARCHAR(255),
	consommation  INT,

	CHECK(
		taille_ecran > 0 
		consommation > 0
	     )
);


AppareilPhoto  (
	_pid_  INT AUTO_INCREMENT,
	nom_prod  VARCHAR(255),
	prix  INT ,
	disponibilite  NOT NULL CHAR(10),
	quantite_disp  INT,
	delai  NOT NULL TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	etat  NOT NULL CHAR(10),
	couleur  VARCHAR(255),
	marque  VARCHAR(255),
	garantie  BOOLEAN,
	dimensions  POINT,
	poids  INT ,
	carac_supp TEXT,
	definition  VARCHAR(255),
	resolution  POINT,
	taille_ecran  INT,

	CONSTRAINT cst_camera CHECK(
		taille_ecran > 0
	 			   )
);


Enceinte (
	_pid_  INT AUTO_INCREMENT,
	nom_prod  VARCHAR(255),
	prix  INT ,
	disponibilite  NOT NULL CHAR(10),
	quantite_disp  INT,
	delai  NOT NULL TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	etat  NOT NULL CHAR(10),
	couleur  VARCHAR(255),
	marque  VARCHAR(255),
	garantie  BOOLEAN,
	dimensions  POINT,
	poids  INT ,
	carac_supp TEXT,
	puissance  INT,
	autonomie  INT,
	portee  INT,

	CHECK(
		puissance > 0 AND
		autonomie > 0 AND
		portee > 0
	     )
);


Casque (
	_pid_  INT AUTO_INCREMENT,
	nom_prod  VARCHAR(255),
	prix  INT ,
	disponibilite  NOT NULL CHAR(10),
	quantite_disp  INT,
	delai  NOT NULL TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	etat  NOT NULL CHAR(10),
	couleur  VARCHAR(255),
	marque  VARCHAR(255),
	garantie  BOOLEAN,
	dimensions  POINT,
	poids  INT ,
	carac_supp TEXT,
	puissance  INT,
	autonomie  INT,
	portee  INT,	
	connectique  VARCHAR(255),
	reduction_bruit  INT,

	CHECK(reduction_bruit > 0)
);

```
