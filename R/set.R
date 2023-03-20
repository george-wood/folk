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
set_task.folk_df <- function(data, task) {
  do.call(
    new_task,
    c(
      list(data = data),
      formals(show_tasks(data)[[task]])
    )
  )
}

#' @export
set_task.default <- function(data, task) {
  cli::cli_abort(
    "`set_task()` is not yet available for this object type."
  )
}
