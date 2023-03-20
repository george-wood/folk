filter_adult <- substitute(
  AGEP > 16 & PINCP > 100 & WKHP > 0 & PWGTP >= 1
)

set_task_income <- function(
    features = c("AGEP",
                 "COW",
                 "SCHL",
                 "MAR",
                 "OCCP",
                 "POBP",
                 "RELP",
                 "WKHP",
                 "SEX",
                 "RAC1P"),
    target = "PINCP",
    group = "RAC1P",
    filter = filter_adult,
    target_transform = function(x) binary_target_(x > 50000),
    group_transform = NULL,
    preprocess = NULL,
    postprocess = replace_na_
) {
  cli::cli_alert_info(
    "Setting {.strong income} prediction task.
    See {.fn folk::set_task_income} for details.",
    wrap = TRUE
  )
  invisible(FALSE)
}

set_task_employment <- function(
    features = c("AGEP",
                 "SCHL",
                 "MAR",
                 "RELP",
                 "DIS",
                 "ESP",
                 "CIT",
                 "MIG",
                 "MIL",
                 "ANC",
                 "NATIVITY",
                 "DEAR",
                 "DEYE",
                 "DREM",
                 "SEX",
                 "RAC1P"),
    target = "ESR",
    group = "RAC1P",
    filter = NULL,
    target_transform = function(x) binary_target_(x == 1),
    group_transform = NULL,
    preprocess = NULL,
    postprocess = replace_na_
) {
  cli::cli_alert_info(
    "Setting {.strong employment} prediction task.
    See {.fn folk::set_task_employment} for details.",
    wrap = TRUE
  )
  invisible(FALSE)
}

set_task_health_insurance <- function(
    features = c("AGEP",
                 "SCHL",
                 "MAR",
                 "SEX",
                 "DIS",
                 "ESP",
                 "CIT",
                 "MIG",
                 "MIL",
                 "ANC",
                 "NATIVITY",
                 "DEAR",
                 "DEYE",
                 "DREM",
                 "RACAIAN",
                 "RACASN",
                 "RACBLK",
                 "RACNH",
                 "RACPI",
                 "RACSOR",
                 "RACWHT",
                 "PINCP",
                 "ESR",
                 "ST",
                 "FER"),
    target = "HINS2",
    group = "RAC1P",
    filter = NULL,
    target_transform = function(x) binary_target_(x == 1),
    group_transform = NULL,
    preprocess = NULL,
    postprocess = replace_na_
) {
  cli::cli_alert_info(
    "Setting {.strong health insurance} prediction task.
    See {.fn folk::set_task_health_insurance} for details.",
    wrap = TRUE
  )
  invisible(FALSE)
}

filter_public_coverage <- substitute(
  AGEP < 65 & PINCP <= 30000
)

set_task_public_coverage <- function(
    features = c("AGEP",
                 "SCHL",
                 "MAR",
                 "SEX",
                 "DIS",
                 "ESP",
                 "CIT",
                 "MIG",
                 "MIL",
                 "ANC",
                 "NATIVITY",
                 "DEAR",
                 "DEYE",
                 "DREM",
                 "PINCP",
                 "ESR",
                 "ST",
                 "FER",
                 "RAC1P"),
    target = "PUBCOV",
    group = "RAC1P",
    filter = filter_public_coverage,
    target_transform = function(x) binary_target_(x == 1),
    group_transform = NULL,
    preprocess = NULL,
    postprocess = replace_na_
) {
  cli::cli_alert_info(
    "Setting {.strong public coverage} prediction task.
    See {.fn folk::set_task_public_coverage} for details.",
    wrap = TRUE
  )
  invisible(FALSE)
}

filter_travel_time <- substitute(
  AGEP > 16 & PWGTP >= 1 & ESR == 1
)

set_task_travel_time <- function(
    features = c("AGEP",
                 "SCHL",
                 "MAR",
                 "SEX",
                 "DIS",
                 "ESP",
                 "MIG",
                 "RELP",
                 "RAC1P",
                 "PUMA",
                 "ST",
                 "CIT",
                 "OCCP",
                 "JWTR",
                 "POWPUMA",
                 "POVPIP"),
    target = "JWMNP",
    group = "RAC1P",
    filter = filter_travel_time,
    target_transform = function(x) binary_target_(x > 20),
    group_transform = NULL,
    preprocess = NULL,
    postprocess = replace_na_
) {
  cli::cli_alert_info(
    "Setting {.strong travel time} prediction task.
    See {.fn folk::set_task_travel_time} for details.",
    wrap = TRUE
  )
  invisible(FALSE)
}

filter_mobility <- substitute(
  AGEP > 18 | AGEP < 35
)

set_task_mobility <- function(
    features = c("AGEP",
                 "SCHL",
                 "MAR",
                 "SEX",
                 "DIS",
                 "ESP",
                 "CIT",
                 "MIL",
                 "ANC",
                 "NATIVITY",
                 "RELP",
                 "DEAR",
                 "DEYE",
                 "DREM",
                 "RAC1P",
                 "GCL",
                 "COW",
                 "ESR",
                 "WKHP",
                 "JWMNP",
                 "PINCP"),
    target = "MIG",
    group = "RAC1P",
    filter = filter_mobility,
    target_transform = function(x) binary_target_(x == 1),
    group_transform = NULL,
    preprocess = NULL,
    postprocess = replace_na_
) {
  cli::cli_alert_info(
    "Setting {.strong mobility} prediction task.
    See {.fn folk::set_task_mobility} for details.",
    wrap = TRUE
  )
  invisible(FALSE)
}

filter_employment <- substitute(
  AGEP > 16 & AGEP < 90 & PWGTP >= 1
)

set_task_employment_filtered <- function(
    features = c("AGEP",
                 "SCHL",
                 "MAR",
                 "SEX",
                 "DIS",
                 "ESP",
                 "MIG",
                 "CIT",
                 "MIL",
                 "ANC",
                 "NATIVITY",
                 "RELP",
                 "DEAR",
                 "DEYE",
                 "DREM",
                 "RAC1P",
                 "GCL"),
    target = "ESR",
    group = "RAC1P",
    filter = filter_employment,
    target_transform = function(x) binary_target_(x == 1),
    group_transform = NULL,
    preprocess = NULL,
    postprocess = replace_na_
) {
  cli::cli_alert_info(
    "Setting {.strong employment filtered} prediction task.
    See {.fn folk::set_task_employment_filtered} for details.",
    wrap = TRUE
  )
  invisible(FALSE)
}

set_task_income_poverty_ratio <- function(
    features = c("AGEP",
                 "SCHL",
                 "MAR",
                 "SEX",
                 "DIS",
                 "ESP",
                 "MIG",
                 "CIT",
                 "MIL",
                 "ANC",
                 "NATIVITY",
                 "RELP",
                 "DEAR",
                 "DEYE",
                 "DREM",
                 "RAC1P",
                 "GCL",
                 "ESR",
                 "OCCP",
                 "WKHP"),
    target = "POVPIP",
    group = "RAC1P",
    target_transform = function(x) binary_target_(x < 250),
    group_transform = NULL,
    preprocess = NULL,
    postprocess = replace_na_
) {
  cli::cli_alert_info(
    "Setting {.strong income-poverty ratio} prediction task.
    See {.fn folk::set_task_income_poverty_ratio} for details.",
    wrap = TRUE
  )
  invisible(FALSE)
}
