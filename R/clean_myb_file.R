#' Permet de clean un fichier excel du myb de façon standardisée
#'
#' @param excel_path Un chemin d'accès vers un fichier excel du myb
#'
#' @return Un dataframe du myb clean
#' @export
#'
#' @examples # Pas d'exemple
clean_myb_file <- function(excel_path){
  options(scipen = 999)

  tryCatch({

    # Open the excel file at the last sheets
    #(prod data are always in the last sheets)
    # Method differs between xls and xlsx files

    if (endsWith(excel_path, ".xls")){
      df_single_production <-
        readxl::read_excel(
          excel_path,
          sheet = length(readxl::excel_sheets(excel_path)),
          na = c("--", "-", " ", "W", "w")
        )
    } else if (endsWith(excel_path, ".xlsx")){
      df_single_production <-
        readxl::read_excel(
          excel_path,
          sheet = length(openxlsx::getSheetNames(excel_path)),
          na = c("--", "-", " ", "W", "w")
        )
    }

    # Teste si le dataframe à plus de 5 lignes (car l'entpete prend 5 lignes)

    if(nrow(df_single_production)>=5){
      # Test whether the file is a production-country file for minerals
      # ie : if the title contained "world...production"
      is_a_df_prod_file <-
        grepl("world.*production", df_single_production[1,1], ignore.case = TRUE)

      # and if the name of column 1 is at row 5 and contained "country" or "locality"
      is_a_df_prod_country_file <-
        grepl("country|locality", df_single_production[5,1], ignore.case = TRUE)

      # If this is the case : then clean the data
      if (is_a_df_prod_file == TRUE & is_a_df_prod_country_file == TRUE){

        # Stock the name of the mineral
        product_name <- stringr::str_split(df_single_production[1,1], ":")[[1]][[1]]

        # Stock the metric unit to adjust for each mineral later
        metric_measure <- unlist(df_single_production[3,1])

        df_single_production <-
          df_single_production |>

          # Set variable names with the values at the row 5
          stats::setNames(unlist(dplyr::slice(df_single_production, 5))) |>
          janitor::clean_names() |>

          # Drop variable that are na's (columns for annotations in excel)
          dplyr::select(!dplyr::starts_with("na")) |>

          # Rename the first variable to allow the row bindings
          dplyr::rename_with(~"country", 1) |>

          # Remove the first row which is just the variables names
          dplyr::filter(
            dplyr::row_number() > 1
          ) |>

          # Make all variables in character to avoid merging issues
          dplyr::mutate_all(as.character) |>

          # Pivot the table to have all in columns
          tidyr::pivot_longer(
            cols = dplyr::starts_with("x"),
            names_to = "year",
            values_to = "prod_value"
          ) |>

          # Add product name and metrics
          dplyr::mutate(
            product = tolower(product_name),
            metric = metric_measure,

            # Enlève tous les caractères qui ne sont pas des années
            year = sub(".*\\D(\\d{4}).*", "\\1", year),

            # Enlève les parenthèses et leur contenu et supprime les espace s'il y en a
            prod_value = stringr::str_trim(stringr::str_replace_all(prod_value, "\\(.*\\)", "")),

            # Enlève toutes les lettres dans les valeurs (notes)
            prod_value = stringr::str_replace_all(prod_value, "[[:alpha:]]", ""),

            # Met NA si jamais la valeur est une chaine de carcactère vide
            prod_value = dplyr::if_else(prod_value == "", NA, prod_value),
            last_year_available = max(year, na.rm = TRUE),

            # Enlève tous les chiffres (si chiffre c'est que c'est une footnote)
            country = stringr::str_remove_all(country, "\\d"),

            # Enlève toutes les occurences d'une virgule et ce qui suit (notes)
            country = stringr::str_replace_all(country, ",.*", ""),

            # Enlève les espaces
            country = stringr::str_trim(country)
          )

        # Remove rows who have just na's
        df_single_production <-
          stats::na.omit(df_single_production[, 1:(ncol(df_single_production) - 1)])

        df_single_production <-
          df_single_production |>

          # Enlève les lignes qui sont country ou locality dans la variable country
          dplyr::filter(
            !grepl("country|locality", country, ignore.case = TRUE)
          ) |>
          dplyr::mutate(

            # Extraire la métrique utilisée pour les valeurs de production
            metric_unit =
              dplyr::case_when(
                grepl("tons", metric, ignore.case = TRUE) == TRUE ~ "tons",
                grepl("kilograms", metric, ignore.case = TRUE) == TRUE ~ "kg",
                grepl("cubic", metric, ignore.case = TRUE) == TRUE ~ "cubic",
                grepl("carats", metric, ignore.case = TRUE) == TRUE ~ "carats",
                metric == "(Metric)" & product == "zeolites" ~ "tons"
              ),

            # Extraire le scalaire multiplicateur
            multiplicator =
              dplyr::case_when(
                grepl("thousand", metric, ignore.case = TRUE) == TRUE ~ 1000,
                grepl("million", metric, ignore.case = TRUE) == TRUE ~ 1000000,
                .default = 1
              ),

            # Transformer les données de production en valeurs numériques
            prod_value = as.numeric(prod_value),

            # Calculer les productions ajustées par le scalaire
            prod_value_adjust_metric = prod_value * multiplicator
          ) |>

          # Garder uniquement les variables d'intérêt
          dplyr::select(
            country, year,prod_value, product, metric,
            metric_unit, multiplicator, prod_value_adjust
          )

        return(df_single_production)

      }
    }
  }, error = function(e){})
}
