ua <- httr::user_agent("http://github.com/george-wood/folk")

#' @importFrom glue glue
get_acs <- function(year,
                    period,
                    survey = c("person", "household"),
                    state = NULL,
                    path) {

  survey <- substring(match.arg(survey), 1, 1)

  if (!is.integer(year) || year < 2014) {
    stop("Invalid `year`. Must be >= 2014.")
  }

  if (is.null(state)) {
    stop("Must provide `state`.")
  }

  if (!state %in% hash::keys(state_dictionary)) {
    stop("Invalid `state`")
  }

  if (survey %in% c("p", "h")) {
    stop("Invalid `survey`. Must be 'person' or 'household'.")
  }

  url <- httr::modify_url(
    url = "https://www2.census.gov/",
    path = glue(
      "programs-surveys/acs/data/pums/",
      "{year}/{period}/csv_{survey}{state}.zip"
    )
  )

  resp <- httr::GET(url)

  if (httr::http_type(resp) != "application/zip") {
    stop("API did not return zip")
  }

  if (httr::http_error(resp)) {
    stop(
      sprintf(
        "ACS API request failed [%s]\n%s\n<%s>",
        httr::status_code(resp)
      ),
      call. = FALSE
    )
  }

  tmp <- tempfile()
  httr::GET(
    url,
    ua,
    httr::write_disk(tmp, overwrite = TRUE),
    httr::progress()
  )
  utils::unzip(zipfile = tmp, exdir = path)
  unlink(tmp)

}


