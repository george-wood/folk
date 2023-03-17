#' `folk_task` class
#'
#' @description
#' The `folk_task` class is a subclass of `folk_df` and
#' [`data.frame`][base::data.frame()], created to represent a data object
#' that has been preprocessed using `set_task()`.
#'
#' @section Properties of `folk_task`:
#'
#' Objects of class `folk_task` have:
#' * A `class` attribute of `c("folk_task", "folk_df", "data.frame")`.
#' * A `source` attribute which can be queried to check the data source for
#'   folk data.
#'
#' @section Behavior of `folk_task`:
#'
#' The default behaviour of `folk_task` objects matches that of [data.frame]s.
#' The key difference is that:
#'
#' * If you pass a `folk_task` object to `set_task()`, it will
#'   generate an exception. This prevents the user from inadvertently setting
#'   a task for a data object that has already been preprocessed for another,
#'   possibly different task.
#' * The `source` attribute will be queried to ensure that `folk_task` objects
#'   are directed to the appropriate methods.
#'
#' Inspired by the `tibble`[tibble::tibble()] class, the `folk_task` class
#' implements printing and inspection functionality. This functionality is
#' designed to make it clear to the user which column is the target, which is
#' the group, and which are ordinary features for a particular task.
#'
#' @name folk_task-class
#' @aliases folk_task folk_task-class
#' @seealso `as_folk()`, `print.folk_task()`
NULL
