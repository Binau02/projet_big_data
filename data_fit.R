df <- read.csv("stat_acc_V3.csv", sep = ";")
weights <- read.csv("poids_vehicules.csv", sep = ";")
gravity <- read.csv("niveaux_gravite.csv", sep = ";")
dept <- read.csv("departements-france.csv")

for(i in seq_len(nrow(weights))) {
  df$descr_cat_veh[df$descr_cat_veh == weights[i, 1]] <- as.numeric(weights[i, 2])
}

for(i in seq_len(nrow(gravity))) {
  df$descr_grav[df$descr_grav == gravity[i, 1]] <- as.numeric(gravity[i, 2])
}

for(i in seq_len(nrow(dept))) {
  df$dept[substr(df$id_code_insee, 1, 2) == dept[i, 1]] <- dept[i, 2]
  df$region[substr(df$id_code_insee, 1, 2) == dept[i, 1]] <- dept[i, 4]
}

