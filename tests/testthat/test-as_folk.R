i <- sample(20:200, 1)
j <- sample(50:150, 1)
df <- data.frame(replicate(i, sample(0:1, j, rep = TRUE)))

test_that("dimension is identical after coercion", {
  folked <- as_folk(df)
  expect_equal(dim(df), dim(folked))
})

test_that("column types are identical after coercion", {
  df_mixed <- data.frame(
    a = letters[1:10],
    b = 1:10,
    c = factor(1:10)
  )
  folked <- as_folk(df_mixed)
  expect_equal(sapply(df_mixed, class), sapply(folked, class))
})

test_that("the class is correctly specified after coercion", {
  folked <- as_folk(df)
  expect_equal(class(folked), folk_df_class)
})

test_that("base type of folk_df is list", {
  folked <- as_folk(df)
  expect_type(folked, "list")
})

test_that("the source attribute exists when source argument is supplied", {
  folked <- as_folk(df, source = "some_source")
  expect_vector(attr(folked, "source"))
  expect_identical(attr(folked, "source"), "some_source")
})
