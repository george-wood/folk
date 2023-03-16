#' `folk_df` class
#'
#' @description
#' The `folk_df` class is a subclass of [`data.frame`][base::data.frame()],
#' created in order to allow method dispatch, object verification, and
#' consistency checking when using the folk package.
#'
#' @section Properties of `folk_df`:
#'
#' Objects of class `folk_df` have:
#' * A `class` attribute of `c("data.frame", "folk_df")`.
#' * A `source` attribute which can be queried to check the data source for
#'   folk data. This attribute is used primarily to ensure that `folk_df`
#'   objects are directed to the appropriate prediction tasks provided by the
#'   folk package.
#'
#' @section Behavior of `folk_df`:
#'
#' The default behaviour of `folk_df` objects matches that of [data.frame]s. The
#' key difference is that:
#'
#' * If you run a function provided by the folk package, it will typically check
#'   that an object has the class `folk_df` or is coercible to `folk_df`.
#' * The `source` attribute will be queried to ensure that the `folk_df` object
#'   can be used by the appropriate functions.
#'
#' @name folk_df-class
#' @aliases folk_df folk_df-class
#' @seealso `as_folk()`
NULL
