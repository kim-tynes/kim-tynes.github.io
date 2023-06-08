#
## LOAD PACKAGES ####
#
if(!require("pacman")) {
  install.packages("pacman")
}

pacman::p_load("pacman", "rio", "tidyverse", "janitor", "gridExtra")

#
## LOAD DATASETS ####
#
data01 <- import("New Customers-jan.csv")
data02 <- import("New Customers-feb.csv")
data03 <- import("New Customers-mar.csv")
data04 <- import("New Customers-apr.csv")
data05 <- import("New Customers-may.csv")
data06 <- import("New Customers-jun.csv")
data07 <- import("New Customers-jul.csv")
data08 <- import("New Customers-aug.csv")
data09 <- import("New Customers-sep.csv")
data10 <- import("New Customers-oct.csv")
data11 <- import("New Customers-nov.csv")
data12 <- import("New Customers-dec.csv")

#
## CLEAN NEWLY LOADED TABLES ####
#
data01 <- clean_names(data01)
data02 <- clean_names(data02)
data03 <- clean_names(data03)
data04 <- clean_names(data04)
data05 <- clean_names(data05)
data06 <- clean_names(data06)
data07 <- clean_names(data07)
data08 <- clean_names(data08)
data09 <- clean_names(data09)
data10 <- clean_names(data10)
data11 <- clean_names(data11)
data12 <- clean_names(data12)

data10 <- data10 |>
  dplyr::rename(demographic = demagraphic)
data08 <- data08 |>
  dplyr::rename(demographic = demographiic)

#
## CREATE JOINING DATE FIELD ####
#
data01 <- data01 |>
  mutate(joining_date = as.Date(paste(joining_day, "01", "2023", sep = "-"), 
                                     format = "%d-%m-%Y"))

data02 <- data02 |>
  mutate(joining_date = as.Date(paste(joining_day, "02", "2023", sep = "-"), 
                                     format = "%d-%m-%Y"))

data03 <- data03 |>
  mutate(joining_date = as.Date(paste(joining_day, "03", "2023", sep = "-"), 
                                     format = "%d-%m-%Y"))

data04 <- data04 |>
  mutate(joining_date = as.Date(paste(joining_day, "04", "2023", sep = "-"), 
                                     format = "%d-%m-%Y"))

data05 <- data05 |>
  mutate(joining_date = as.Date(paste(joining_day, "05", "2023", sep = "-"), 
                                     format = "%d-%m-%Y"))

data06 <- data06 |>
  mutate(joining_date = as.Date(paste(joining_day, "06", "2023", sep = "-"), 
                                     format = "%d-%m-%Y"))

data07 <- data07 |>
  mutate(joining_date = as.Date(paste(joining_day, "07", "2023", sep = "-"), 
                                     format = "%d-%m-%Y"))

data08 <- data08 |>
  mutate(joining_date = as.Date(paste(joining_day, "08", "2023", sep = "-"), 
                                     format = "%d-%m-%Y"))

data09 <- data09 |>
  mutate(joining_date = as.Date(paste(joining_day, "09", "2023", sep = "-"), 
                                     format = "%d-%m-%Y"))

data10 <- data10 |>
  mutate(joining_date = as.Date(paste(joining_day, "10", "2023", sep = "-"), 
                                     format = "%d-%m-%Y"))

data11 <- data11 |>
  mutate(joining_date = as.Date(paste(joining_day, "11", "2023", sep = "-"), 
                                     format = "%d-%m-%Y"))

data12 <- data12 |>
  mutate(joining_date = as.Date(paste(joining_day, "12", "2023", sep = "-"), 
                                     format = "%d-%m-%Y"))

#
## PIVOT/RESHAPE DATA ####
#
data01 <- data01 |>
  pivot_wider(names_from = demographic, values_from = value) |>
  mutate(`Date of Birth` = as.Date(`Date of Birth`, format = "%m/%d/%Y"))
data02 <- data02 |>
  pivot_wider(names_from = demographic, values_from = value) |>
  mutate(`Date of Birth` = as.Date(`Date of Birth`, format = "%m/%d/%Y"))
data03 <- data03 |>
  pivot_wider(names_from = demographic, values_from = value) |>
  mutate(`Date of Birth` = as.Date(`Date of Birth`, format = "%m/%d/%Y"))
data04 <- data04 |>
  pivot_wider(names_from = demographic, values_from = value) |>
  mutate(`Date of Birth` = as.Date(`Date of Birth`, format = "%m/%d/%Y"))
data05 <- data05 |>
  pivot_wider(names_from = demographic, values_from = value) |>
  mutate(`Date of Birth` = as.Date(`Date of Birth`, format = "%m/%d/%Y"))
data06 <- data06 |>
  pivot_wider(names_from = demographic, values_from = value) |>
  mutate(`Date of Birth` = as.Date(`Date of Birth`, format = "%m/%d/%Y"))
data07 <- data07 |>
  pivot_wider(names_from = demographic, values_from = value) |>
  mutate(`Date of Birth` = as.Date(`Date of Birth`, format = "%m/%d/%Y"))
data08 <- data08 |>
  pivot_wider(names_from = demographic, values_from = value) |>
  mutate(`Date of Birth` = as.Date(`Date of Birth`, format = "%m/%d/%Y"))
data09 <- data09 |>
  pivot_wider(names_from = demographic, values_from = value) |>
  mutate(`Date of Birth` = as.Date(`Date of Birth`, format = "%m/%d/%Y"))
data10 <- data10 |>
  pivot_wider(names_from = demographic, values_from = value) |>
  mutate(`Date of Birth` = as.Date(`Date of Birth`, format = "%m/%d/%Y"))
data11 <- data11 |>
  pivot_wider(names_from = demographic, values_from = value) |>
  mutate(`Date of Birth` = as.Date(`Date of Birth`, format = "%m/%d/%Y"))
data12 <- data12 |>
  pivot_wider(names_from = demographic, values_from = value) |>
  mutate(`Date of Birth` = as.Date(`Date of Birth`, format = "%m/%d/%Y"))

#
## CLEAN RESHAPED TABLES ####
#
data01 <- clean_names(data01)
data02 <- clean_names(data02)
data03 <- clean_names(data03)
data04 <- clean_names(data04)
data05 <- clean_names(data05)
data06 <- clean_names(data06)
data07 <- clean_names(data07)
data08 <- clean_names(data08)
data09 <- clean_names(data09)
data10 <- clean_names(data10)
data11 <- clean_names(data11)
data12 <- clean_names(data12)

#
## JOIN DATASETS ###
#
j1 <- full_join(data01, data02, join_by(x$id == y$id,
          x$joining_day == y$joining_day,
          x$joining_date == y$joining_date, 
          x$ethnicity == y$ethnicity, 
          x$date_of_birth == y$date_of_birth,
          x$account_type == y$account_type))

j1 <- full_join(j1, data03, join_by(x$id == y$id,
                                    x$joining_day == y$joining_day,
                                    x$joining_date == y$joining_date, 
                                    x$ethnicity == y$ethnicity, 
                                    x$date_of_birth == y$date_of_birth,
                                    x$account_type == y$account_type))

j1 <- full_join(j1, data04, join_by(x$id == y$id,
                                    x$joining_day == y$joining_day,
                                    x$joining_date == y$joining_date, 
                                    x$ethnicity == y$ethnicity, 
                                    x$date_of_birth == y$date_of_birth,
                                    x$account_type == y$account_type))

j1 <- full_join(j1, data05, join_by(x$id == y$id,
                                    x$joining_day == y$joining_day,
                                    x$joining_date == y$joining_date, 
                                    x$ethnicity == y$ethnicity, 
                                    x$date_of_birth == y$date_of_birth,
                                    x$account_type == y$account_type))

j1 <- full_join(j1, data06, join_by(x$id == y$id,
                                    x$joining_day == y$joining_day,
                                    x$joining_date == y$joining_date, 
                                    x$ethnicity == y$ethnicity, 
                                    x$date_of_birth == y$date_of_birth,
                                    x$account_type == y$account_type))

j1 <- full_join(j1, data07, join_by(x$id == y$id,
                                    x$joining_day == y$joining_day,
                                    x$joining_date == y$joining_date, 
                                    x$ethnicity == y$ethnicity, 
                                    x$date_of_birth == y$date_of_birth,
                                    x$account_type == y$account_type))

j1 <- full_join(j1, data08, join_by(x$id == y$id,
                                    x$joining_day == y$joining_day,
                                    x$joining_date == y$joining_date, 
                                    x$ethnicity == y$ethnicity, 
                                    x$date_of_birth == y$date_of_birth,
                                    x$account_type == y$account_type))

j1 <- full_join(j1, data09, join_by(x$id == y$id,
                                    x$joining_day == y$joining_day,
                                    x$joining_date == y$joining_date, 
                                    x$ethnicity == y$ethnicity, 
                                    x$date_of_birth == y$date_of_birth,
                                    x$account_type == y$account_type))


j1 <- full_join(j1, data10, join_by(x$id == y$id,
                                    x$joining_day == y$joining_day,
                                    x$joining_date == y$joining_date, 
                                    x$ethnicity == y$ethnicity, 
                                    x$date_of_birth == y$date_of_birth,
                                    x$account_type == y$account_type))

j1 <- full_join(j1, data11, join_by(x$id == y$id,
                                    x$joining_day == y$joining_day,
                                    x$joining_date == y$joining_date, 
                                    x$ethnicity == y$ethnicity, 
                                    x$date_of_birth == y$date_of_birth,
                                    x$account_type == y$account_type))

j1 <- full_join(j1, data12, join_by(x$id == y$id,
                                    x$joining_day == y$joining_day,
                                    x$joining_date == y$joining_date, 
                                    x$ethnicity == y$ethnicity, 
                                    x$date_of_birth == y$date_of_birth,
                                    x$account_type == y$account_type))

j2 <- j1 |>
  filter(id == 984843 |
         id == 663516 |
         id == 332370 |
         id == 826580 | 
         id == 929308 | 
         id == 595254 | 
         id == 630270 | 
         id == 716900) |>
  select(id, joining_date, account_type, date_of_birth, ethnicity)

#
## PLOT SAMPLE OF JOINED TABLE DATA ####
#
grid.table(j2)

#
## CLEAN UP ENVIRONMENT ####
#
rm(list = ls())
p_unload(all)
graphics.off()
cat("\014")
