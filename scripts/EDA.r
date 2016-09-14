#######################
# EDA FOR CODE FOR DC #
#######################

directory <- "C:/Users/Mao/Documents/GitHub/greatergreaterhousing"
setwd(directory)

library(maptools)
library(ggplot2)
library(ggmap)
library(rgdal)
library(readr)
library(broom)
library(dplyr)

# load data
puds <- readOGR(dsn=paste0(directory, "/data/Planned_Unit_Development_PUDs"), layer="Planned_Unit_Development_PUDs")

# convert the shapefile to a data frame
puds_data <- as(puds, "data.frame")
plot_data <- tidy(puds)

# merge the data
merged_data <- merge(puds_data, plot_data, by.x="row.names", by.y="id", all.y=TRUE)

# get a map of DC
map <- get_map("641 S Street NW, Washington, DC", zoom=12)
ggmap(map)

# mutate PUD_ZONING INTO SOMETHING SIMPLER
merged_data <- mutate(merged_data,
                      ZONING = ifelse(substring(PUD_ZONING,1,1)=='C', "Commercial",
                                      ifelse(substring(PUD_ZONING,1,1)=='R', "Residential",
                                             "Other")
                                      )
                      )

ggmap(map) + geom_polygon(aes(x=long, y=lat, group=group, fill=ZONING), 
               data=fortify(merged_data), color='black', 
               size=0.5) +
  theme_bw() +
  theme(legend.position="bottom") +
  ggtitle("Zoning of Planned Unit Developments")

