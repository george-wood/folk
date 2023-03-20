test_that("set_task() returns an object with folk_task subclass", {
  my_task <- set_task(alabama, task = "income")
  expect_identical(class(my_task), folk_task_class)
})

test_that("set_task() generates exception for non-folk_df subclass", {
  expect_error(set_task(data.frame(x = 1)), regexp = "not yet available")
})
