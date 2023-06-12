df <- read.csv("stat_acc_V3.csv", sep = ";")

# test <- is.na(df$place)
# test <- sort(test)
# print(c(rownames(df$Num_Acc[df$age == "NULL"])))

test <- c()
for (i in seq_len(nrow(df))) {
  if (df$age[i] == "NULL") {
    test <- append(test, i)
  }
}


# print(rownames(df))
# print(which(is.na(df$age)))