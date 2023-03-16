as_folk <- function(x, source = NULL) {
  UseMethod("as_folk")
}

as_folk.data.frame <- function(x, source = NULL) {
  structure(x, class = folk_class, source = source)
}

as_folk.data.table <- function(x, source = NULL) {
  structure(data.table::setDF(x), class = folk_class, source = source)
}

as_folk.list <- function(x, source = NULL) {
  structure(as.data.frame(x), source = folk_class, source = source)
}

as_folk.tbl <- function(x, source = NULL) {
  structure(as.data.frame(x), class = folk_class, source = source)
}

as_folk_task <- function(x, source = NULL) {
  UseMethod("as_folk_task")
}

as_folk_task.folk_df <- function(x, source = NULL) {
  structure(x, class = folk_task_class, source = source)
}

as_folk_task.data.frame <- function(x, source = NULL) {
  structure(x, class = folk_task_class, source = source)
}

as_folk_task.data.table <- function(x, source = NULL) {
  structure(data.table::setDF(x), class = folk_task_class, source = source)
}

folk_class <- c("data.frame", "folk_df")
folk_task_class <- c("data.frame", "folk_df", "folk_task")
