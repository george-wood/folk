get_data <- function(root_dir, year, horizon, survey,
                     states = NULL, join_household = FALSE,
                     # density = 1.0, random_seed = 0,
                     download = FALSE) {

  data <- load_acs(
    root_dir    = root_dir,
    year        = year,
    states      = states,
    horizon     = horizon,
    survey      = survey,
    # density     = density,
    # random_seed = random_seed,
    download    = download
  )

  if (join_household) {

    n_person <- nrow(data)

    if (survey != "person") {
      cli::cli_abort("`survey` must be 'person' to join household data.")
    }

    household_data <- load_acs(
      root_dir = root_dir,
      year     = year,
      states   = states,
      horizon  = horizon,
      survey   = "household",
      # serial_filter_list = list(data['SERIALNO']),
      download = download
    )

    household_cols <- union(
      setdiff(names(household_data), names(data)),
      "SERIALNO"
    )

    data[household_data,
         on = "SERIALNO",
         (household_cols) := mget(paste0("i.", household_cols))]

    if (nrow(data) != n_person) {
      cli::cli_abort(
        "Number of rows does not match after join: {nrow(data)} vs {n_person}"
      )
    }
  }

  data

}

