
<!-- README.md is generated from README.Rmd. Please edit that file -->

# folk

<!-- badges: start -->

[![R-CMD-check](https://github.com/george-wood/folk/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/george-wood/folk/actions/workflows/R-CMD-check.yaml)
[![codecov](https://codecov.io/gh/george-wood/folk/branch/master/graph/badge.svg?token=QXIN95S7AJ)](https://codecov.io/gh/george-wood/folk)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

<!-- badges: end -->

folk provides easy access to datasets that can be used to benchmark
machine learning algorithms. The goal of folk is to facilitate and
encourage work on fair machine learning among R users.

The folk package has three key features:

| Feature      | Description                                                                                                                                                                                                                                                                                 |
|--------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `get_()`     | The `get_()` functions provide easy access to data. Currently, there is only one `get_()` function, `get_acs()`, which provides access to the US Census Bureau’s American Community Survey (ACS) [Public Use Microdata Sample](https://www.census.gov/programs-surveys/acs/microdata.html). |
| `set_task()` | The `set_task()` function preprocesses data for pre-defined prediction tasks. Pre-defined tasks can be viewed with `show_tasks()`.                                                                                                                                                          |
| `new_task()` | The `new_task()` function allows users to create custom tasks. A custom task created via `new_task()` returns an object consistent with that returned by `set_task()`.                                                                                                                      |

folk is inspired by the
[folktables](https://github.com/socialfoundations/folktables) Python
package. For more information on folktables see Ding, Hardt, Miller, and
Schmidt (2022), [Retiring Adult: New Datasets for Fair Machine
Learning](https://arxiv.org/pdf/2108.04884.pdf). The pre-defined
prediction tasks for the American Community Survey data are
implementations of the tasks introduced in this paper.

## Installation

You can try the development version from GitHub with:

``` r
# install.packages("devtools")
devtools::install_github("george-wood/folk")
```

## Usage

``` r
library(folk)
```

- Easy access to data via folk’s API: `get_acs()`, …

``` r
devtools::load_all()
# optionally, set a path to write to
delaware <- get_acs(state = "de", year = 2014, period = 1, survey = "person")
```

- Show pre-defined prediction tasks for data accessed through the API:
  `show_tasks()`

``` r
show_tasks(delaware)

#> $income
#> function(
#>     features = c("AGEP",
#>                  "COW",
#>                  "SCHL",
#>                  "MAR",
#>                  "OCCP",
#>                  "POBP",
#>                  "RELP",
#>                  "WKHP",
#>                  "SEX",
#>                  "RAC1P"),
#>     target = "PINCP",
#>     group = "RAC1P",
#>     filter = filter_adult,
#>     target_transform = function(y) binary_target_(y > 50000),
#>     group_transform = NULL,
#>     preprocess = NULL,
#>     postprocess = function(x) replace_na_(x, value = -1L)
#> ) {
#>   invisible(FALSE)
#> }
#> 
#> ...
```

- Set a pre-defined prediction task: `set_task()`

``` r
delaware_income <- set_task(delaware, task = "income")
#> ℹ Setting income prediction task. See `folk::task_income()` for details.
head(delaware_income)
#>   PINCP RAC1P AGEP COW SCHL MAR OCCP POBP RELP WKHP SEX
#> 1     0     1   25   1   16   5 5400   17   16   40   2
#> 2     0     1   37   1   21   1 3255   34    0   40   2
#> 3     0     1   36   2   19   5  110   40    0   40   1
#> 4     0     1   59   2   20   1 5120   54    0   40   2
#> 5     0     1   21   1   19   5 5240   10    2   36   2
#> 6     1     1   51   1   16   3 7150   24    0   40   1
```

## Example

``` r
library(tidymodels)

delaware <- get_acs(state = "de", year = 2014, period = 1, survey = "person")
delaware_income <- set_task(delaware, task = "income")
#> ℹ Setting income prediction task. See `folk::task_income()` for details.

set.seed(0)
split <- initial_split(delaware_income, prop = 0.8)
train <- training(split)
test  <- testing(split)

income_recipe <-
  recipe(PINCP ~ ., data = train) |>
  step_normalize()

income_model <-
  logistic_reg(mode = "classification", engine = "glm")

income_flow <-
  workflow() |>
  add_recipe(income_recipe) |>
  add_model(income_model)

yhat <- 
  fit(income_flow, data = train) |>
  predict(new_data = test, type = "class")
```

``` r
yhat <- as.numeric(as.character(yhat$.pred_class))
black_tpr <- mean(yhat[test$PINCP == 1 & test$RAC1P == 2])
black_fpr <- mean(yhat[test$PINCP == 0 & test$RAC1P == 2])
white_tpr <- mean(yhat[test$PINCP == 1 & test$RAC1P == 1])
white_fpr <- mean(yhat[test$PINCP == 0 & test$RAC1P == 1])

black_tpr
#> [1] 0.3414634
black_fpr
#> [1] 0.1025641

white_tpr
#> [1] 0.5992063
white_fpr
#> [1] 0.1648352

# equalized odds difference:
max(abs(black_tpr - white_tpr), abs(black_fpr - white_fpr))
#> [1] 0.2577429
```

## Acknowledgements

- The folk package is inspired by the
  [folktables](https://github.com/socialfoundations/folktables) Python
  package.
