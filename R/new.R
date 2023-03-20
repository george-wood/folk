#' Define a new prediction task
#'
#' @param data A data frame.
#' @param features A character vector of specifying the columns to be used as features.
#' @param target A string specifying the name of the column to be used as the target variable.
#' @param group A string specifying the name of the column to be used as the group membership variable.
#' @param filter A string specifying filter conditions for the data. For example, `"AGEP > 18 & PINCP > 100"`. Alternatively, a call can be supplied, e.g., `substitute(AGEP > 18 & PINCP > 100)`.
#' @param target_transform A function that will be applied to the target column. For example, `target_transform = function(x) ifelse(x > 1, 1, 0)`.
#' @param group_transform A function that will be applied to the group column.
#' @param preprocess A function that will be applied to all feature columns before the target transform and group transform. For example, `preprocess = function(x) as.integer(x)`.
#' @param postprocess A function that will be applied to all feature columns after the target transform and group transform.
#'
#' @export
new_task <- function(data, features, target, group = NULL, filter = NULL,
                     target_transform = NULL, group_transform = NULL,
                     preprocess = NULL, postprocess = NULL) {

  data <- data.table::as.data.table(data)

  if (!is.null(filter)) {
    if (is.character(filter)) {
      data <- data[eval(parse(text = filter))]
    }
    if (is.call(filter)) {
      data <- data[eval(filter)]
    }
  }

  data <- data[, c(target, group, setdiff(features, group)), with = FALSE]

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

  as_folk_task(data)

}
