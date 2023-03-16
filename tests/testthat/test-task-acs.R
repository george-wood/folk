test_that("set_task_() returns a task_df object for acs source data", {
  data <- as_folk(read.csv(folk_example("acs_example.csv")))
  all_tasks <- sapply(names(show_tasks(data)),
                      function(x) set_task(data, task = x))

  expect_true(
    identical(
      unlist(unique(lapply(all_tasks, class))),
      folk_task_class
    )
  )
})
