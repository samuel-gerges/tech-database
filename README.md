L’objectif du projet est la modélisation, le peuplement, et la mise en place d’une base de
données d’un site de e-commerce.

Auteurs
-------

GERGES Samuel

JAMI Adam

Contenu des fichiers
--------------------

* `initialize.sql` est le script d'initialisation de la base de données. Il crée les tables avec les bonnes contraintes de clés étrangères et de clés primaires.

* `copy.sql` est un script qui va copier les données des fichiers CSV (se trouvant dans le répertoire `CSV`) dans les tables.
**Remarque :** Le chemin `path` indiqué dans les commandes `COPY Table FROM path` dans le fichier est un chemin absolu, il faudra donc le remplacer si vous voulez lancer le script sur votre machine.

* `reqs.sql` contient toutes les requêtes des fichiers du répertoire `REQ` concaténées.

Dans quel ordre exécuter les fichiers
-------------------------------------

1. `\i initialize.sql`

2. `\i copy.sql`

3. `\i reqs.sql`
