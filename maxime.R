# preparation_données(df, weights, gravity, dept)

# as.numeric(df$month)




# analyse des données

# df$etat_surf_num <- as.numeric(df$etat_surf_num).

# # df$athmo_num <- as.numeric(df$athmo_num)
# # tableau <- rbind(df$gravity, df$weight)
# # # print(tableau[1])

# # grav <- (unlist(df$gravity, use.names = FALSE))
# # poid <- (unlist(df$weight, use.names = FALSE))

# # a <- (unlist(df$etat_surf_num, use.names = FALSE))
# # b <- (unlist(df$athmo_num, use.names = FALSE))

# # gravpoid <- rbind(grav, poid)
# # etatclimat <- rbind(a, b)


# # khi entre gravité et poids
# khi_test <- chisq.test(table(df$weight, df$gravity))
# png(file = "export/mosaic_gravite_poids.png")
# mosaicplot(table(df$gravity, df$weight), color = brewer.pal(n = 10, name = "Spectral"), main = "mosaic entre gravité et poids")
# dev.off()
# # print(khi_test)
# a <- khi_test$p.value

# # khi entre gravité et état de la route
# khi_test <- chisq.test(table(df$gravity, df$etat_surf_num))
# png(file = "export/mosaic_gravite_etat_route.png")
# mosaicplot(table(df$gravity, df$etat_surf_num), color = brewer.pal(n = 10, name = "Spectral"), main = "mosaic entre gravité et etat de la surface")
# dev.off()
# # print(khi_test)
# # print(khi_test$p.value)
# b <- khi_test$p.value

# # khi entre gravité et état de l'atmosphère
# khi_test <- chisq.test(table(df$gravity, df$athmo_num))
# png(file = "export/mosaic_gravite_etat_atmosphere.png")
# mosaicplot(table(df$gravity, df$athmo_num), color = brewer.pal(n = 10, name = "Spectral"), main = "mosaic entre gravité et athmosphère")
# dev.off()
# # print(khi_test)
# # print(khi_test$p.value)
# c <- khi_test$p.value

# # khi entre gravité état de la route et l'atmosphère
# khi_test <- chisq.test(table(df$etat_surf_num, df$athmo_num))
# png(file = "export/mosaic_etat_surface_etat_atmosphere.png")
# mosaicplot(table(df$etat_surf_num, df$athmo_num), color = brewer.pal(n = 10, name = "Spectral"), main = "mosaic entre etat de la surface et athmosphère")
# dev.off()
# # print(khi_test)
# # print(khi_test$p.value)
# d <- khi_test$p.value

# khi_test <- chisq.test(table(df$an_nais, df$id_usa))
# # print(khi_test)
# # print(khi_test$p.value)
# e <- khi_test$p.value

# cat("gravité et poids :", a, "\ngravité et etat surface :", b, "\ngravité et athmo :", c, "\netat surf et athmo :", d, "\n", "id_usa et age naissance : ", e, "\n")

# # Réalisation du test khi-deux - les résultats sont sauvegardés dans "khi_test"
# khi_test <- chisq.test(gravpoid)
# khi_test <- chisq.test(etatclimat)

# khi_test <- chisq.test(df$etat_surf_num, df$athmo_num)
# khi_test <- chisq.test(df$gravity, df$athmo_num)
# khi_test <- chisq.test(df$etat_surf_num, df$gravity)
# khi_test <- chisq.test(tabCont)
# print(khi_test)
# print(khi_test$p.value)
# khi_test$p.value
# print("end")

# valeurs <- c(0:52)
# resultats <- c()
# for (i in 1:53) {
#   resultat <- sum(df$weeks == valeurs[i])
#   resultats[i] <- resultat
# }
# valeurs2 <- c(1:12)
# resultats2 <- c()
# for (i in 1:12) {
#   resultat2 <- sum(df$month == valeurs2[i])
#   resultats2[i] <- resultat2
# }
# png(file = "./export/frise_chrono_acc_months.png")
# plot(valeurs2, resultats2, type = "b", pch = 16, col = "blue", xlab = "Mois de l'année", ylab = "Nombre d'accidents", main = "Nombre d'accidents par mois en 2009", ylim=c(0, 8000))
# dev.off()

# png(file = "./export/frise_chrono_acc_weeks.png")
# plot(valeurs, resultats, type = "b", pch = 16, col = "blue", xlab = "Semaines de l'année", ylab = "Nombre d'accidents", main = "Nombre d'accidents par semaine en 2009", ylim=c(0, 2000))
# dev.off()

