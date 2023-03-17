test_that("set_task_() returns a task_df object for acs source data", {
  tasks <- sapply(names(show_tasks(alabama)),
                  function(x) set_task(alabama, task = x))

  expect_true(
    identical(
      unlist(unique(lapply(tasks, class))),
      folk_task_class
    )
  )
})
