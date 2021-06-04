library(tidyverse)
library(rinat)
library(sf)
library(glue)

# The purpose of this script is to view the range maps of the inaturalist range maps and have them converted from kmz to gpkg
#packages

# Okay, so species that are wildlife, tend to have range maps in kmz files, so all you need to do in the browser is copy a url like so
# https://www.inaturalist.org/taxa/3938/range.kml

# What is the species
species = "(Phalaropus tricolor)"

x = get_inat_obs(query = glue("{species}"), geo = TRUE, maxresults = 1)
x$common_name
x$scientific_name
id <- x$taxon_id

utils::browseURL(glue("https://www.inaturalist.org/taxa/{id}/range.kml"))

# Now you can drag it into the file folder and change the name

# load in the kml
rangemap <- st_read("./files/heloderma-suspectum.kml")

# now just write it as a gpkg file

st_write(shape, glue("./output/{species}.gpkg", overwrite = T))

# Now to pull in point observations for each species and save them. 
library(USAboundaries)
library(rbison)

# Nevada bounding box

nevada <- us_states(states = 'nevada')

## First Amphibians list

amphibians <- read.csv("./files/amphibian-list-inat.csv")
names(amphibians) <- c("comname", "scientific_name")
amphibian_comname <- amphibians$comname

inat <- function(x){
  tryCatch(
    expr = { x = get_inat_obs(query = glue("{amphibian_comname[i]}"), quality = "research", geo = TRUE, maxresults = 10000, bounds = nevada)
    x <- st_as_sf(x = x, 
                  coords = c("longitude", "latitude"),
                  crs = 4326)
    st_write(x,glue("./files/point-observations/{amphibian_comname[i]}.gpkg"), overwrite = TRUE)
    },
    error = function(e) {
      e = NA
      return(e)
    }
  )
}

## Loop to iterative download each inat observations and save them as a shapefile under point-observations

for(i in 1:length(amphibian_comname)){
  x = inat()
}

## Second Bird list

birds <- read.csv("./files/bird-list-inat.csv")
names(birds) <- c("comname", "scientific_name")
comname <- birds$comname

inat <- function(x){
  tryCatch(
    expr = { x = get_inat_obs(query = glue("{comname[i]}"), quality = "research", geo = TRUE, maxresults = 10000, bounds = nevada)
    x <- st_as_sf(x = x, 
                  coords = c("longitude", "latitude"),
                  crs = 4326)
    st_write(x,glue("./files/point-observations/{comname[i]}.gpkg"), overwrite = TRUE)
    },
    error = function(e) {
      e = NA
      return(e)
    }
  )
}

## Loop to iterative download each inat observations and save them as a shapefile under point-observations

for(i in 1:length(comname)){
  x = inat()
}

## Third Fishes list

fishes <- read.csv("./files/fish-list-inat.csv")
names(fishes) <- c("comname", "scientific_name")
comname <- fishes$comname

for(i in 1:length(comname)){
  x = inat()
}

# Fourth Invert list

invert <- read.csv("./files/inverts-list-inat.csv")
names(invert) <- c("comname", "scientific_name")
comname <- invert$comname

for(i in 1:length(comname)){
  x = inat()
}

# Fifth Mammal list

mammal <- read.csv("./files/mammal-list-inat.csv")
names(mammal) <- c("comname", "scientific_name")
comname <- mammal$comname

for(i in 1:length(comname)){
  x = inat()
}

# Six Reptiles list

reptile <- read.csv("./files/reptile-list-inat.csv")
names(reptile) <- c("comname", "scientific_name")
comname <- reptile$comname

for(i in 1:length(comname)){
  x = inat()
}

# Seven Plant list

plant <- read.csv("./files/plants-list-inat.csv")
names(plant) <- c("comname", "scientific_name")
comname <- plant$comname

for(i in 1:length(comname)){
  x = inat()
}
