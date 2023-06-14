# preparation_données(df, weights, gravity, dept)

# as.numeric(df$month)




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
mosaicplot(table(df$gravity, df$weight), color = brewer.pal(n = 10, name = "Spectral"), main = "mosaic entre gravité et poids")
dev.off()
# print(khi_test)
a <- khi_test$p.value

# khi entre gravité et état de la route
khi_test <- chisq.test(table(df$gravity, df$descr_etat_surf))
print(khi_test)
png(file = "export/mosaic_gravite_etat_route.png")
mosaicplot(table(df$gravity, df$descr_etat_surf), color = brewer.pal(n = 10, name = "Spectral"), main = "mosaic entre gravité et etat de la surface")
dev.off()
# print(khi_test)
# print(khi_test$p.value)
b <- khi_test$p.value

# khi entre gravité et état de l'atmosphère
khi_test <- chisq.test(table(df$gravity, df$descr_athmo))
png(file = "export/mosaic_gravite_etat_atmosphere.png")
mosaicplot(table(df$gravity, df$descr_athmo), color = brewer.pal(n = 10, name = "Spectral"), main = "mosaic entre gravité et athmosphère")
dev.off()
# print(khi_test)
# print(khi_test$p.value)
c <- khi_test$p.value

# khi entre gravité état de la route et l'atmosphère
khi_test <- chisq.test(table(df$descr_etat_surf, df$descr_athmo))
png(file = "export/mosaic_etat_surface_etat_atmosphere.png")
mosaicplot(table(df$descr_etat_surf, df$descr_athmo), color = brewer.pal(n = 10, name = "Spectral"), main = "mosaic entre etat de la surface et athmosphère")
dev.off()
# print(khi_test)
# print(khi_test$p.value)
d <- khi_test$p.value

khi_test <- chisq.test(table(df$an_nais, df$id_usa))
# print(khi_test)
# print(khi_test$p.value)
e <- khi_test$p.value

cat("gravité et poids :", a, "\ngravité et etat surface :", b, "\ngravité et athmo :", c, "\netat surf et athmo :", d, "\n", "id_usa et age naissance : ", e)

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


library(car)
scatterplot(df$weeks, data=df)