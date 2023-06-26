agglo <- read.csv("data/agglo.csv", sep = ";")
collision <- read.csv("data/collision.csv", sep = ";")
dispositif_securite <- read.csv("data/dispositif_securite.csv", sep = ";")
intersection <- read.csv("data/intersection.csv", sep = ";")
motif <- read.csv("data/motif.csv", sep = ";")

for (i in seq_len(nrow(agglo))) {
  df$descr_agglo[df$descr_agglo == agglo[i, 1]] <- agglo[i, 2]
}

for (i in seq_len(nrow(collision))) {
  df$descr_type_col[df$descr_type_col == collision[i, 1]] <- collision[i, 2]
}

for (i in seq_len(nrow(dispositif_securite))) {
  df$descr_dispo_secu[df$descr_dispo_secu == dispositif_securite[i, 1]] <- dispositif_securite[i, 2]
}

for (i in seq_len(nrow(intersection))) {
  df$description_intersection[df$description_intersection == intersection[i, 1]] <- intersection[i, 2]
}

for (i in seq_len(nrow(motif))) {
  df$descr_motif_traj[df$descr_motif_traj == motif[i, 1]] <- motif[i, 2]
}

