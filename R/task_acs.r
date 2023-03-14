#' @export
define_task <- function(data, features, target, group = NULL, filter = NULL,
                        target_transform = NULL, group_transform = NULL,
                        preprocess = NULL, postprocess = NULL) {

  data <- data.table::setDT(data)[, c(target, features), with = FALSE]

  if (!is.null(filter)) {
    data <- data[eval(filter)]
  }

  if (!is.null(preprocess)) {
    data[, (features) := lapply(.SD, preprocess), .SDcols = features]
  }

  if (!is.null(target_transform)) {
    data[, (target) := lapply(.SD, target_transform), .SDcols = target]
  }

  if (!is.null(group_transform)) {
    data[, (group) := lapply(.SD, group_transform), .SDcols = group]
  }

  if (!is.null(postprocess)) {
    data[, (features) := lapply(.SD, postprocess), .SDcols = features]
  }

  data.table::setDF(data)[]

}

filter_adult <- substitute(
  AGEP > 16 & PINCP > 100 & WKHP > 0 & PWGTP >= 1
)

#' @export
define_task_income <- function(data) {
  define_task(
    data = data,
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
  )
}

#' @export
define_task_employment <- function(data) {
  define_task(
    data = data,
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
  )
}

#' @export
define_task_health_insurance <- function(data) {
  define_task(
    data = data,
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
  )
}

filter_public_coverage <- substitute(
  AGEP < 65 & PINCP <= 30000
)

#' @export
define_task_public_coverage <- function(data) {
  define_task(
    data = data,
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
  )
}

filter_travel_time <- substitute(
  AGEP > 16 & PWGTP >= 1 & ESR == 1
)

#' @export
define_task_travel_time <- function(data) {

  define_task(
    data = data,
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
  )

}

filter_mobility <- substitute(
  AGEP > 18 | AGEP < 35
)

#' @export
define_task_mobility <- function(data) {
  define_task(
    data = data,
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
  )
}

filter_employment <- substitute(
  AGEP > 16 & AGEP < 90 & PWGTP >= 1
)

#' @export
define_task_employment_filtered <- function(data) {
  define_task(
    data = data,
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
  )
}

#' @export
define_task_income_poverty_ratio <- function(data) {
  define_task(
    data = data,
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
  )
}

