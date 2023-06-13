# test <- read.csv('/Users/aubin/Documents/ecole/isen/CIR3/big data/projet_big_data/stat_acc_V3.csv', sep=';')

df <- read.csv('stat_acc_V3.csv', sep=';')

# character <- "2021-4-4 02:23:34"
# character <- "14/01/2009  08:45:00"

# for (i in 1:length(df$date)) {

#     my_date <- as.Date(df$date[i])

#     months <- as.numeric(format(my_date, format = "%m"))
#     years <- as.numeric(format(my_date, format = "%Y"))
#     days <- as.numeric(format(my_date, format = "%d"))
#     weeks <- as.numeric(format(my_date, format = "%W"))

#     df$month[i] <- months
#     df$years[i] <- years
#     df$days[i] <-  days
#     df$weeks[i] <- weeks
    
#     df$date[i] <- (as.numeric(as.POSIXct(df$date[i], format="%Y-%m-%d  %H:%M:%S")))
# }



as.numeric(df$date)
as.numeric(df$place)

tableau <- rbind(df$age,df$place)
# Réalisation du test khi-deux - les résultats sont sauvegardés dans "khi_test"
khi_test <- chisq.test(tableau)

print("end")