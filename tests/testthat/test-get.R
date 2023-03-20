test_that("get_acs() returns folk_df object with source attribute", {
  data <- get_acs(state = "wy", year = 2014, period = 1, survey = "p")
  expect_equal(class(data), folk_df_class)
  expect_equal(attr(data, "source"), "acs")
})

test_that("fetch_acs() generates exception for invalid url calls", {
  expect_error(
    fetch_acs(state = "iu", year = 2015, period = 1, survey = "p")
  )
})

test_that("joining household data changes dimension", {
  person <- get_acs(
    state = "wy", year = 2014, period = 1, survey = "p"
  )
  household <- get_acs(
    state = "wy", year = 2014, period = 1, survey = "p",
    join_household = TRUE
  )
  expect_gt(ncol(household), ncol(person))
  expect_equal(nrow(household), nrow(person))
})

test_that("create_path_acs() returns appropriate subdirectory structure", {
  desired_path <- "arbitrary_folder/2015/1-Year"
  expect_equal(
    desired_path,
    create_path_acs(path = "arbitrary_folder", year = 2015, period = 1)
  )
})

test_that("fread column name warning for colClasses is muffled", {
  expect_warning(
    data.table::fread(
      input = "a,b\n1,a\n2,b\n",
      colClasses = list(character = c("b"), numeric = c("a", "c"))
    )
  )
  expect_no_warning(
    withCallingHandlers(
      data.table::fread(
        input = "a,b\n1,a\n2,b\n",
        colClasses = list(character = c("b"), numeric = c("a", "c"))
      ),
      warning = muffle_fread_cols
    )
  )
})

test_that("assertion catches invalid values", {
  expect_error(assert_args_acs(state = "iu"))
  expect_error(assert_args_acs(year = 2013))
  expect_error(assert_args_acs(year = 2022))
  expect_error(assert_args_acs(survey = "person"))
  expect_error(assert_args_acs(period = 3))
})
