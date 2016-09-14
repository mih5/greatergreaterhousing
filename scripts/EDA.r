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

ggmap(map)

# mutate PUD_ZONING INTO SOMETHING SIMPLER
merged_data <- mutate(merged_data,
                      ZONING = ifelse(substring(PUD_ZONING,1,1)=='C', "Commercial",
                                      ifelse(substring(PUD_ZONING,1,1)=='R', "Residential",
                                             "Other")
                                      )
                      )

centroids <- coordinates(puds)
label_data <- data.frame(long=centroids[,1], lat=centroids[,2], PUD_NAME = puds_data$PUD_NAME)

map <- get_map("641 S Street NW, Washington, DC", zoom=12)

# Washington Hospital Center Area
map <- get_map("Washington Hospital Center, DC", zoom=15)
wash_hosp_center <- ggmap(map) + geom_polygon(aes(x=long, y=lat, group=group, fill=ZONING), 
               data=merged_data, color='black', alpha=0.5,
               size=0.5) +
  geom_text(data=label_data, aes(x=long, y=lat, label=PUD_NAME)) +
  theme_bw() +
  theme(legend.position="bottom") +
  ggtitle("Zoning of Planned Unit Developments")

ggsave(filename="wash_hosp_center.png", plot=wash_hosp_center)

# Foggy Bottom
map <- get_map("Foggy Bottom DC", zoom=15)
foggy_bottom <- ggmap(map) + geom_polygon(aes(x=long, y=lat, group=group, fill=ZONING), 
                                              data=merged_data, color='black', alpha=0.5,
                                              size=0.5) +
  geom_text(data=label_data, aes(x=long, y=lat, label=PUD_NAME)) +
  theme_bw() +
  theme(legend.position="bottom") +
  ggtitle("Zoning of Planned Unit Developments")

ggsave(filename="wash_hosp_center.png", plot=wash_hosp_center)
