# test <- read.csv('/Users/aubin/Documents/ecole/isen/CIR3/big data/projet_big_data/stat_acc_V3.csv', sep=';')

df <- read.csv('stat_acc_V3.csv', sep=';')

weights <- read.csv("poids_vehicules.csv", sep = ";")
gravity <- read.csv("niveaux_gravite.csv", sep = ";")
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

# preparation_données(df, weights, gravity, dept)

# as.numeric(df$month)

# afficher les données en mois
# hist(df$month, breaks = max(df$month)-min(df$month), main = "number of accident by month", xlab = "months", ylab = "number of accident")
# afficher les données en heures
# hist(df$hours, breaks = max(df$hours)-min(df$hours), main = "number of accident by hours", xlab = "hours", ylab = "number of accident")




# analyse des données

# as.numeric(df$gravity)
# as.numeric(df$weight)
tableau <- rbind(df$gravity, df$weight)
# print(tableau[1])

m <- (unlist(df$gravity, use.names = FALSE))
n <- (unlist(df$weight, use.names = FALSE))
tableau <- rbind(m, n)
# print(m)
print(n)
# print(tableau)
# # Réalisation du test khi-deux - les résultats sont sauvegardés dans "khi_test"
khi_test <- chisq.test(tableau)
print(khi_test)
print("end")