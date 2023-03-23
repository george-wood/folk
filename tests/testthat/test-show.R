test_that("For ACS data, show_tasks() returns a list of functions", {
  some_tasks <- show_tasks(alabama)
  expect_true(is.list(some_tasks))
  expect_true(all(sapply(some_tasks, is.function)))
})

test_that("show_tasks() warns when providing generic data frame", {
  expect_message(show_tasks(data.frame(a = 1)))
})
