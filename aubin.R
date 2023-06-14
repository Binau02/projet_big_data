coords <- read.csv("data/insee-lat-lon.csv")

for (i in seq_len(nrow(df))) {
  temp <- coords[coords$code_commune_INSEE == df$id_code_insee[i], ]
  # print(temp)
  df$latitude[i] <- temp$latitude
  df$longitude[i] <- temp$longitude
}