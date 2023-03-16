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

