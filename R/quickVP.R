#' Automatically batch generate confirmations of participation
#'
#' @param dat Dataframe, with rows doc_id, student_id, mail, date (see details)
#' @param path Character, path to the folder that will store resulting PDFs
#' @param study_name Character, name or title of the study
#' @param study_mail Character, mail adress of the investigator
#' @param study_adress Character vector, up to 10 lines of contact information
#' of the investigator
#' @param vp_hours Numeric, vp-hours awarded to the participant
#'
#' @details
#' doc_id is a numeric id that is unique to the confirmation. The id is a
#' light protection against forgery.
#'
#' student_id is numeric id unique to the student. This could, for instance, be
#' a matriculation number.
#'
#' mail is a character that contains a mail adress of the participant.
#'
#' date is a character that gives the data of participation.
#'
#' You may set values of these columns to NA. Then, the respective section of
#' the confirmation will be skipped.
#'
#' @export
#' @examples
#' # Dataframe of participant information
#' dat <- dplyr::tibble(
#'   doc_id = c(102, 103, 104),
#'   student_id = c(132, 234, 421),
#'   mail = c("student_1@tok.com", "student_2@tok.com", "student_3@tok.com"),
#'   date = c("23.10.2024", "01.04.2024", "03.09.2024")
#' )
#'
#' # Warning: This will write three PDFs to your working directory
#' quickVP(
#'   dat = dat,
#'   path = getwd(),
#'   study_name = "A Very Important Study",
#'   study_mail = "investigator@tok.com",
#'   study_adress = c(
#'     "Investigator Name",
#'     "Street 8",
#'     "Building B",
#'     "Room: 1",
#'     "123456 PLZ"
#'   ),
#'   vp_hours = 1
#' )
#'

quickVP <- function (
    dat,
    path,
    study_name,
    study_mail,
    study_adress,
    vp_hours
) {

  checkmate::assert_data_frame(
    dat,
    any.missing = FALSE,
    min.rows = 1,
    ncols = 4
  )

  stopifnot(
    "The columns doc_id, student_id, mail, and date must be present in dat" =
    all(c("doc_id", "student_id", "mail", "date") %in% colnames(dat))
    )

  checkmate::assert_numeric(
    dat$doc_id,
    finite = TRUE,
    any.missing = TRUE
  )

  checkmate::assert_numeric(
    dat$student_id,
    finite = TRUE,
    any.missing = TRUE
  )

  checkmate::assert_character(
    dat$mail,
    any.missing = TRUE,
    pattern = "@"
  )

  checkmate::assert_character(
    dat$date,
    any.missing = TRUE
  )

  checkmate::assert_character(
    study_name,
    any.missing = FALSE,
    len = 1,
    null.ok = FALSE
  )

  checkmate::assert_character(
    study_mail,
    any.missing = TRUE,
    pattern = "@",
    null.ok = FALSE
  )

  checkmate::assert_character(
    study_adress,
    any.missing = TRUE,
    null.ok = FALSE,
    max.len = 10,
    min.len = 1
  )

  checkmate::assert_number(
    vp_hours,
    na.ok = FALSE,
    lower = 0,
    finite = TRUE,
    null.ok = FALSE
  )

  checkmate::assert_character(
    path,
    min.chars = 1,
    any.missing = FALSE,
    len = 1,
    null.ok = FALSE
  )

  template_path <- system.file(
    "confirmation_template.Rmd",
    package = "quickVP"
    )

  checkmate::assert_path_for_output(
    template_path,
    overwrite = TRUE
    )

  for (i in 1:nrow(dat)) {

    report_path <- file.path(
      path,
      paste0("confirmation_", dat$doc_id[i], ".pdf")
      )

    checkmate::assert_path_for_output(
      report_path,
      overwrite = TRUE,
      extension = "pdf"
    )

    params <- as.list(dat[i, ])
    params <- c(params, study_name = study_name)
    params <- c(params, study_mail = study_mail)
    params <- c(params, vp_hours = vp_hours)
    params <- c(params, study_adress = list(study_adress))

    rmarkdown::render(
      input = template_path,
      output_file = report_path,
      params = params
    )

  }

  N <- nrow(dat)
  message(paste0(N, " confirmations were created in ", path))

  return(TRUE)

}
