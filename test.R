# temp <- c()

# for (i in 1:12) {
#   for (j in 1:31) {
#     cat(j, "/", i, "->", nrow(test[test$oui == paste(as.character(j), as.character(i)),]), "\n")
#     # count <- count +1
#     temp <- append(temp, nrow(test[test$oui == paste(as.character(j), as.character(i)),]))
#   }
# }

sum <- 0

for (j in 1:31) {
  cat(j, "/", 1, "->", nrow(test[test$oui == paste(as.character(j), "1"),]), "\n")
  sum <- sum + nrow(test[test$oui == paste(as.character(j), as.character(i)),])
}