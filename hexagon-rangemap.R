library(tidyverse)
library(ggplot2)
library(sf)
library(glue)
library(leaflet)
library(rinat)
library(USAboundaries)
#library(raster)
library(adehabitatHR)

# This script is to grab the species observations and create a range map from the observations

# Select a species

species = "Heloderma suspectum"

# Create a southwestern bounding box

southwest <-us_states(states = c('california', 'utah', 'arizona', 'nevada'))

# Pull in the inaturalist data

x = get_inat_obs(query = glue("{species}"), quality = "research", geo = TRUE, maxresults = 10000, bounds = southwest) %>% 
  filter(scientific_name == glue("{species}"))

sp <- st_as_sf(x = x, 
              coords = c("longitude", "latitude"),
              crs = 4326)

# Now since it is soooo popular, lets convert the point data into a hexagonal layer


# put the points in a hex polygon

grid <- st_make_grid(sp,
                      cellsize = 0.1, # Kms
                     crs = st_crs(sp),
                     what = "polygons",
                     square = FALSE # This is the only piece that changes!!!
)

grid <- st_sf(index = 1:length(lengths(grid)), grid) # Add index

# The intersection Method to pull in the point data to a hexagon

hex_x <- st_intersection(grid, sp)

areas<- hex_x %>% 
  group_by(id) %>%
  as.data.frame() %>% 
  dplyr::select(-grid)

hex_data <- left_join(hex_x, areas)

hex_data <- hex_data %>% 
  mutate(hex_id = 1:nrow(.)) %>% 
  dplyr::select(index, hex_id, everything()) %>% 
  as.data.frame() %>% 
  dplyr::select(-grid)

hexxed <- right_join(grid, hex_data, by = "index")

duplicates <- hexxed %>% 
  dplyr::select(scientific_name, index) %>% 
  duplicated()

final <- hexxed %>% 
  filter(!duplicates)

#### Leaflet Test

library(leaflet)
display<-st_transform(final, crs = 4326)

leaflet(display) %>% 
  addTiles() %>% 
  addPolygons()

# write to output folder

#st_write(hexxed, glue("./output/{species}.gpkg", overwrite = T))