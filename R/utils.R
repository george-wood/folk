binary_target_ <- function(cond) {
  factor(data.table::fifelse(cond, 1, 0, na = 0))
}

replace_na_ <- function(x, value = -1L) {
  data.table::fifelse(is.na(x), value, x)
}
