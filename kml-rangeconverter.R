library(tidyverse)
library(rinat)
library(sf)
library(glue)
library(leaflet)

# The purpose of this script is to view the range maps of the inaturalist range maps and have them converted from kmz to gpkg
#packages

# Okay, so species that are wildlife, tend to have range maps in kmz files, so all you need to do in the browser is copy a url like so
# https://www.inaturalist.org/taxa/3938/range.kml

# What is the species
species = "Heloderma suspectum"

x = get_inat_obs(query = glue("{species}"), quality = "research", geo = TRUE, maxresults = 1)

id <- x$taxon_id

utils::browseURL(glue("https://www.inaturalist.org/taxa/{id}/range.kml"))

# Now you can drag it into the file folder and change the name

# load in the kml
rangemap <- st_read("./files/heloderma-suspectum.kml")

# now just write it as a gpkg file

st_write(shape, glue("./output/{species}.gpkg", overwrite = T))
