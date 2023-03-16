test_that("NULL path returns names of example files", {
  example_file <- folk_example()
  expect_true("acs_example.csv" %in% example_file)
  expect_true(is.character(example_file))
})

test_that("providing example file name returns full path", {
  expect_true(file.exists(folk_example("acs_example.csv")))
})
