library(tidyverse)
library(sf)
library(glue)
library(leaflet)
library(rinat)
library(USAboundaries)
library(raster)
library(adehabitatHR)

# This script is to grab the species observations and create a range map from the observations

# Select a species

species = "Heloderma suspectum"

# Create a southwestern bounding box

southwest <-us_states(states = c('california', 'utah', 'arizona', 'nevada'))

# Pull in the inaturalist data

x = get_inat_obs(query = glue("{species}"), quality = "research", geo = TRUE, maxresults = 10000, bounds = southwest) %>% 
  filter(scientific_name == glue("{species}"))

x <- st_as_sf(x = x, 
              coords = c("longitude", "latitude"),
              crs = "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0")

# Backup, if you wanted to pull inaturalist from gbif
#Gila<-data.frame(gbif("Heloderma", species = "suspectum", geo = TRUE, sp = TRUE, download = TRUE, removeZeros = TRUE, ext = extent))

# Now lets make the Kernal density estimation polygon for the project

coords <- SpatialPoints(st_coordinates(x), proj4string = CRS("+proj=longlat +datum=WGS84"))

kde<-kernelUD(coords, h ="href", kern = "bivnorm", grid = 100)

kde_polygon <-getverticeshr(kde, percent = 99)                      

shape <- st_as_sf(kde_polygon)

# Lets take a look at it with leaflet

leaflet(x) %>% 
  addProviderTiles(providers$OpenStreetMap) %>% 
  addPolygons(data = shape, col = "green", smoothFactor = 0.5) %>% 
  addCircleMarkers(weight = 3, col = "forestgreen")

# write to output folder

st_write(shape, glue("./output/{species}.gpkg", overwrite = T))
