Let us consider five possible locations of interest: Iho Eleru (a Late Stone Age inland site 
in Nigeria), La Riera (a Mesolithic coastal site on Spain), Chalki (a Mesolithic site on a 
Greek island), Oronsay (a Mesolithic site the Scottish Hebrides), and Atlantis (the fabled submersed city
mentioned by Plato). For each site we have a date that we are interested in associating
with climatic reconstructions.

locations <- data.frame(
  name = c("Iho Eleru","La Riera", "Chalki", "Oronsay","Atlantis"), 
  longitude = c(5,-4, 27, -6, -24), latitude = c(7, 44, 36, 56, 31),
  time_bp = c(-11200, -18738,-10227, -10000, -11600)
)

location_slice(
  x = locations[, c("longitude", "latitude")],
  time_bp = locations$time_bp, bio_variables = c("bio01", "bio12"),
  dataset = "Example", nn_interpol = FALSE
)

location_slice(
  x = locations[, c("longitude", "latitude")],
  time_bp = locations$time_bp, bio_variables = c("bio01", "bio12"),
  dataset = "Example", nn_interpol = TRUE)


locations_ts <- location_series(
  x = locations[, c("longitude", "latitude")],
  bio_variables = c("bio01", "bio12"),
  dataset = "Example")

subset(locations_ts, id == 1)
subset(locations_ts, id == 2)
subset(locations_ts, id == 3)
subset(locations_ts, id == 4)
subset(locations_ts, id == 5)
