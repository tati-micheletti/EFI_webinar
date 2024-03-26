## Simulating Data ##
 
if(!require("Require")){
  install.packages("Require")
}
library("Require")
Require("SpaDES")
Require("terra")
Require("data.table")
Require("ropensci/NLMR")
Require("ggplot2")

times <- 10
# FOR ABUNDANCE: Use a gauss map to simulate abundance
abund <- rbindlist(lapply(seq(times), function(t){
  ras <- rast(nrows = 100, ncols = 100, xmin = -50, xmax = 50, ymin = -50,
              ymax = 50)
  rasGauss <- NLMR::nlm_mpd(ncol = ncol(ras),
                            nrow = nrow(ras), resolution = unique(res(ras)),
                            roughness = 0.6, rand_dev = 100, rescale = TRUE,
                            verbose = FALSE)
  valsGauss <- as.numeric(values(rasGauss))
  valsCounts <- round(valsGauss*(100+(t*5)), 0) 
  ras <- rast(nrows = 99, ncols = 99, 
              xmin = -50, xmax = 49, 
              ymin = -50,
              ymax = 49)
  ras[] <- valsCounts
  rasP <- as.points(ras)
  dt <- extract(ras, rasP, xy=TRUE)
  return(data.table(abundance = dt$lyr.1,
                    years = 2012+t,
                    lat = dt$y,
                    long = dt$x))
}))

# FOR TEMPERATURE: Use the numbers from abundance with a slight deviation
tempt <- rbindlist(lapply(sort(c(unique(abund$years), 
                                 (max(unique(abund$years))+1):(max(unique(abund$years))+10))), 
                          function(Year){
                            # Get the abundance data for that year and coordinates
                            subAbund <- abund[years == Year, ]
                            if (nrow(subAbund) == 0){
                              subAbund <- abund[years == max(abund$years), ]
                            }
                            if (Year < mean(abund$years)){
                              valsT <- jitter((sqrt(subAbund$abundance))+15, 
                                              factor = 5, amount = NULL)
                            } else {
                              if (Year < max(abund$years)){
                                valsT <- jitter((sqrt(abs(subAbund$abundance-(max(subAbund$abundance)+1))))+17, 
                                                factor = 5, amount = NULL)
                              } else {
                                valsT <- jitter((sqrt(abs(subAbund$abundance-(max(subAbund$abundance)+1))))+17+(Year-max(abund$years)), 
                                                factor = 5, amount = NULL)
                                subAbund[, years := Year]
                              }
                            }
                            subAbund[, temperature := valsT]
                            return(subAbund[, c("temperature", "years", "lat", "long")])
                          }))
# Save datasets
write.csv(abund, "abundanceData.csv")
write.csv(tempt, "temperature.csv")

# Upload both datasets to Zenodo.