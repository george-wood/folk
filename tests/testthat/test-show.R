test_that("For ACS data, show_tasks() returns a list of functions", {
  data <- as_folk(read.csv(folk_example("acs_example.csv")))
  some_tasks <- show_tasks(data)
  expect_true(is.list(some_tasks))
  expect_true(all(sapply(some_tasks, is.function)))
})

test_that("show_tasks() aborts when providing generic data frame", {
  expect_error(show_tasks(data.frame(a = 1)))
})
