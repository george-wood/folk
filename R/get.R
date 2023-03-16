#' Get a Public Use Microdata Sample from the American Community Survey
#'
#' @param state The state for which you are requesting data. Must be a two-letter abbreviation, e.g. `"ny"`.
#' @param year The year of the ACS data. Must be an integer between `2014` and `2021`, inclusive.
#' @param period The period of the ACS data collection. Either `1` or `5`. The ACS provides 1-Year and 5-Year estimates. For example, the 5-Year estimates for the year 2021 uses 60 months of collected data between January 1, 2017 and December 31, 2021
#' @param survey Either `p` or `h`. If `p`, person-level data will be returned. If `h`, household-level data will be returned.
#' @param path Either `NULL` or a path to a directory. If `NULL`, the data will be downloaded to a temporary file that will later be removed. If a path is given, the data will be downloaded to a subdirectory of that path.
#' @param join_household If `FALSE`, return either person or household survey data according to the `survey` argument. If `TRUE`, join household survey data to the person data. To join household data, the `survey` argument must be `p`.
#'
#' @return A data frame (`data.frame`) containing a Public Use Microdata Sample (PUMS) from the American Community Survey (ACS).
#' @export
get_acs <- function(state, year, period, survey, path = NULL,
                    join_household = FALSE) {

  assert_args_acs(
    state = state,
    year = year,
    period = period,
    survey = survey,
    path = path
  )

  data <- withCallingHandlers(
    fetch_acs(state, year, period, survey, path),
    warning = muffle_fread_cols
  )

  if (join_household) {
    if (survey != "p") {
      cli::cli_abort("`survey` must be 'p' to join household data.")
    }

    household <- withCallingHandlers(
      fetch_acs(state, year, period, survey = "h", path),
      warning = muffle_fread_cols
    )

    n <- nrow(data)
    cols <- union(setdiff(names(household), names(data)), "SERIALNO")
    data[household, on = "SERIALNO", (cols) := mget(paste0("i.", cols))]

    if (nrow(data) != n) {
      cli::cli_abort(
        "Number of rows does not match after join: {nrow(data)} vs {n}"
      )
    }
  }

  as_folk(data, source = "acs")

}

fetch_acs <- function(state, year, period, survey, path = NULL) {

  url <- httr::modify_url(
    url = "https://www2.census.gov/",
    path = sprintf(
      "programs-surveys/acs/data/pums/%s/%s-Year/csv_%s%s.zip",
      year, period, survey, state
    )
  )

  resp <- httr::HEAD(url)

  if (httr::http_type(resp) != "application/zip") {
    cli::cli_abort("API did not return zip")
  }

  if (httr::http_error(resp)) {
    cli::cli_abort("API request failed: {httr::status_code(resp)}")
  }

  cli::cli_alert_info("Downloading data...")

  tmp <- tempfile()

  httr::GET(
    url,
    httr::user_agent("http://github.com/george-wood/folk"),
    httr::write_disk(tmp, overwrite = TRUE),
    httr::progress()
  )

  csv_name <- grep(
    x = utils::unzip(tmp, list = TRUE)$Name,
    pattern = "*.csv",
    value = TRUE
  )

  if (is.null(path)) {
    utils::unzip(zipfile = tmp, exdir = dirname(tmp))
    unzipped <- file.path(dirname(tmp), csv_name)
  } else {
    outdir <- create_path_acs(path, year, period)
    utils::unzip(zipfile = tmp, exdir = outdir)
    unzipped <- file.path(outdir, csv_name)
    cli::cli_alert_info("Data downloaded to {.path {unzipped}}")
  }

  return(
    data.table::fread(
      unzipped,
      colClasses = list(
        character = c("RT", "SOCP", "SERIALNO", "NAICSP"),
        numeric   = c("PINCP")
      )
    )
  )

  unlink(tmp)

}

create_path_acs <- function(path, year, period) {
  file.path(path, year, sprintf("%s-Year", period))
}

muffle_fread_cols <- function(x) {
  if (grepl(R"(Column name '.*' \(colClasses\[\[.*\]\]\[.*\]\) not found)",
            x$message)) {
    invokeRestart("muffleWarning")
  } else {
    message(x$message)
  }
}

assert_args_acs <- function(state, year, period, survey, path) {
  checkmate::assert(
    checkmate::check_choice(state, choices = state_hash$key),
    checkmate::check_choice(period, choices = c(1, 5)),
    checkmate::check_choice(survey, choices = c("p", "h")),
    checkmate::check_int(year, lower = 2014, upper = 2021),
    combine = "and"
  )
  checkmate::assert(
    checkmate::check_null(path),
    checkmate::check_path_for_output(path, overwrite = TRUE),
    combine = "or"
  )
}

state_hash <- list(
  key = c(
    "al", "ak", "az", "ar", "ca",
    "co", "ct", "de", "fl", "ga",
    "hi", "id", "il", "in", "ia",
    "ks", "ky", "la", "me", "md",
    "ma", "mi", "mn", "ms", "mo",
    "mt", "ne", "nv", "nh", "nj",
    "nm", "ny", "nc", "nd", "oh",
    "ok", "or", "pa", "ri", "sc",
    "sd", "tn", "tx", "ut", "vt",
    "va", "wa", "wv", "wi", "wy",
    "pr"
  ),
  value = c(
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
