
<!-- README.md is generated from README.Rmd. Please edit that file -->

# mineralprod.db

<!-- badges: start -->
<!-- badges: end -->

Le but de mineralprod.db est de télécharger tous les fichiers excel du
mineral yearbook de USGS, puis de les fusionner en une seule base de
données relativement propre. Cette base de données contient uniquement
les données de production par pays pour les minerais qui ont accès à
cette information dans la dernière feuille de leur fichier excel. La
base de données n’est pas entièrement nettoyée et demande du travail au
cas par cas, selon les minerais utilisées.

## Installation

Pour installer le package mineralprod.db, il faut télécharger le fichier
zip puis l’extraire. Ouvrez le fichier `mineralprod.db.Rproj`. Ensuite
dans la console, faire :

``` r
# Installer devtools si ce n'est pas déjà fait
install.packages("devtools")
library(devtools)
load_all()
instal()
```

Le package mineralprod.db est maintenant installé et peut être chargé
grâce à `library(mineralprod.db)`

## Principales fonctions

Les fonctions ainsi que les paramètres par défauts utilisent la fonction
`here::here()`. De ce fait, il est recommandé lors de l’utilisation des
fonctions de ce package, de travailler dans un répertoire disposant d’un
fichier `.Rproj`.

Le package `mineralprod.db` fonctionne principalement grâce à des
fonctions imbriquées. La principale fonction à utiliser est la fonction
`db_myb()`. Cette fonction permet de télécharger et créer la base de
données. Par défaut, les données seront stockées dans un dossier nommé
`01-data` tandis que la base sera stockée dans un dossier nommé
`03-output`. Il est possible de modifier cela grâce aux paramètres de la
fonction (faire `?db_myb` pour voir l’aide sur cette fonction). Pour
gagner du temps d’exécution, certaines étapes s’effectuent en parallèle.
Par défaut le nombre de “travailleurs” est de 4, mais selon la
configuration de l’ordinateur il est possible d’ajouter ou bien de
diminuer le nombre de travailleurs.

Pour effectuer le téléchargement et le nettoyage des données séparément
:

``` r
launch_download_myb() # pour télécharger tous les fichiers + s'assurer de la bonne exécution du processus en enregistrant les messages d'erreurs potentiels (nottament en cas de lien défectueux ou de fichiers corrompus)

download_all_myb() # pour télécharger tous les fichiers excel sans les précautions précédemment indiquées

create_db_myb() # pour fusionner et nettoyer les données
```

## Sous-fonctions

Ces fonctions servent de sous-fonctions aux fonctions principales. Mais
elles peuvent être utilisées séparément pour le cas où l’utilisateur
voudrait juste un fichier, un minerais…

``` r
download_one_file() # Permet de télécharger un fichier grâce à son URL

download_one_mineral() # Permet de télécharger tous les fichiers concernant un minerais

rm_empty_file() # Supprime un fichier si sa taille est inférieure à 2ko

clean_myb_file() # Permet de nettoyer un fichier xlsx ou xls
```

## Présentation de la base obtenue

La base obtenue regroupe toutes les données de production de 1998 à 2022
(les données gardées sont celles disponibles dans le fichier le plus
récent.

La base comprend 8 variables :

- `country` : les pays qui produisent (certains minerais ne disposent
  pas de pays d’où la nécessité de vérifier/nettoyer au cas par cas.
  Certains pays peuvent avoir une lettre supplémentaire à la fin
  (généralement un e) à cause des notes dans les fichiers de USGS.

- `year` : L’année de production.

- `prod_value` : la valeur de la production indiquée par USSG (attention
  aux unités et métriques utilisées).

- `product` : le produit.

- `metric` : l’unité de mesure telle qu’indiquée par USGS.

- `metric_unit` : extraction de la métrique de USGS (soit tons, kg,
  carats, cubic).

- `multiplicator`: indique par combien les données doivent être
  multipliées pour avoir les données ajustées (en fonction de l’unité
  des métriques (ex : thousand tons = \*1000)

- `prod_value_adjust_metric` : La valeur ajustée de production, ajustée
  en fonction du multiplicateur.

## Créer .Rproj

Dans une session R, aller dans `File` -\> `New project`, sélectionner
l’endroit ou créer le projet, puis créer le projet.
