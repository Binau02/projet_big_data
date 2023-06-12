df <- read.csv("stat_acc_V3.csv", sep = ";")
weights <- read.csv("poids_vehicules.csv", sep = ";")
gravity <- read.csv("niveaux_gravite.csv", sep = ";")
dept <- read.csv("departements-france.csv")

for (i in seq_len(nrow(weights))) {
  df$weight[df$descr_cat_veh == weights[i, 1]] <- as.numeric(weights[i, 2])
}

for (i in seq_len(nrow(gravity))) {
  df$gravity[df$descr_grav == gravity[i, 1]] <- as.numeric(gravity[i, 2])
}

for (i in seq_len(nrow(dept))) {
  df$dept[substr(df$id_code_insee, 1, 2) == dept[i, 1]] <- dept[i, 2]
  df$region[substr(df$id_code_insee, 1, 2) == dept[i, 1]] <- dept[i, 4]
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

# plot by age
hist(df$age, breaks = max(df$age)-min(df$age)+1, main = "number of accident by age", xlab = "age", ylab = "number of accident")

# plot by athmospheric conditions
barplot(table(df$descr_athmo), las = 2)
barplot(table(df$descr_athmo)[-4], las = 2)

# plot by surface
barplot(table(df$descr_etat_surf), las = 2)
barplot(table(df$descr_etat_surf)[-8], las = 2)

# plot by gravity
test <- table(df$descr_grav)
barplot(as.table(c(test["Indemne"], test["Blessé léger"], test["Blessé hospitalisé"], test["Tué"])), las = 2)

# plot by city
# print(table(df[c("id_code_insee", "ville")]))
test <- table(df["ville"])
test <- test[order(test, decreasing = TRUE)]
barplot(head(test, n = 30), las = 2)
