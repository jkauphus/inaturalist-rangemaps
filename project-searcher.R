library(tidyverse)
library(sf)
library(glue)
library(leaflet)
library(rinat)
library(rebird)
library(rbison)
library(USAboundaries)

# Species Specification
species = 'Buteo swainsoni'

# Project Area
project <- read_sf("./files/Project/project_area.shp")

# Bounding Area

###southwest <-us_states(states = c('california', 'utah', 'arizona', 'nevada'))
nevada <- us_states(states = 'nevada')

# API Connections

inat = get_inat_obs(query = glue("{species}"), quality = "research", geo = TRUE, maxresults = 10000, bounds = nevada) %>% 
  filter(scientific_name == glue("{species}"))

ebird = ebirdregion(loc = 'US', species_code(sciname = glue("{species}")), key = '45cjoh9cialb')

bison <- bison(species = glue("{species}"), state = "Nevada")$points

# Turn them into GIS Layers with 4326

inat <- st_as_sf(x = inat, 
               coords = c("longitude", "latitude"),
               crs = 4326)
ebird <- st_as_sf(x = ebird, 
               coords = c("lng", "lat"),
               crs = 4326)

bison <- st_as_sf(x = ebird, 
                  coords = c("decimalLongitude", "decimalLatitude"),
                  crs = 4326)

project <- st_transform(project, 4326)

# leaflet Map

leaflet() %>% 
  addProviderTiles(providers$Esri.WorldImagery) %>%
  addProviderTiles(providers$OpenStreetMap, group = "StreetView") %>%
  
  addPolygons(data = project, 
              group = 'Project',
              layerId = 40,
              color="#807B7A", 
              fillColor = "#807B7A", 
              fillOpacity = 0.3,
              opacity = 0.3) %>%
  
  addCircles(data = inat, group = "iNaturalist", color = 'green') %>%
  addCircles(data = bison, group = "BISON", color = 'orange') %>%
  addCircles(data = ebird, group = "ebird", color = "blue") %>%
  addLayersControl(overlayGroups = c("StreetView","Project", "iNaturalist","BISON", "ebird"),
                   options = layersControlOptions(collapsed = F))
  
