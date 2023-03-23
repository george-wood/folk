#' Display available prediction tasks for a data object
#'
#' @param data A data frame.
#'
#' @export
show_tasks <- function(data) {
  UseMethod("show_tasks")
}

#' @export
show_tasks.folk_df <- function(data) {

  source <- attr(data, "source")

  if (is.null(source)) {
    cli::cli_alert_warning(
      "No tasks available for this object.
      Consider using `new_task()` to define a custom task.",
      wrap = TRUE
    )
  }

  if (source == "acs") {
    list(
      income               = task_income,
      employment           = task_employment,
      health_insurance     = task_health_insurance,
      public_coverage      = task_public_coverage,
      travel_time          = task_travel_time,
      mobility             = task_mobility,
      employment_filtered  = task_employment_filtered,
      income_poverty_ratio = task_income_poverty_ratio
    )
  }

}

#' @export
show_tasks.default <- function(data) {
  cli::cli_alert_warning(
    "No tasks available for this object type.
    Consider using `new_task()` to define a custom task.",
    wrap = TRUE
  )
  invisible(FALSE)
}

#' Display definition of a folk task object
#'
#' @param data A folk_task object.
#'
#' @export
show_definition <- function(data) {
  attr(data, "definition")
}
