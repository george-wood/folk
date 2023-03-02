fetch_acs <- function(path, state, year, period, survey) {

  filename <- create_filename(year, survey, state)

  cli::cli_alert_info("Downloading ACS data to {.path {path}/{filename}}")

  url <- httr::modify_url(
    url = "https://www2.census.gov/",
    path = sprintf(
      "programs-surveys/acs/data/pums/%s/%s-Year/csv_%s%s.zip",
      year, period, survey, state
    )
  )

  resp <- httr::GET(url)

  if (httr::http_type(resp) != "application/zip") {
    cli::cli_abort("API did not return zip")
  }

  if (httr::http_error(resp)) {
    cli::cli_abort(
      "ACS API request failed: {httr::status_code(resp)}"
    )
  }

  tmp <- tempfile()
  httr::GET(
    url,
    httr::user_agent("http://github.com/george-wood/folk"),
    httr::write_disk(tmp, overwrite = TRUE),
    httr::progress()
  )
  utils::unzip(zipfile = tmp, exdir = path)
  file.rename(
    from = file.path(
      path,
      grep(utils::unzip(tmp, list = TRUE)$Name,
           pattern = "*.csv", value = TRUE)
    ),
    to = file.path(path, filename)
  )
  unlink(tmp)

  return(filename)
}

create_filename <- function(year, survey, state) {
  sprintf(
    if (year < 2017) "ss%s%s%s.csv" else "psam%s%s%s.csv",
    year, survey, state
  )
}

get_acs <- function(path, state, year, period, survey) {

  checkmate::assert(
    checkmate::check_path_for_output(path, overwrite = TRUE),
    checkmate::check_choice(state, state_hash$keys),
    checkmate::check_int(year, lower = 2014, upper = 2021),
    checkmate::check_choice(period, c(1, 3, 5)),
    checkmate::check_choice(survey, c("p", "h")),
    combine = "and"
  )

  data.table::fread(
    file = file.path(
      path,
      fetch_acs(path, state, year, period, survey)
    ),
    colClasses = list(
      character = c("RT", "SOCP", "SERIALNO", "NAICSP"),
      numeric   = c("PINCP")
    )
  )

  # if (join_household) {
  #   n_person <- nrow(data)

  #   if (survey != "person") {
  #     cli::cli_abort("`survey` must be 'person' to join household data.")
  #   }

  #   household_data <- load_acs(
  #     root_dir = root_dir,
  #     year     = year,
  #     states   = states,
  #     horizon  = horizon,
  #     survey   = "household",
  #     # serial_filter_list = list(data['SERIALNO']),
  #     download = download
  #   )

  #   household_cols <- union(
  #     setdiff(names(household_data), names(data)),
  #     "SERIALNO"
  #   )

  #   data[household_data,
  #     on = "SERIALNO",
  #     (household_cols) := mget(paste0("i.", household_cols))
  #   ]

  #   if (nrow(data) != n_person) {
  #     cli::cli_abort(
  #       "Number of rows does not match after join: {nrow(data)} vs {n_person}"
  #     )
  #   }
  # }

}

state_hash <- list(
  keys = c(
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
