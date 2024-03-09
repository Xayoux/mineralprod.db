#' Permet de lancer toute la procédure de téléchargement et de précleaning de la base de données myb.
#'
#' @param path_usgs_myb Lien vers la page d'acceuil myb de USGS.
#' @param nb_workers Le nombre de travailleurs.
#' @param folder_path_data Chemin d'accès au répertoire qui contiendra les données téléchargées.
#' @param path_db Chemin d'accès pour l'enregistrement du fichier csv de la base de données.
#'
#' @return Un fichier csv.
#' @export
#'
#' @examples # Pas d'exemple.
db_myb <- function(
    path_usgs_myb = "https://www.usgs.gov/centers/national-minerals-information-center/minerals-yearbook-metals-and-minerals",
    nb_workers = 4,
    folder_path_data = here::here("01-data"),
    path_db = here::here("03-output", "database-mineral-production.csv")
){

  # Télécharger les données
  mineralprod.db::launch_download_myb(
    path_usgs_myb = path_usgs_myb,
    nb_workers = nb_workers,
    folder_path = folder_path_data
  )

  # Merge les données et les pré-clean
  mineralprod.db::create_db_myb(
    folder_data_path = folder_path_data,
    nb_workers = nb_workers,
    path_db = path_db
  )
}
