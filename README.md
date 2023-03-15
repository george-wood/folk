
<!-- README.md is generated from README.Rmd. Please edit that file -->

# folk

<!-- badges: start -->

[![R-CMD-check](https://github.com/george-wood/folk/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/george-wood/folk/actions/workflows/R-CMD-check.yaml)
[![codecov](https://codecov.io/gh/george-wood/folk/branch/master/graph/badge.svg?token=ZM8CUR8P13)](https://codecov.io/gh/george-wood/folk)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

## Installation

You can install the development version of folk from GitHub using:

``` r
# install.packages("devtools")
devtools::install_github("george-wood/folk")
```

## Usage

``` r
library(folk)

al <- get_acs(state = "al", year = 2014, period = 1, survey = "p")
```

``` r
al_income <- set_task(al, task = "income")
head(al_income)
#>   PINCP AGEP COW SCHL MAR OCCP POBP RELP WKHP SEX RAC1P
#> 1     0   49   6   16   1 7210    1    0   60   1     1
#> 2     0   51   1   16   1 4220    1    0   40   1     1
#> 3     0   53   1   16   1 7750    1    1   40   2     1
#> 4     0   51   1   16   1 5610   19    0   40   1     1
#> 5     1   48   5   20   1 7430   47    1   40   2     1
#> 6     0   49   1   16   1 8620   53    0   45   1     1
```

``` r
library(tidymodels)

set.seed(0)
al_split <- initial_split(al_income, prop = 0.8)
al_train <- training(al_split)
al_test <- testing(al_split)

pred <-
  logistic_reg() |>
  set_engine("glm") |>
  set_mode("classification") |>
  fit(PINCP ~ ., data = al_train) |>
  predict(new_data = al_test, type = "class")

yhat <- as.numeric(as.character(pred$.pred_class))

white_tpr <- mean(yhat[(al_test$PINCP == 1) & (al_test$RAC1P == 1)])
black_tpr <- mean(yhat[(al_test$PINCP == 1) & (al_test$RAC1P == 2)])

# equality of opportunity violation
white_tpr - black_tpr
#> [1] 0.2505592
```
