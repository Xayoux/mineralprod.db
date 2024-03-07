#' Allow to download a file with is URL if it doesn't exist already. Write an error message in a document if there is an error.
#'
#' @param excel_file_link An url link leading to an excel file
#' @param excel_file_path A path indicating where the file should be save
#'
#' @return A saving file or an error document
#' @export
#'
#' @examples #No example
download_one_file <- function(excel_file_link, excel_file_path){
  if (file.exists(excel_file_path) == FALSE){
    tryCatch({
      utils::download.file(
        excel_file_link,
        destfile = excel_file_path,
        mode = "wb"
      )
    }, error = function(e){
      messages_error_download_file <- file("messages-errors-downloads.txt", open = "a")
      writeLines(paste(excel_file_link, "\n", e$message, "\n\n"), messages_error_download_file)
      close(messages_error_download_file)

      links_download_file <- file("links-errors-downloads.txt", open = "a")
      writeLines(excel_file_link, links_download_file)
      close(links_download_file)
    })
  }
}
