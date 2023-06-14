# test <- read.csv('/Users/aubin/Documents/ecole/isen/CIR3/big data/projet_big_data/stat_acc_V3.csv', sep=';')

df <- read.csv('stat_acc_V3.csv', sep=';')

weights <- read.csv("poids_vehicules.csv", sep = ";")
gravity <- read.csv("niveaux_gravite.csv", sep = ";")
climat <- read.csv("climat.csv", sep = ";")
etat <- read.csv("etat.csv", sep = ";")
dept <- read.csv("departements-france.csv")

# preparation_données <- function(df, weights, gravity, dept){
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

    #maxime part

    # for (i in 1:length(df$date)) {

    #     #my_date <- as.Date(df$date[i])
    #     my_date <- as.POSIXct(df$date[i])

    #     months <- as.numeric(format(my_date, format = "%m"))
    #     years <- as.numeric(format(my_date, format = "%Y"))
    #     days <- as.numeric(format(my_date, format = "%d"))
    #     weeks <- as.numeric(format(my_date, format = "%W"))
    #     hours <- as.numeric(format(my_date, format = "%H"))

    #     df$month[i] <- months
    #     df$years[i] <- years
    #     df$days[i] <-  days
    #     df$weeks[i] <- weeks
    #     df$hours[i] <- hours
        
        # df$date[i] <- (as.numeric(as.POSIXct(df$date[i], format="%Y-%m-%d  %H:%M:%S")))
    # }
# }

# for (i in seq_len(nrow(gravity))) {
# df$gravity[df$descr_grav == gravity[i, 1]] <- as.numeric(gravity[i, 2])
# }
for (i in seq_len(nrow(climat))) {
df$descr_athmo[df$descr_athmo == climat[i, 1]] <- as.numeric(climat[i, 2])
}

for (i in seq_len(nrow(etat))) {
df$descr_etat_surf[df$descr_etat_surf == etat[i, 1]] <- as.numeric(etat[i, 2])
}

# preparation_données(df, weights, gravity, dept)

# as.numeric(df$month)

# afficher les données en mois
# hist(df$month, breaks = max(df$month)-min(df$month), main = "number of accident by month", xlab = "months", ylab = "number of accident")
# afficher les données en heures
# hist(df$hours, breaks = max(df$hours)-min(df$hours), main = "number of accident by hours", xlab = "hours", ylab = "number of accident")




# analyse des données

df$descr_etat_surf <- as.numeric(df$descr_etat_surf)
df$descr_athmo <- as.numeric(df$descr_athmo)
# tableau <- rbind(df$gravity, df$weight)
# # print(tableau[1])

# grav <- (unlist(df$gravity, use.names = FALSE))
# poid <- (unlist(df$weight, use.names = FALSE))

# a <- (unlist(df$descr_etat_surf, use.names = FALSE))
# b <- (unlist(df$descr_athmo, use.names = FALSE))

# gravpoid <- rbind(grav, poid)
# etatclimat <- rbind(a, b)

install.packages("RColorBrewer")
library("RColorBrewer")

# khi entre gravité et poids
khi_test <- chisq.test(table(df$weight, df$gravity))
png(file = "export/mosaic_gravite_poids.png")
mosaicplot(table(df$gravity, df$weight), color = brewer.pal(n=10,name = "Spectral"), main= "mosaic entre gravité et poids")
dev.off()
# print(khi_test)
a <- khi_test$p.value

# khi entre gravité et état de la route
khi_test <- chisq.test(table(df$gravity, df$descr_etat_surf))
png(file = "export/mosaic_gravite_etat_route.png")
mosaicplot(table(df$gravity, df$descr_etat_surf), color = brewer.pal(n=10,name = "Spectral"), main= "mosaic entre gravité et etat de la surface")
dev.off()
# print(khi_test)
# print(khi_test$p.value)
b <- khi_test$p.value

# khi entre gravité et état de l'atmosphère
khi_test <- chisq.test(table(df$gravity, df$descr_athmo))
png(file = "export/mosaic_gravite_etat_atmosphere.png")
mosaicplot(table(df$gravity, df$descr_athmo), color = brewer.pal(n=10,name = "Spectral"), main= "mosaic entre gravité et athmosphère")
dev.off()
# print(khi_test)
# print(khi_test$p.value)
c <- khi_test$p.value

# khi entre gravité état de la route et l'atmosphère
khi_test <- chisq.test(table(df$descr_etat_surf, df$descr_athmo))
png(file = "export/mosaic_etat_surface_etat_atmosphere.png")
mosaicplot(table(df$descr_etat_surf, df$descr_athmo), color = brewer.pal(n=10,name = "Spectral"), main= "mosaic entre etat de la surface et athmosphère")
dev.off()
# print(khi_test)
# print(khi_test$p.value)
d <- khi_test$p.value

khi_test <- chisq.test(table(df$an_nais, df$id_usa))
# print(khi_test)
# print(khi_test$p.value)
e <- khi_test$p.value

cat("gravité et poids :", a,"\ngravité et etat surface :",b,"\ngravité et athmo :",c,"\netat surf et athmo :",d,"\n","id_usa et age naissance : ",e)

# # Réalisation du test khi-deux - les résultats sont sauvegardés dans "khi_test"
# khi_test <- chisq.test(gravpoid)
# khi_test <- chisq.test(etatclimat)

# khi_test <- chisq.test(df$descr_etat_surf, df$descr_athmo)
# khi_test <- chisq.test(df$gravity, df$descr_athmo)
# khi_test <- chisq.test(df$descr_etat_surf, df$gravity)
# khi_test <- chisq.test(tabCont)
# print(khi_test)
# print(khi_test$p.value)
# khi_test$p.value
# print("end")
