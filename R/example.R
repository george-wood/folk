#' Get path to folk example
#'
#' folk comes bundled with example files in its `inst/extdata`
#' directory. This function make them easy to access.
#'
#' @param path Name of file. If `NULL`, the example files will be listed.
#' @export
#' @examples
#' folk_example()
#' folk_example("acs_example.csv")
folk_example <- function(path = NULL) {
  if (is.null(path)) {
    dir(system.file("extdata", package = "folk"))
  } else {
    system.file("extdata", path, package = "folk", mustWork = TRUE)
  }
}
