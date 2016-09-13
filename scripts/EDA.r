#######################
# EDA FOR CODE FOR DC #
#######################

directory <- "C:/Users/Mao/Downloads/Code for DC maps"
setwd(directory)

library(maptools)
library(ggplot2)
library(ggmap)
library(rgdal)
library(readr)
library(broom)

new_columbia <- readOGR(dsn="C:/Users/Mao/Downloads/New_Columbia_Boundary", layer="New_Columbia_Boundary")
plot(new_columbia)
coordinates(new_columbia)

overlay_zones <- readOGR(dsn="C:/Users/Mao/Downloads/Overlay_Zones", layer="Overlay_Zones")
plot(overlay_zones)
coordinates(overlay_zones)

# load data
puds <- readOGR(dsn="C:/Users/Mao/Downloads/Planned_Unit_Development_PUDs", layer="Planned_Unit_Development_PUDs")
coordinates(puds)

data <- read_csv("")

 # convert the shapefile to a data frame
puds_data <- fortify(puds)
head(shapedata)

map <- get_map("641 S Street NW, Washington, DC", zoom=13)
ggmap(map)

ggmap(map) + geom_polygon(aes(x=long, y=lat, group=group), 
               data=fortify(puds_data), color='black', 
               fill=NA, size=1)

