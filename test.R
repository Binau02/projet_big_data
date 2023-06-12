# test <- read.csv('/Users/aubin/Documents/ecole/isen/CIR3/big data/projet_big_data/stat_acc_V3.csv', sep=';')
test <- read.csv('stat_acc_V3.csv', sep=';')
test$descr_cat_veh[test$descr_cat_veh == 'Autobus'] <- 20000
# print(test$descr_cat_veh)
# print(test)