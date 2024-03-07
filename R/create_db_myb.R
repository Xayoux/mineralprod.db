#' Permet de créer la databse myb sur la production des minerais à partir des données déjà téléchargées.
#'
#' @param folder_data_path Chemin d'accès à l'endroit où sont stockées les données.
#' @param nb_workers Nombre de travailleurs.
#' @param path_db Chemin d'accès pour enregistrer la database.
#'
#' @return Un fichier csv.
#' @export
#'
#' @examples # Pas d'exemple.
create_db_myb <- function(
    folder_data_path = here::here("01-data"),
    nb_workers = 4,
    path_db = here::here("03-output",
                         "database-mineral-production.csv")){

  # Delete previous error file if it exists
  if (file.exists("errors-in-xls-modifications.txt")){
    file.remove("errors-in-xls-modifications.txt")
  }

  # Setup le nombre de travailleurs
  future::plan(future::multisession, workers = nb_workers)

  # Remove empty excel files
  folder_data_path |>
    list.files(recursive = TRUE, full.names = TRUE) |>
    furrr::future_walk(mineralprod.db::rm_empty_file)

  future::plan(future::multisession, workers = nb_workers)
  # Clean and merge data
  df_production_global <-
    folder_data_path |>
    list.files(recursive = TRUE, full.names = TRUE) |>
    furrr::future_map(mineralprod.db::clean_myb_file)

  df_production_global <-
    df_production_global |>
    dplyr::bind_rows()


  # Si le chemin d'enregistrement n'est pas changé, vérifier que le dossier existe bien
  if (path_db == here::here("03-output", "database-mineral-production.csv")){
    ifelse(dir.exists(here::here("03-output")) == FALSE, dir.create(here::here("03-output")))
  }

  readr::write_csv(
    df_production_global,
    path_db
  )
}
