################
# DATA fitting #
################

library(tidyverse)
library(dplyr)
library(sf)
library(ggplot2)
library(tmap)
library(leaflet)



df <- read.csv("data/stat_acc_V3.csv", sep = ";")
weights <- read.csv("data/poids_vehicules.csv", sep = ";")
gravity <- read.csv("data/niveaux_gravite.csv", sep = ";")
climat <- read.csv("data/climat.csv", sep = ";")
etat <- read.csv("data/etat.csv", sep = ";")
dept <- read.csv("data/departements-france.csv")

for (i in seq_len(nrow(weights))) {
  df$weight[df$descr_cat_veh == weights[i, 1]] <- as.numeric(weights[i, 2])
}

for (i in seq_len(nrow(gravity))) {
  df$gravity[df$descr_grav == gravity[i, 1]] <- as.numeric(gravity[i, 2])
}

for (i in seq_len(nrow(dept))) {
  df$dept[substr(df$id_code_insee, 1, 2) == dept[i, 1]] <- dept[i, 2]
  df$region[substr(df$id_code_insee, 1, 2) == dept[i, 1]] <- dept[i, 4]
  df$CODE_REG[substr(df$id_code_insee, 1, 2) == dept[i, 1]] <- dept[i, 3]
}

test <- c()
for (i in seq_len(nrow(df))) {
  if (df$age[i] == "NULL") {
    test <- append(test, i)
  }
}

df <- df[-test, ]

df$age <- as.numeric(df$age)
df$age <- df$age - 14


# creating month, years, days, weeks, hours columns / date -> timestamp
for (i in 1:length(df$date)) {
  # my_date <- as.Date(df$date[i])
  my_date <- as.POSIXct(df$date[i])

  months <- as.numeric(format(my_date, format = "%m"))
  years <- as.numeric(format(my_date, format = "%Y"))
  days <- as.numeric(format(my_date, format = "%d"))
  weeks <- as.numeric(format(my_date, format = "%W"))
  hours <- as.numeric(format(my_date, format = "%H"))

  df$month[i] <- months
  df$years[i] <- years
  df$days[i] <- days
  df$weeks[i] <- weeks
  df$hours[i] <- hours

  df$date[i] <- (as.numeric(as.POSIXct(df$date[i], format = "%Y-%m-%d  %H:%M:%S")))
}

for (i in seq_len(nrow(climat))) {
  df$athmo_num[df$descr_athmo == climat[i, 1]] <- as.numeric(climat[i, 2])
}

for (i in seq_len(nrow(etat))) {
  df$etat_surf_num[df$descr_etat_surf == etat[i, 1]] <- as.numeric(etat[i, 2])
}
