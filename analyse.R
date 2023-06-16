################
# ANALYSE #
################


# khi entre gravité et poids
khi_test <- chisq.test(table(df$weight, df$gravity))
png(file = "export/mosaic_gravite_poids.png")
mosaicplot(table(df$gravity, df$weight), color = ("skyblue2"), main = "mosaic entre gravité et poids")
dev.off()
a <- khi_test$p.value

# khi entre gravité et état de la route
khi_test <- chisq.test(table(df$gravity, df$etat_surf_num))
png(file = "export/mosaic_gravite_etat_route.png")
mosaicplot(table(df$gravity, df$etat_surf_num), color = ("skyblue2"), main = "mosaic entre gravité et etat de la surface")
dev.off()
b <- khi_test$p.value

# khi entre gravité et état de l'atmosphère
khi_test <- chisq.test(table(df$gravity, df$athmo_num))
png(file = "export/mosaic_gravite_etat_atmosphere.png")
mosaicplot(table(df$gravity, df$athmo_num), color = ("skyblue2"), main = "mosaic entre gravité et athmosphère")
dev.off()
c <- khi_test$p.value

# khi entre gravité état de la route et l'atmosphère
khi_test <- chisq.test(table(df$etat_surf_num, df$athmo_num))
png(file = "export/mosaic_etat_surface_etat_atmosphere.png")
mosaicplot(table(df$etat_surf_num, df$athmo_num), color = ("skyblue2"), main = "mosaic entre etat de la surface et athmosphère")
dev.off()
d <- khi_test$p.value

# khi entre gravité et luminosité
khi_test <- chisq.test(table(df$lum_num, df$gravity))
png(file = "export/mosaic_lum_gravite.png")
mosaicplot(table(df$etat_surf_num, df$athmo_num), color=brewer.pal(n = 10, name = "Spectral"), main = "mosaic entre la luminosité et gravité")
dev.off()
f <- khi_test$p.value

# khi entre gravité et age naissance / normalement contient une p-value grande car pas de dépendance apparente
khi_test <- chisq.test(table(df$an_nais, df$id_usa))
e <- khi_test$p.value

cat("gravité et poids :", a, "\ngravité et etat surface :", b, "\ngravité et athmo :", c, "\netat surf et athmo :", d, "\n", "id_usa et age naissance : ", e,"\ngravité et lumi : ",f ,"\n")


# tracer les regression lineaires
png(file = "./export/regression_lineaire_semaine.png")
scatterplot(weeks_gravity_cumul ~ weeks_cumul, data = df)
dev.off()
png(file = "./export/regression_lineaire_mois.png")
scatterplot(month_gravity_cumul ~ month_cumul, data = df)
dev.off()

# réaliser la regression lineaire simple
gravity.lm1 <- lm(weeks_gravity_cumul ~ weeks_cumul, data = df)
gravity.lm2 <- lm(month_gravity_cumul ~ month_cumul, data = df)
png(file = "./export/ressidus_semaine.png")
plot(gravity.lm1, 2)
dev.off()
png(file = "./export/ressidus_mois.png")
plot(gravity.lm2, 2)
dev.off()

# r-carré
week_r2 <- summary(gravity_lm1)$r.squared
month_r2 <- summary(gravity_lm2)$r.squared

# r-carré ajusté
week_r2_ajusted <- summary(gravity_lm1)$adj.r.squared
month_r2_ajusted <- summary(gravity_lm2)$adj.r.squared

print(week_r2)
print(month_r2)
print(week_r2_ajusted)
print(month_r2_ajusted)