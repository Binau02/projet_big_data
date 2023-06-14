# indiquer les formats de chaque colonnes
# df <- as.tibble(df)

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

#