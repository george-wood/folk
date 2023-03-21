#' Coerce data frames, lists, and more to data frames with as_folk subclass
#'
#' @description
#' `as_folk()` coerces an existing object, such as a data frame or data table,
#' to a data frame with a `folk_df` subclass.
#'
#' @param x A data frame, list, matrix, or other object that could reasonably
#'   be coerced to a data frame.
#' @param source A character vector denoting the source of the data,
#'   e.g., "acs".
#' @export
#' @examples
#' l <- list(a = c(1, 2), b = c(3, 4))
#' as_folk(l)
as_folk <- function(x, source = NULL) {
  UseMethod("as_folk")
}

#' @export
#' @rdname as_folk
as_folk.data.frame <- function(x, source = NULL) {
  structure(x, class = folk_df_class, source = source)
}

#' @export
#' @rdname as_folk
as_folk.list <- function(x, source = NULL) {
  structure(as.data.frame(x), class = folk_df_class, source = source)
}

#' @export
#' @rdname as_folk
as_folk.data.table <- function(x, source = NULL) {
  structure(data.table::setDF(x), class = folk_df_class, source = source)
}

#' @export
#' @rdname as_folk
as_folk.tbl <- function(x, source = NULL) {
  structure(as.data.frame(x), class = folk_df_class, source = source)
}

#' Add a folk_task subclass to folk_df objects
#'
#' @description
#' `as_folk_task()` adds the `folk_task` subclass to an existing folk_df object.
#'
#' @param x A folk_df object.
#' @param source A character vector denoting the source of the data,
#'   e.g., "acs". If NULL, it will be inherited from the object passed to `x`.
#' @export
#' @examples
#' l <- list(a = c(1, 2), b = c(3, 4))
#' df <- as_folk(l)
#' as_folk_task(df)
as_folk_task <- function(x, source = NULL) {
  UseMethod("as_folk_task")
}

#' @export
#' @rdname as_folk_task
as_folk_task.folk_df <- function(x, source = NULL) {
  structure(x, class = folk_task_class, source = source)
}

#' @export
#' @rdname as_folk_task
as_folk_task.data.frame <- function(x, source = NULL) {
  structure(x, class = folk_task_class, source = source)
}

#' @export
#' @rdname as_folk_task
as_folk_task.data.table <- function(x, source = NULL) {
  structure(data.table::setDF(x), class = folk_task_class, source = source)
}

folk_df_class <- c("folk_df", "data.frame")
folk_task_class <- c("folk_task", "folk_df", "data.frame")
