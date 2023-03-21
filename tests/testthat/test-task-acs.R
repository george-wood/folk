test_that("task_() returns a task_df object for all ACS tasks", {
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

test_that("task_() returns logical FALSE", {
  expect_false(task_income())
  expect_false(task_employment())
  expect_false(task_health_insurance())
  expect_false(task_public_coverage())
  expect_false(task_travel_time())
  expect_false(task_mobility())
  expect_false(task_employment_filtered())
  expect_false(task_income_poverty_ratio())
})

test_that("task_() returns expected column order for all ACS tasks", {
  target   <- eval(formals(task_income)[["target"]])
  group    <- eval(formals(task_income)[["group"]])
  features <- eval(formals(task_income)[["features"]])

  income <- set_task(alabama, task = "income")

  expect_equal(colnames(income), c(target, group, setdiff(features, group)))
})

