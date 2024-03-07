#' Permet de lancer le processus de téléchargement du myb en limitant les risques d'erreur grâce à un fichier compilant les messages d'erreur.
#'
#' @param path_usgs_myb Un lien vers la page d'acceuil du myb de USGS. Le lien est rentré par défaut.
#'
#' @return Tous les fichiers Excel du myb.
#' @export
#'
#' @examples # Pas d'exemple.
launch_download_myb <- function(
    path_usgs_myb = "https://www.usgs.gov/centers/national-minerals-information-center/minerals-yearbook-metals-and-minerals"
){

  # Supprimer le fichier d'erreur globale s'il existe
  if(file.exists("messages-errors-global.txt")){
    file.remove("messages-errors-global.txt")
  }

  # Ajouter répertoire 01-data s'il n'existe pas
  if (dir.exists(here::here("01-data")) == FALSE){
    dir.create(here::here("01-data"))
  }

  # Tester le code
  tryCatch({

    # Exécute la fonction pour télécharger tout le myb
    mineralprod.db::download_all_myb(path_usgs_myb)

  }, error = function(e){
    # Ecris un fichier contenant les messages d'erreurs qui pourraient survenir
    messages_error_global <- file("messages-errors-global.txt", open = "a")
    writeLines(e$message, messages_error_global)
    close(messages_error_global)
  })
}
