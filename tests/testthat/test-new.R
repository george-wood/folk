test_that("columns are ordered as target, group, features", {
  features <- sample(colnames(alabama), size = 10, replace = FALSE)
  tsk <- new_task(
    alabama, target = "WKW", group = "RAC1P", features = features,
  )
  expect_equal(colnames(tsk), c("WKW", "RAC1P", features))
})

test_that("filter reduces the number of rows returned", {
  tsk <- new_task(
    alabama, target = "WKW", features = "WKHP",
    filter = "AGEP > 18 & PINCP > 100"
  )
  expect_lt(nrow(tsk), nrow(alabama))
})

test_that("when filter is NULL, all input rows are returned", {
  tsk <- new_task(
    alabama, target = "WKW", features = "WKHP",
    filter = NULL
  )
  expect_equal(nrow(tsk), nrow(alabama))
})

test_that("target is transformed by arbitrary function", {
  target <- "WKW"
  tsk <- new_task(
    alabama, target = target, features = "WKHP",
    target_transform = function(x) ifelse(is.na(x), 0, x)
  )
  expect_true(all(is.na(tsk[[target]]) == "FALSE"))
})

test_that("group is transformed by arbitrary function", {
  group <- "RAC1P"
  tsk <- new_task(
    alabama, target = "WKW", features = "WKHP",
    group = group,
    group_transform = function(x) ifelse(x >= 2, 2, 1)
  )
  expect_true(all(tsk[[group]] %in% c(1, 2)))
})



