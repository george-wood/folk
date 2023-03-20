test_that("set_task_() returns a task_df object for all ACS tasks", {
  tasks <- sapply(
    names(show_tasks(alabama)),
    function(x) set_task(alabama, task = x)
  )

  expect_true(
    identical(
      unlist(unique(lapply(tasks, class))),
      folk_task_class
    )
  )
})

test_that("set_task_() returns logical FALSE", {
  expect_true(
    identical(
      FALSE,
      set_task_income(),
      set_task_employment(),
      set_task_health_insurance(),
      set_task_public_coverage(),
      set_task_travel_time(),
      set_task_mobility(),
      set_task_employment_filtered(),
      set_task_income_poverty_ratio()
    )
  )
})

test_that("set_task_() returns expected column order for all ACS tasks", {
  target   <- eval(formals(set_task_income)[["target"]])
  group    <- eval(formals(set_task_income)[["group"]])
  features <- eval(formals(set_task_income)[["features"]])

  income <- set_task(alabama, task = "income")

  expect_equal(colnames(income), c(target, group, setdiff(features, group)))
})

