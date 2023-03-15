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

  data.table::setDT(data)

  if (!is.null(filter)) {
    if (is.character(filter)) {
      data <- data[eval(parse(text = filter))]
    }
    if (is.call(filter)) {
      data <- data[eval(filter)]
    }
  }

  data <- data[, c(target, features), with = FALSE]

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

#' Set a prediction task
#'
#' @param data A data frame.
#' @param task A character string for the prediction task. See [show_tasks()].
#'
#' @export
set_task <- function(data, task) {
  UseMethod("set_task")
}

#' @export
set_task.acs <- function(data, task) {
  task_fun <- show_tasks(data)[[task]]
  do.call(
    new_task,
    c(list(data = data), formals(task_fun))
  )
}

#' @export
set_task.default <- function(data, task) {
  cli::cli_abort(
    "`set_task()` is not yet available for this object type."
  )
  invisible(FALSE)
}

#' Display available prediction tasks for a data object
#'
#' @param data A data frame.
#'
#' @export
show_tasks <- function(data) {
  UseMethod("show_tasks")
}

#' @export
show_tasks.acs <- function(data) {
  list(
    income = set_task_income,
    employment = set_task_employment,
    health_insurance = set_task_health_insurance,
    public_coverage = set_task_public_coverage,
    travel_time = set_task_travel_time,
    mobility = set_task_mobility,
    employment_filtered = set_task_employment_filtered,
    income_poverty_ratio = set_task_income_poverty_ratio
  )
}

#' @export
show_tasks.default <- function(data) {
  cli::cli_abort(
    "No tasks available for this object type.
    Consider using `new_task()` to define a custom task."
  )
  invisible(FALSE)
}

