library(folk)

alabama <- folk::get_acs(
  state  = "al",
  year   = 2017,
  survey = "p",
  period = 1
)

set.seed(0)
alabama <- alabama[sample(nrow(alabama), size = 5000), ]

usethis::use_data(alabama, compress = "xz", overwrite = TRUE)
