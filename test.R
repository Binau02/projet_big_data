# test <- read.csv("/Users/aubin/Documents/ecole/isen/CIR3/big data/projet_big_data/stat_acc_V3.csv", sep=";")
# test <- read.csv("stat_acc_V3.csv", sep=";")
# test$descr_cat_veh[test$descr_cat_veh == "Autobus"] <- 20000
# print(test$descr_cat_veh)
# print(test)

df <- read.csv("stat_acc_V3.csv", sep=";")
weights <- read.csv("poids_vehicules.csv", sep=";")
gravity <- read.csv("niveaux_gravite.csv", sep=";")

# print(weights[1,2])
for(i in 1:nrow(weights)) {
  df$descr_cat_veh[df$descr_cat_veh == weights[i, 1]] <- as.numeric(weights[i, 2])
}

for(i in 1:nrow(gravity)) {
  df$descr_grav[df$descr_grav == gravity[i, 1]] <- as.numeric(gravity[i, 2])
}

