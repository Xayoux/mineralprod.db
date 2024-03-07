#' Permet de récupérer les liens de toutes les pages du myb et de lancer les téléchargement des fichiers Excel.
#'
#' @param path_usgs_myb Un lien vers la page d'acceuil du myb de USGS. Le lien est rentré par défaut.
#' @param nb_workers Nombre de travailleurs.
#'
#' @return Tous les fichiers Excel du myb.
#' @export
#'
#' @examples # Pas d'exemple.
download_all_myb <- function(
    path_usgs_myb = "https://www.usgs.gov/centers/national-minerals-information-center/minerals-yearbook-metals-and-minerals",
    nb_workers = 4
){

  # Supprimmer les fichiers d'erreurs s'ils existent
  if(file.exists("links-errors-downloads.txt")){
    file.remove("links-errors-downloads.txt")
  }

  if(file.exists("messages-errors-downloads.txt")){
    file.remove("messages-errors-downloads.txt")
  }

  # Lire la page html du mineral yearbook
  html <- rvest::read_html(path_usgs_myb)

  # Récupérer les liens de toutes les pages
  mineral_pages_link_list <-
    html |>
    rvest::html_nodes(".tex2jax_process") |>
    rvest::html_elements("ul") |>
    rvest::html_elements("li") |>
    rvest::html_elements("a") |>
    rvest::html_attr("href")

  mineral_pages_link_list <-
    subset(
      mineral_pages_link_list,
      mineral_pages_link_list != "NA"
    )

  # Rajouter le début du lien s'il est manquant
  mineral_pages_link_list <-
    ifelse(
      !grepl("^https://", mineral_pages_link_list),
      paste0("https://www.usgs.gov/", mineral_pages_link_list),
      mineral_pages_link_list
    )

  # Setup un travail parallèle avec 4 workers
  future::plan("multisession", Workers = nb_workers)

  # Télécharger chaque page de minerais
  furrr::future_walk(
    mineral_pages_link_list,
    mineralprod.db::download_one_mineral
  )
}
