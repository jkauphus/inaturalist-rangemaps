library(tidyverse)
library(sf)
library(glue)
library(arcgisbinding)
library(reticulate)
arc.check_product()

# This script is to take each of the taxa species lists and append them all together into on dataframe
# From there I can just write them out to hopefully a ESRI geodatabase

# First on Amphibians

p3 <- "\\.gpkg?$"
files <- list.files("files/point-observations/Amphibian/", pattern = p3, recursive = TRUE, full.names = TRUE)

amph<- sapply(files, read_sf, simplify = FALSE) %>% bind_rows()

arc.write("./files/point-observations/Amphibian/inat_amphibians.gdb/inat_amphibian_records", data= amph)

# Second on Birds

p3 <- "\\.gpkg?$"
files <- list.files("files/point-observations/Bird/", pattern = p3, recursive = TRUE, full.names = TRUE)

bird<- sapply(files, read_sf, simplify = FALSE) %>% bind_rows()

arc.write("./files/point-observations/Bird/inat_birds.gdb/inat_bird_records", data= bird)

# Third on Fish

p3 <- "\\.gpkg?$"
files <- list.files("files/point-observations/Fish/", pattern = p3, recursive = TRUE, full.names = TRUE)

fish<- sapply(files, read_sf, simplify = FALSE) %>% bind_rows()

arc.write("./files/point-observations/Fish/inat_fishes.gdb/inat_fish_records", data= fish)

# Fourth on Mammals

p3 <- "\\.gpkg?$"
files <- list.files("files/point-observations/Mammal/", pattern = p3, recursive = TRUE, full.names = TRUE)

mamm<- sapply(files, read_sf, simplify = FALSE) %>% bind_rows()

arc.write("./files/point-observations/Mammal/inat_mammals.gdb/inat_mammal_records", data= mamm)

# Fifth on Plants

p3 <- "\\.gpkg?$"
files <- list.files("files/point-observations/Plants/", pattern = p3, recursive = TRUE, full.names = TRUE)

plant<- sapply(files, read_sf, simplify = FALSE) %>% bind_rows()

arc.write("./files/point-observations/Plants/inat_plants.gdb/inat_plant_records", data= plant)

# Finally on Reptiles

p3 <- "\\.gpkg?$"
files <- list.files("files/point-observations/Reptile/", pattern = p3, recursive = TRUE, full.names = TRUE)

rept<- sapply(files, read_sf, simplify = FALSE) %>% bind_rows()

arc.write("./files/point-observations/Reptile/inat_reptiles.gdb/inat_reptile_records", data= rept)
