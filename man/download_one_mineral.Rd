% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/download_one_mineral.R
\name{download_one_mineral}
\alias{download_one_mineral}
\title{Permet de télécharger tous les fichiers excel d'une page du myb USGS}
\usage{
download_one_mineral(mineral_page_link, folder_path = here::here("01-data"))
}
\arguments{
\item{mineral_page_link}{Un lien URL vers une page du myb pour un minerais}

\item{folder_path}{Chemin d'accès au dossier d'enregistrement des fichiers}
}
\value{
Chaque fichier du myb téléchargé pour le minerais en question
}
\description{
Permet de télécharger tous les fichiers excel d'une page du myb USGS
}
\examples{
# Pas d'exemple
}
