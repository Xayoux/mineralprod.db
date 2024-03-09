#' Permet de supprimer les fichiers vides inutiles.
#'
#' @param excel_path Un chemin d'accès vers un fichier.
#'
#' @return Des dossiers supprimés.
#' @export
#'
#' @examples # Pas d'exemple
rm_empty_file <- function(excel_path){

  # Calcule la taille du fichier
  excel_size_info <- file.info(excel_path)$size / 1024

  # Si la taille du fichier est inférieur à 2ko, on le supprime
  if (excel_size_info <= 2){
    file.remove(excel_path)
  }
}
