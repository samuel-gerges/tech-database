DROP TABLE IF EXISTS Client CASCADE;
DROP TABLE IF EXISTS Commande CASCADE;
DROP TABLE IF EXISTS ElementAExpedier CASCADE;
DROP TABLE IF EXISTS ElementEnLivraison CASCADE;
DROP TABLE IF EXISTS ElementLivre CASCADE;
DROP TABLE IF EXISTS Facture CASCADE;
DROP TABLE IF EXISTS Bon CASCADE;
DROP TABLE IF EXISTS Avis CASCADE;
DROP TABLE IF EXISTS Panier CASCADE;
DROP TABLE IF EXISTS PanierContient CASCADE;
DROP TABLE IF EXISTS Classe CASCADE;
DROP TABLE IF EXISTS ClasseContientProduit CASCADE;
DROP TABLE IF EXISTS EvolutionPrix CASCADE;
DROP TABLE IF EXISTS Produit CASCADE;
DROP TABLE IF EXISTS Ordinateur CASCADE;
DROP TABLE IF EXISTS Laptop CASCADE;
DROP TABLE IF EXISTS Tablette CASCADE;
DROP TABLE IF EXISTS Telephone CASCADE;
DROP TABLE IF EXISTS Television CASCADE;
DROP TABLE IF EXISTS AppareilPhoto CASCADE;
DROP TABLE IF EXISTS Enceinte CASCADE;
DROP TABLE IF EXISTS Casque CASCADE;

CREATE TABLE Client
(
	cid SERIAL PRIMARY KEY,
	nom VARCHAR(50) NOT NULL,
	prenom VARCHAR(50) NOT NULL,
	adresse VARCHAR(255) NOT NULL,
	email VARCHAR(255) NOT NULL,
	numero VARCHAR(30),
	date_naiss date,
	points INT,

	CONSTRAINT cst_client CHECK(
		points >= 0 AND
		date_naiss <= current_timestamp AND
		email LIKE '%@%'
	)
);

CREATE TABLE Commande
(
	coid SERIAL PRIMARY KEY,
	cid INT NOT NULL,
	date_comm TIMESTAMP NOT NULL,
	adresse VARCHAR(255),
	conf_cheque BOOLEAN,

	FOREIGN KEY (cid) REFERENCES Client(cid),

	CONSTRAINT cst_commande CHECK (
		date_comm <= current_timestamp(0)
	)
);

CREATE TABLE Produit
(
	pid SERIAL PRIMARY KEY,
	nom_prod VARCHAR(255) NOT NULL,
	prix FLOAT NOT NULL,
	quantite_disp INT,
	delai TIMESTAMP,
	disponibilite CHAR(30) NOT NULL,
	marque VARCHAR(255) NOT NULL,
	--dimensions TEXT NOT NULL,
	poids FLOAT,
	couleur VARCHAR(255),
	garantie BOOLEAN NOT NULL,

	CONSTRAINT cst_produit CHECK(
		prix > 0.0 AND
		poids > 0 AND
		quantite_disp >= 0 AND
		delai >= current_timestamp(0)
		
	)
);

CREATE TABLE ElementAExpedier
(
	coid INT NOT NULL,
	pid INT NOT NULL,
	date_livr_entrepot TIMESTAMP,
	annulation BOOLEAN NOT NULL,
	date_annu TIMESTAMP,
	raison_annu TEXT,
	remboursement FLOAT,

	PRIMARY KEY(coid, pid),
	
	FOREIGN KEY(coid) REFERENCES Commande(coid),
	FOREIGN KEY(pid) REFERENCES Produit(pid),

	CONSTRAINT cst_elt_a_expedier CHECK (
		date_livr_entrepot >= current_timestamp(0)
	)
);

CREATE TABLE ElementEnLivraison
(
	coid INT NOT NULL,
	pid INT NOT NULL,
	date_expe TIMESTAMP NOT NULL,
	date_livr_prevue TIMESTAMP NOT NULL,

	PRIMARY KEY(coid, pid),
	
	FOREIGN KEY(coid) REFERENCES Commande(coid),
	FOREIGN KEY(pid) REFERENCES Produit(pid),

	CONSTRAINT cst_elt_en_livraison CHECK (
		date_expe >= current_timestamp(0) AND
		date_livr_prevue >= current_timestamp(0)
	)
);

CREATE TABLE ElementLivre
(
	coid INT NOT NULL,
	pid INT NOT NULL,
	date_livr TIMESTAMP NOT NULL,
	retour_ou_refus TEXT,
	date_retour TIMESTAMP,
	raison_retour TEXT,
	retour_effectif BOOLEAN,
	raison_refus TEXT,
	remboursement FLOAT,

	PRIMARY KEY(coid, pid),
	
	FOREIGN KEY(coid) REFERENCES Commande(coid),
	FOREIGN KEY(pid) REFERENCES Produit(pid),

	CONSTRAINT cst_elt_livre CHECK (
		date_livr <= current_timestamp(0) AND
		date_retour <= current_timestamp(0) AND
		remboursement > 0
	)
);

CREATE TABLE Facture
(
	coid INT NOT NULL,
	numero_fact INT NOT NULL,
	date_fact TIMESTAMP NOT NULL,
	prix_total FLOAT NOT NULL,
	destinataire VARCHAR(255) NOT NULL,
	expediteur VARCHAR(255) NOT NULL,

	PRIMARY KEY(coid, numero_fact),
	
	FOREIGN KEY(coid) REFERENCES Commande(coid),

	CONSTRAINT cst_facture CHECK(
		numero_fact > 0 AND
		prix_total > 0.0
	)
);

CREATE TABLE Bon
(
	cid INT NOT NULL,
	date_emission TIMESTAMP NOT NULL,
	montant INT NOT NULL,
	date_limite TIMESTAMP NOT NULL,

	PRIMARY KEY(cid, date_emission),
	
	FOREIGN KEY (cid) REFERENCES Client(cid),

	CONSTRAINT cst_bon CHECK(
		montant > 0 AND
		date_limite >= current_timestamp(0)
	)
);

CREATE TABLE Avis
(
	aid SERIAL PRIMARY KEY,
	cid INT NOT NULL,
	pid INT NOT NULL,
	note FLOAT NOT NULL,
	avis TEXT NOT NULL,
	date_publi TIMESTAMP NOT NULL,
	
	FOREIGN KEY (cid) REFERENCES Client(cid),
	FOREIGN KEY(pid) REFERENCES Produit(pid),

	CONSTRAINT cst_avis CHECK (
		note >= 0.0 AND
		note <= 5.0 AND
		char_length(avis)<=6000 AND
		date_publi <= current_timestamp(0)
		-- condition pour qu'un utilisateur ne puisse donner un avis que sur un produit commandé
	)
);

CREATE TABLE Classe
(
	claid SERIAL PRIMARY KEY,
	nom_classe VARCHAR(255) NOT NULL
);

CREATE TABLE ClasseContientProduit
(
	claid INT NOT NULL,
	pid INT NOT NULL,

	FOREIGN KEY (claid) REFERENCES Classe(claid),
	FOREIGN KEY (pid) REFERENCES Produit(pid)
);

CREATE TABLE EvolutionPrix
(
	pid INT NOT NULL,
	ancien_prix FLOAT NOT NULL,
	nouveau_prix FLOAT NOT NULL,
	date_changement TIMESTAMP NOT NULL,

	PRIMARY KEY (pid, nouveau_prix),
	
	FOREIGN KEY (pid) REFERENCES Produit(pid),

	CONSTRAINT cst_evolution CHECK(
		ancien_prix >= 0 AND
		nouveau_prix >= 0 AND
		date_changement <= current_timestamp(0)
	)
);

CREATE TABLE Panier
(
	paid SERIAL PRIMARY KEY,
	cid INT NOT NULL,
	
	FOREIGN KEY (cid) REFERENCES Client(cid),
	
	CHECK(cid > 0)
);

CREATE TABLE PanierContient
(
	paid INT NOT NULL,
	pid INT NOT NULL,

	FOREIGN KEY (paid) REFERENCES Panier(paid),
	FOREIGN KEY (pid) REFERENCES Produit(pid)
);

CREATE TABLE Ordinateur
(
	pid INT NOT NULL,
	marque_cpu VARCHAR(255) NOT NULL,
	modele_cpu VARCHAR(255) NOT NULL,
	marque_gpu VARCHAR(255) NOT NULL,
	modele_gpu VARCHAR(255) NOT NULL,
	type_stockage VARCHAR(255) NOT NULL,
	capacite_stockage INT,
	type_ram VARCHAR(255),
	ram INT ,
	os VARCHAR(100),

	PRIMARY KEY(pid, marque_cpu),
	
	FOREIGN KEY(pid) REFERENCES Produit(pid),

	CHECK(
		capacite_stockage > 0 AND
		ram > 0
	)
);

CREATE TABLE Laptop
(
	pid INT NOT NULL,
	taille_ecran TEXT NOT NULL,
	carac_ecran TEXT NOT NULL,
	webcam BOOLEAN,
	carte_son VARCHAR(255),

	PRIMARY KEY(pid),
	
	FOREIGN KEY(pid) REFERENCES Produit(pid),

	CONSTRAINT cst_laptop CHECK(
		char_length(carac_ecran)<=6000
	)
);

CREATE TABLE Tablette
(
	pid INT NOT NULL,
	processeur VARCHAR(255) NOT NULL,
	capacite_stockage INT NOT NULL,
	cam_avant BOOLEAN,
	cam_arriere BOOLEAN NOT NULL,

	PRIMARY KEY(pid),
	
	FOREIGN KEY(pid) REFERENCES Produit(pid),

	CHECK(
		capacite_stockage > 0
	)
);

CREATE TABLE Telephone
(
	pid INT NOT NULL,
	processeur VARCHAR(255) NOT NULL,
	capacite_stockage INT NOT NULL,
	cam_avant BOOLEAN,
	cam_arriere BOOLEAN NOT NULL,
	autonomie INT,

	PRIMARY KEY(pid),
	
	FOREIGN KEY(pid) REFERENCES Produit(pid),

	CHECK(
		capacite_stockage > 0 AND
		autonomie > 0  
	)
);

CREATE TABLE Television
(
	pid INT NOT NULL,
	definition VARCHAR(255),
	taille_ecran INT,
	entrees_video VARCHAR(255),
	sorties_audio VARCHAR(255),
	consommation INT,
	assistant BOOLEAN,

	PRIMARY KEY(pid),
	
	FOREIGN KEY(pid) REFERENCES Produit(pid),

	CHECK(
		taille_ecran > 0 AND
		consommation > 0
	)
);

CREATE TABLE AppareilPhoto
(
	pid INT NOT NULL,
	objectif VARCHAR(255) NOT NULL,
	focale INT NOT NULL,

	PRIMARY KEY(pid),
	
	FOREIGN KEY(pid) REFERENCES Produit(pid)
);

CREATE TABLE Enceinte
(
	pid INT NOT NULL,
	puissance INT NOT NULL,
	autonomie INT NOT NULL,
	portee INT NOT NULL,

	PRIMARY KEY(pid),
	
	FOREIGN KEY(pid) REFERENCES Produit(pid),

	CHECK(
		puissance > 0 AND
		autonomie > 0 AND
		portee > 0
	)
);

CREATE TABLE Casque
(
	pid INT NOT NULL,
	puissance INT NOT NULL,
	autonomie INT NOT NULL,
	portee INT,
	connectique VARCHAR(255) NOT NULL,
	reduction_bruit BOOLEAN,

	PRIMARY KEY(pid),
	
	FOREIGN KEY(pid) REFERENCES Produit(pid)
);
