################
# DATA fitting #
################


# install.packages("tidyverse")
# install.packages("dplyr")
# install.packages("sf")
# install.packages("ggplot2")
# install.packages("car")

# library(tidyverse)
# library(dplyr)
# library(sf)
# library(ggplot2)
# library(tmap)
# library(leaflet)
# library(car)


# lire données
df <- read.csv("data/stat_acc_V3.csv", sep = ";")
weights <- read.csv("data/poids_vehicules.csv", sep = ";")
gravity <- read.csv("data/niveaux_gravite.csv", sep = ";")
climat <- read.csv("data/climat.csv", sep = ";")
etat <- read.csv("data/etat.csv", sep = ";")
lum <- read.csv("data/lum.csv", sep = ",")
dept <- read.csv("data/departements-france.csv")
coords <- read.csv("data/insee-lat-lon.csv")

# préparation des données pour la latitude et la longitude
for (i in seq_len(nrow(df))) {
  temp <- coords[coords$code_commune_INSEE == df$id_code_insee[i], ]
  # print(temp)
  df$latitude[i] <- temp$latitude
  df$longitude[i] <- temp$longitude
}

# préparation des données pour le poids
for (i in seq_len(nrow(weights))) {
  df$weight[df$descr_cat_veh == weights[i, 1]] <- as.numeric(weights[i, 2])
}
# préparation des données pour la gravité
for (i in seq_len(nrow(gravity))) {
  df$gravity[df$descr_grav == gravity[i, 1]] <- as.numeric(gravity[i, 2])
}
# préparation des données pour région/département/code région
for (i in seq_len(nrow(dept))) {
  df$dept[substr(df$id_code_insee, 1, 2) == dept[i, 1]] <- dept[i, 2]
  df$region[substr(df$id_code_insee, 1, 2) == dept[i, 1]] <- dept[i, 4]
  df$CODE_REG[substr(df$id_code_insee, 1, 2) == dept[i, 1]] <- dept[i, 3]
}
# préparation des données pour les 3 nulls
temp <- c()
for (i in seq_len(nrow(df))) {
  if (df$age[i] == "NULL") {
    temp <- append(temp, i)
  }
}

df <- df[-temp, ]

df$place[df$place == "NULL"] <- 1

# préparation des données pour l'âge (-14ans)
df$age <- as.numeric(df$age)
df$age <- df$age - 14

weeks_cumul <- vector(length = 53)
weeks_gravity_cumul <- vector(length = 53)
month_cumul <- vector(length = 12)
month_gravity_cumul <- vector(length = 12)

# créer mois, années, jours, semaines, heures / date -> timestamp
for (i in 1:length(df$date)) {

  my_date <- as.POSIXct(df$date[i])

  months <- as.numeric(format(my_date, format = "%m"))
  days <- as.numeric(format(my_date, format = "%d"))
  weeks <- as.numeric(format(my_date, format = "%W"))
  hours <- as.numeric(format(my_date, format = "%H"))

  df$month[i] <- months
  df$days[i] <- days
  df$weeks[i] <- weeks
  df$hours[i] <- hours

  weeks_cumul[(weeks + 1):53] <- weeks_cumul[(weeks + 1):53] + 1
  weeks_gravity_cumul[(weeks + 1):53] <- weeks_gravity_cumul[(weeks + 1):53] + df$gravity[i]
  month_cumul[months:12] <- month_cumul[months:12] + 1
  month_gravity_cumul[months:12] <- month_gravity_cumul[months:12] + df$gravity[i]

  df$date[i] <- as.numeric(as.POSIXct(df$date[i], format = "%Y-%m-%d  %H:%M:%S"))
}

# préparation des données pour le climat
for (i in seq_len(nrow(climat))) {
  df$athmo_num[df$descr_athmo == climat[i, 1]] <- as.numeric(climat[i, 2])
}
# préparation des données pour l'état de la route
for (i in seq_len(nrow(etat))) {
  df$etat_surf_num[df$descr_etat_surf == etat[i, 1]] <- as.numeric(etat[i, 2])
}
# préparation des données pour la luminosité
for (i in seq_len(nrow(lum))) {
  df$lum_num[df$descr_lum == lum[i, 1]] <- as.numeric(lum[i, 2])
}
