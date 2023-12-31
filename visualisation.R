######################
# DATA visualisation #
######################

install.packages("RColorBrewer")
library(RColorBrewer)

# plot by age
png(file = "./export/nb_acc_par_age.png")
hist(df$age, breaks = max(df$age) - min(df$age) + 1, main = "nombre d'accidents par age", xlab = "age", ylab = "number of accident")
dev.off()


# plot by athmospheric conditions
png(file = "./export/nb_acc_par_athmo.png")
barplot(table(df$descr_athmo), las = 2, main = "Nombre d'accidents en fonction de l'athmosphère")
dev.off()
png(file = "./export/nb_acc_par_athmo_anormale.png")
barplot(table(df$descr_athmo)[-4], las = 2, main = "Nombre d'accidents en fonction de l'athmosphère\n(hors situation normale)")
dev.off()

# plot by surface
png(file = "./export/nb_acc_par_surf.png")
barplot(table(df$descr_etat_surf), las = 2, main = "Nombre d'accidents en fonction de l'état de la surface")
dev.off()
png(file = "./export/nb_acc_par_surf_anormale.png")
barplot(table(df$descr_etat_surf)[-8], las = 2, main = "Nombre d'accidents en fonction de l'état de la surface\n(hors situation normale)")
dev.off()

# plot by gravity
test <- table(df$descr_grav)
png(file = "./export/nb_acc_par_grav.png")
barplot(as.table(c(test["Indemne"], test["Blessé léger"], test["Blessé hospitalisé"], test["Tué"])), las = 2, main = "Nombre d'accidents par gravité")
dev.off()

# plot by city
test <- table(df["ville"])
test <- test[order(test, decreasing = TRUE)]
png(file = "./export/nb_acc_par_ville_top_30.png")
barplot(head(test, n = 30), las = 2, main = "Nombre d'accident par ville (top 30)")
dev.off()

# mapcsv
extraWD <- "./data"

# use database
departements_L93 <- st_read(dsn = extraWD, layer = "DEPARTEMENT", quiet = TRUE) %>%
  st_transform(2154)

# transform departements into regions
region_L93 <- departements_L93 %>%
  group_by(CODE_REG, NOM_REG) %>%
  summarize()

depts <- vector(mode = "numeric", length = 97)
reg <- vector(mode = "numeric", length = 94)
depts_grave <- vector(mode = "numeric", length = 97)
reg_grave <- vector(mode = "numeric", length = 94)
for (i in seq_len(nrow(df))) {
  n <- as.numeric(substr(df$id_code_insee[i], 1, 2))
  if (is.na(n)) {
    if (substr(df$id_code_insee[i], 1, 2) == "2A") {
      n <- 96
    } else {
      n <- 97
    }
  }
  if (n >= 1 && n <= 96) {
    depts[n] <- depts[n] + 1
    if (df$gravity[i] >= 5) {
      depts_grave[n] <- depts_grave[n] + 1
    }
  }
  n <- as.numeric(df$CODE_REG[i])
  reg[n] <- reg[n] + 1
  if (df$gravity[i] >= 5) {
    reg_grave[n] <- reg_grave[n] + 1
  }
}
for (i in seq_len(nrow(departements_L93))) {
  n <- as.numeric(departements_L93$CODE_DEPT[i])
  if (is.na(n)) {
    if (departements_L93$CODE_DEPT[i] == "2A") {
      n <- 96
    } else {
      n <- 97
    }
  }
  departements_L93$acc[i] <- depts[n]
  if (depts[n] != 0) {
    departements_L93$taux_acc_grave[i] <- depts_grave[n] / depts[n] * 100
  } else {
    departements_L93$taux_acc_grave[i] <- 0
  }
}
for (i in seq_len(nrow(region_L93))) {
  region_L93$acc[i] <- reg[as.numeric(region_L93$CODE_REG[i])]
  if (reg[as.numeric(region_L93$CODE_REG[i])] != 0) {
    region_L93$taux_acc_grave[i] <- reg_grave[as.numeric(region_L93$CODE_REG[i])] / reg[as.numeric(region_L93$CODE_REG[i])] * 100
  } else {
    region_L93$taux_acc_grave[i] <- 0
  }
}

# departements map
g_departement <- ggplot(departements_L93) +
  aes(color = acc) +
  scale_color_continuous(low = "yellow", high = "red") +
  geom_sf(aes(fill = acc)) +
  scale_fill_continuous(low = "yellow", high = "red") +
  coord_sf(crs = 4326) +
  guides(fill = FALSE) +
  ggtitle("Nombre d'accidents par département") +
  theme(title = element_text(size = 16), plot.margin = unit(c(0, 0.1, 0, 0.25), "inches"))

png(file = "./export/nb_acc_par_dept.png")
print(g_departement)
dev.off()

# regions map
g_region <- ggplot(region_L93) +
  aes(color = acc) +
  scale_color_continuous(low = "yellow", high = "red") +
  geom_sf(aes(fill = acc)) +
  scale_fill_continuous(low = "yellow", high = "red") +
  coord_sf(crs = 2154, datum = sf::st_crs(2154)) +
  guides(fill = FALSE) +
  ggtitle("Nombre d'accidents par région") +
  theme(title = element_text(size = 16))

png(file = "./export/nb_acc_par_reg.png")
print(g_region)
dev.off()

# departements map
g_departement <- ggplot(departements_L93) +
  aes(color = taux_acc_grave) +
  scale_color_continuous(low = "yellow", high = "red") +
  geom_sf(aes(fill = taux_acc_grave)) +
  scale_fill_continuous(low = "yellow", high = "red") +
  coord_sf(crs = 4326) +
  guides(fill = FALSE) +
  ggtitle("Taux d'accidents graves par département") +
  theme(title = element_text(size = 16), plot.margin = unit(c(0, 0.1, 0, 0.25), "inches"))

png(file = "./export/taux_acc_grave_par_dept.png")
print(g_departement)
dev.off()

# regions map
g_region <- ggplot(region_L93) +
  aes(color = taux_acc_grave) +
  scale_color_continuous(low = "yellow", high = "red") +
  geom_sf(aes(fill = taux_acc_grave)) +
  scale_fill_continuous(low = "yellow", high = "red") +
  coord_sf(crs = 2154, datum = sf::st_crs(2154)) +
  guides(fill = FALSE) +
  ggtitle("Taux d'accidents graves par région") +
  theme(title = element_text(size = 16))

png(file = "./export/taux_acc_grave_par_reg.png")
print(g_region)
dev.off()

# afficher les données en mois
png(file = "./export/nb_acc_par_mois.png")
hist(df$month, breaks = 0:12, main = "Nombre d'accident par mois", xlab = "months", ylab = "number of accident")
dev.off()
# afficher les données en semaines
png(file = "./export/nb_acc_par_semaine.png")
hist(df$weeks, breaks = -1:53, main = "Nombre d'accident par semaine", xlab = "weeks", ylab = "number of accident")
dev.off()
# afficher les données en heures
png(file = "./export/nb_acc_par_heure.png")
hist(df$hours, breaks = -1:24, main = "Nombre d'accident par heure", xlab = "hours", ylab = "number of accident")
dev.off()

# frises chronologiques

valeurs <- c(0:52)
resultats <- c()
for (i in 1:53) {
  resultat <- sum(df$weeks == valeurs[i])
  resultats[i] <- resultat
}
valeurs2 <- c(1:12)
resultats2 <- c()
for (i in 1:12) {
  resultat2 <- sum(df$month == valeurs2[i])
  resultats2[i] <- resultat2
}

# frise chronologique par mois
png(file = "./export/frise_chrono_acc_months.png")
plot(valeurs2, resultats2, type = "b", pch = 16, col = "blue", xlab = "Mois de l'année", ylab = "Nombre d'accidents", main = "Nombre d'accidents par mois en 2009", ylim=c(0, 8000))
dev.off()

# frise chronologique par semaine
png(file = "./export/frise_chrono_acc_weeks.png")
plot(valeurs, resultats, type = "b", pch = 16, col = "blue", xlab = "Semaines de l'année", ylab = "Nombre d'accidents", main = "Nombre d'accidents par semaine en 2009", ylim=c(0, 2000))
dev.off()
