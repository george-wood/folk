state_dictionary <- hash::hash(
  keys = c(
    "AL", "AK", "AZ", "AR", "CA",
    "CO", "CT", "DE", "FL", "GA",
    "HI", "ID", "IL", "IN", "IA",
    "KS", "KY", "LA", "ME", "MD",
    "MA", "MI", "MN", "MS", "MO",
    "MT", "NE", "NV", "NH", "NJ",
    "NM", "NY", "NC", "ND", "OH",
    "OK", "OR", "PA", "RI", "SC",
    "SD", "TN", "TX", "UT", "VT",
    "VA", "WA", "WV", "WI", "WY",
    "PR"
  ),
  values = c(
    "01", "02", "04", "05", "06",
    "08", "09", "10", "12", "13",
    "15", "16", "17", "18", "19",
    "20", "21", "22", "23", "24",
    "25", "26", "27", "28", "29",
    "30", "31", "32", "33", "34",
    "35", "36", "37", "38", "39",
    "40", "41", "42", "44", "45",
    "46", "47", "48", "49", "50",
    "51", "53", "54", "55", "56",
    "72"
  )
)

load_acs <- function(root_dir = "data",
                     states = NULL,
                     year = 2018,
                     horizon = "1-Year",
                     survey = "person",
                     density = 1,
                     random_seed = 1,
                     serial_filter_list = NULL,
                     download = FALSE) {


  if (as.integer(year) < 2014) {
    cli::cli_abort("`year` must be >= 2014")
  }

  if (is.null(states)) {
    states <- hash::keys(state_dictionary)
  }

  # if (!is.null(serial_filter_list)) {
  #   serial_filter_list <- unique(serial_filter_list)
  # }

  # set.seed(random_seed)

  base_datadir <- file.path(root_dir, as.character(year), horizon)
  dir.create(base_datadir, recursive = TRUE, showWarnings = FALSE)

  files <- sapply(
    states,
    function(state)
      initialize_and_download(
        base_datadir,
        state,
        year,
        horizon,
        survey,
        download = download
      )
  )

  data.table::rbindlist(
    lapply(
      files,
      function(f)
        data.table::fread(
          f,
          colClasses = list(
            character = c("RT", "SOCP", "SERIALNO", "NAICSP"),
            numeric   = c("PINCP")
          )
        )
    )
  )

}


download_and_extract <- function(url, datadir, remote_fname, file_name,
                                 delete_download = FALSE) {

  download_path <- file.path(datadir, remote_fname)
  utils::download.file(url, download_path)
  utils::unzip(download_path,
               files = file_name,
               exdir = datadir,
               junkpaths = TRUE)

  if (delete_download && download_path != file.path(datadir, file_name)) {
    unlink(download_path)
  }

}


initialize_and_download <- function(datadir,
                                    state,
                                    year,
                                    horizon,
                                    survey,
                                    download = FALSE) {

  if (!horizon %in% c("1-Year", "5-Year")) {
    cli::cli_abort("`horizon` must be '1-Year' or '5-Year'")
  }

  if (as.integer(year) < 2014) {
    cli::cli_abort("`year` must be >= 2014")
  }

  if (!state %in% hash::keys(state_dictionary)) {
    cli::cli_abort("Invalid `state`")
  }


  state_code <- state_dictionary[state]
  survey_code <- switch(
    survey,
    "person" = "p",
    "household" = "h",
    cli::cli_abort("Invalid `survey`")
  )

  if (as.integer(year) >= 2017) {
    file_name <- glue::glue(
      "psam_{survey_code}{state_value}.csv"
    )
  } else {
    file_name <- glue::glue(
      "ss{substr(year, 3, 4)}{survey_code}{tolower(state)}.csv"
    )
  }

  # assume that if path exists and is a file, then it has been downloaded
  file_path <- file.path(datadir, file_name)
  if (!file.exists(file_path) && download == FALSE) {
    cli::cli_abort(
      "Could not find {year} {horizon} {survey} data for {state} in {datadir}.
      Call get_data with `download = TRUE` to download the dataset."
    )
  }

  cli::cli_alert(
    "Downloading data for {year} {horizon} {survey} survey for {state}..."
  )

  # download and extract file
  base_url <- glue::glue(
    "https://www2.census.gov/programs-surveys/acs/data/pums/{year}/{horizon}"
  )
  remote_fname <- glue::glue(
    "csv_{survey_code}{tolower(state)}.zip"
  )
  url <- glue::glue(
    "{base_url}/{remote_fname}"
  )

  withCallingHandlers(
    expr = download_and_extract(url, datadir, remote_fname, file_name,
                                delete_download = TRUE),
    error = function(x) {
      cli::cli_abort(
        "{file.path(datadir, remote_fname)} may be corrupted.
        Please try deleting it and rerunning this command."
      )
    }
  )

  return(file_path)

}






