# tracer les regression lineaires
png(file = "./export/regression_lineaire_semaine.png")
scatterplot(weeks_gravity_cumul ~ weeks_cumul, data = df)
dev.off()
png(file = "./export/regression_lineaire_mois.png")
scatterplot(month_gravity_cumul ~ month_cumul, data = df)
dev.off()

# réaliser la regression lineaire simple
gravity_lm1 <- lm(weeks_gravity_cumul ~ weeks_cumul, data = df)
gravity_lm2 <- lm(month_gravity_cumul ~ month_cumul, data = df)
png(file = "./export/ressidus_semaine.png")
plot(gravity_lm1, 2)
dev.off()
png(file = "./export/ressidus_mois.png")
plot(gravity_lm2, 2)
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