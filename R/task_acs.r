define_task_ <- function(data, features, target, group = NULL,
                         target_transform = NULL, group_transform = NULL,
                         preprocess = NULL, postprocess = NULL) {

  data <- data.table::setDT(data)[, c(target, features), with = FALSE]

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

  print(apply(data, 2, class))

  data.table::setDF(data)[]

}

define_task_employment <- function(data) {

  define_task_(
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
    target_transform = function(x) {
      factor(data.table::fifelse(x == 1, 1, 0, na = 0))
    },
    group_transform = NULL,
    preprocess = NULL,
    postprocess = function(x) {
      data.table::fifelse(is.na(x), -1L, x)
    }
  )

}

