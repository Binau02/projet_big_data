# indiquer les formats de chaque colonnes
df <- as.tibble(df)

# tracer les regression lineaires
png(file = "./export/regression_lineaire_semaine.png")
scatterplot(gravity ~ weeks, data = df)
png(file = "./export/regression_lineaire_mois.png")
scatterplot(gravity ~ month, data = df)

# réaliser la regression lineaire simple
gravity.lm1 <- lm(gravity ~ weeks, data = df)
gravity.lm2 <- lm(gravity ~ month, data = df)
png(file = "./export/ressidus_semaine.png")
plot(gravity.lm1, 2)
png(file = "./export/ressidus_mois.png")
plot(gravity.lm2, 2)