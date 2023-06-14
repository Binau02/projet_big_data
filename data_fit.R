################
# DATA fitting #
################

library(tidyverse)
library(dplyr)
library(sf)
library(ggplot2)
library(tmap)
library(leaflet)



df <- read.csv("csv/stat_acc_V3.csv", sep = ";")
weights <- read.csv("csv/poids_vehicules.csv", sep = ";")
gravity <- read.csv("csv/niveaux_gravite.csv", sep = ";")
climat <- read.csv("csv/climat.csv", sep = ";")
etat <- read.csv("csv/etat.csv", sep = ";")
dept <- read.csv("csv/departements-france.csv")

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

  #my_date <- as.Date(df$date[i])
  my_date <- as.POSIXct(df$date[i])

  months <- as.numeric(format(my_date, format = "%m"))
  years <- as.numeric(format(my_date, format = "%Y"))
  days <- as.numeric(format(my_date, format = "%d"))
  weeks <- as.numeric(format(my_date, format = "%W"))
  hours <- as.numeric(format(my_date, format = "%H"))

  df$month[i] <- months
  df$years[i] <- years
  df$days[i] <-  days
  df$weeks[i] <- weeks
  df$hours[i] <- hours
  
  df$date[i] <- (as.numeric(as.POSIXct(df$date[i], format="%Y-%m-%d  %H:%M:%S")))
}

for (i in seq_len(nrow(climat))) {
  df$descr_athmo[df$descr_athmo == climat[i, 1]] <- as.numeric(climat[i, 2])
}

for (i in seq_len(nrow(etat))) {
  df$descr_etat_surf[df$descr_etat_surf == etat[i, 1]] <- as.numeric(etat[i, 2])
}

#indiquer les formats de chaque colonnes
df <- as.tibble(df)
as.tibble(df)

#tracer les regression lineaires
library(car)
scatterplot(df~education, data=df) 