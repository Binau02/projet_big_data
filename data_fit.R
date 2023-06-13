################
# DATA fitting #
################


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



######################
# DATA visualisation #
######################


# plot by age
png(file = "./export/nb_acc_par_age.png")
hist(df$age, breaks = max(df$age)-min(df$age)+1, main = "number of accident by age", xlab = "age", ylab = "number of accident")
dev.off()

# plot by athmospheric conditions
png(file="./export/nb_acc_par_athmo.png")
barplot(table(df$descr_athmo), las = 2)
dev.off()
png(file="./export/nb_acc_par_athmo_anormale.png")
barplot(table(df$descr_athmo)[-4], las = 2)
dev.off()

# plot by surface
png(file = "./export/nb_acc_par_surf.png")
barplot(table(df$descr_etat_surf), las = 2)
dev.off()
png(file = "./export/nb_acc_par_surf_anormale.png")
barplot(table(df$descr_etat_surf)[-8], las = 2)
dev.off()

# plot by gravity
test <- table(df$descr_grav)
png(file = "./export/nb_acc_par_grav.png")
barplot(as.table(c(test["Indemne"], test["Blessé léger"], test["Blessé hospitalisé"], test["Tué"])), las = 2)
dev.off()

# plot by city
test <- table(df["ville"])
test <- test[order(test, decreasing = TRUE)]
png(file = "./export/nb_acc_par_ville_top_30.png")
barplot(head(test, n = 30), las = 2)
dev.off()

#map
extraWD <- "."
library(tidyverse)
library(dplyr)
library(sf)
library(ggplot2)
library(tmap)
library(leaflet)
if (!file.exists(file.path(extraWD, "departement.zip"))) {
  githubURL <- "https://github.com/statnmap/blog_tips/raw/master/2018-07-14-introduction-to-mapping-with-sf-and-co/data/departement.zip"
  download.file(githubURL, file.path(extraWD, "departement.zip"))
  unzip(file.path(extraWD, "departement.zip"), exdir = extraWD)
}

#use database
departements_L93 <- st_read(dsn = extraWD, layer = "DEPARTEMENT", quiet = TRUE) %>% 
st_transform(2154)

#transform departements into regions
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
    }
    else {
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
    }
    else {
      n <- 97
    }
  }
  departements_L93$acc[i] <- depts[n]
  if (depts[n] != 0) {
    departements_L93$taux_acc_grave[i] <- depts_grave[n] / depts[n] * 100
  }
  else {
    departements_L93$taux_acc_grave[i] <- 0
  }
}
for (i in seq_len(nrow(region_L93))) {
  region_L93$acc[i] <- reg[as.numeric(region_L93$CODE_REG[i])]
  if (reg[as.numeric(region_L93$CODE_REG[i])] != 0) {
    region_L93$taux_acc_grave[i] <- reg_grave[as.numeric(region_L93$CODE_REG[i])] / reg[as.numeric(region_L93$CODE_REG[i])] * 100
  }
  else {
    region_L93$taux_acc_grave[i] <- 0
  }
}

#departements map
g_departement <- ggplot(departements_L93) +
  aes(color = acc) +
  scale_color_continuous(low = "yellow", high = "red") +
  geom_sf(aes(fill = acc)) +
  scale_fill_continuous(low = "yellow", high = "red") +
  coord_sf(crs = 4326) +
  guides(fill = FALSE) +
  ggtitle("Nombre d'accidents par département") +
  theme(title = element_text(size = 16), plot.margin = unit(c(0,0.1,0,0.25), "inches"))

png(file = "./export/nb_acc_par_dept.png")
print(g_departement)
dev.off()

#regions map
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

#departements map
g_departement <- ggplot(departements_L93) +
  aes(color = taux_acc_grave) +
  scale_color_continuous(low = "yellow", high = "red") +
  geom_sf(aes(fill = taux_acc_grave)) +
  scale_fill_continuous(low = "yellow", high = "red") +
  coord_sf(crs = 4326) +
  guides(fill = FALSE) +
  ggtitle("Taux d'accidents graves par département") +
  theme(title = element_text(size = 16), plot.margin = unit(c(0,0.1,0,0.25), "inches"))

png(file = "./export/taux_acc_grave_par_dept.png")
print(g_departement)
dev.off()

#regions map
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


M <- 
dimnames(M) <- list()
(test <- chisq.test(M))