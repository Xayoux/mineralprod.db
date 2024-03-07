#' Permet de télécharger tous les fichiers excel d'une page du myb USGS
#'
#' @param mineral_page_link Un lien URl vers une page du myb pour un minerais
#'
#' @return Chaque fichier du pyb téléchargé pour le minerais en question
#' @export
#'
#' @examples # Pas d'exemple
download_one_mineral <- function(mineral_page_link){

  # Essaie le code et catch s'il y a une erreur
  tryCatch({

    # Lis la page HTML du minerais souhaité
    html <- rvest::read_html(mineral_page_link)

    # Stocke tous les liens de fichiers xls et xlsx de la page du minerais en cours
    excel_link_list <-
      html |>
      rvest::html_nodes(".tex2jax_process") |>
      rvest::html_elements("ul") |>
      rvest::html_elements("li") |>
      rvest::html_elements("a") |>
      rvest::html_attr("href")

    # Garde uniquement les ficheirs xlsx/xls
    excel_link_list <- excel_link_list[grep("\\.(xlsx|xls)$", excel_link_list)]

    # Enlève les fichiers quaterly
    excel_link_list <- excel_link_list[!grepl("\\d{4}q\\d", excel_link_list)]
    excel_link_list <- excel_link_list[!grepl("\\d{6}", excel_link_list)]

    # Créer le répertoire pour les fichiers du minerais
    repertory_path <-
      here::here(
        "01-data",
        sub(".*/", "", mineral_page_link) # Garder que le nom du minerais
      )

    ifelse(dir.exists(repertory_path) == FALSE, dir.create(repertory_path))

    # Créer les liens d'enregistrement des fichiers
    liste_path <-
      paste(
        repertory_path,
        "/",
        sub(".*/", "", excel_link_list), # Garder que le nom du fichier
        sep = ""
      )

    # Télécharger tous les fichiers de la page en cours
    purrr::walk2(excel_link_list, liste_path, mineralprod.db::download_one_file)
  }, error = function(e){})
}
