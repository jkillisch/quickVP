# quickVP

Automatically batch generate confirmations of participation to give credit to study participants. The package/function is tailored to giving credit at my local university. Feel free to adjust the code for your own purposes.

The package requires that LaTex can be rendered by knitr + RMarkdown on your local machine.

To batch generate multiple confirmations of participation, a data.frame or tibble of student information must be created. Each row corresponds to a student:

```{r}
# Dataframe of participant information
dat <- dplyr::tibble(
  doc_id = c(102, 103, 104),
  student_id = c(132, 234, 421),
  mail = c("student_1@tok.com", "student_2@tok.com", "student_3@tok.com"),
  date = c("23.10.2024", "01.04.2024", "03.09.2024")
)
```

Additionally, global information about the study must be passed to the function quickVP:

```{r}
# The confirmations will be created here:
path <- getwd()

# The title of your study
study_name <- "A Very Important Study"

# The mail adress of the investigator
study_mail <- "investigator@tok.com"

# Up to 10 adress lines of the investigator
study_adress = c(
    "Investigator Name",
    "Street 8",
    "Building B",
    "Room: 1",
    "123456 PLZ"
  )

# The number of VP-hours that should be awarded to the participant
vp_hours <- 1

# This function will write the confirmations to your harddrive
quickVP(
  dat = dat,
  path = path,
  study_name = study_name,
  study_mail = study_mail,
  study_adress = study_adress,
  vp_hours = vp_hours
)
```
