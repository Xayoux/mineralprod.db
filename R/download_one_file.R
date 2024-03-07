#' Permet de télécharger un ficheir à partir de son url et d'enregistrer un message d'erreur s'il y en a.
#'
#' @param excel_file_link Une URl vers un fichier.
#' @param excel_file_path Un chemin d'accès vers l'endroit où le ficheir doit être enregistré.
#'
#' @return Un fichier téléchargé et/ou un document d'erreur.
#' @export
#'
#' @examples # Pas d'exemple
download_one_file <- function(excel_file_link, excel_file_path){

  # Teste si le fichier existe déjà
  if (file.exists(excel_file_path) == FALSE){

    # Essaie le code
    tryCatch({

      # Télécharge le fichier et l'enregistre au bon endroit
      utils::download.file(
        excel_file_link,
        destfile = excel_file_path,
        mode = "wb"
      )
    }, error = function(e){

      # S'il y a une erreur enregistre un fichier avec le message d'erreur
      messages_error_download_file <- file("messages-errors-downloads.txt", open = "a")
      writeLines(paste(excel_file_link, "\n", e$message, "\n\n"), messages_error_download_file)
      close(messages_error_download_file)

      # S'il y a une erreur enregistrer dans un fichier le lien
      links_download_file <- file("links-errors-downloads.txt", open = "a")
      writeLines(excel_file_link, links_download_file)
      close(links_download_file)
    })
  }
}
