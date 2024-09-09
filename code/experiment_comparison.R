# Comparing FACTS experiment outputs

library(ncdf4)
library(tidyverse)

# Set working directory to output folder
setwd("C:/Users/done231/hector-facts/outputs")

# Load in output netcdfs
# These experiments can have many different outputs, so we're going to pick the global SL ones

# fittedismip.ssp585
nc_fittedismip.ssp585 <- nc_open("fittedismip.ssp585/fittedismip.ssp585.GrIS1f.FittedISMIP.GrIS_GIS_globalsl.nc")
fittedismip.ssp585.slc <- ncvar_get(nc_fittedismip.ssp585,"sea_level_change")
fittedismip.ssp585.year <- ncvar_get(nc_fittedismip.ssp585,"years")
fittedismip.ssp585.sample <- ncvar_get(nc_fittedismip.ssp585,"samples")
nc_close(nc_fittedismip.ssp585)

# ar5k14.rcp85 - 2000 samples
nc_ar5k14.thermalexpansion <- nc_open("ar5k14.rcp85/ar5k14.rcp85.ar5TE.ipccar5.thermalexpansion_globalsl.nc")
ar5k14.thermalexpansion.slc <- ncvar_get(nc_ar5k14.thermalexpansion,"sea_level_change")
ar5k14.thermalexpansion.year <- ncvar_get(nc_ar5k14.thermalexpansion,"year")
ar5k14.thermalexpansion.sample <- ncvar_get(nc_ar5k14.thermalexpansion,"sample")
nc_close(nc_ar5k14.thermalexpansion)

# bamber19.ssp585
nc_bamber19.ssp585.AIS <- nc_open("bamber19.ssp585/bamber19.ssp585.bamber19.bamber19.icesheets_AIS_globalsl.nc")
bamber19.ssp585.AIS.slc <- ncvar_get(nc_bamber19.ssp585.AIS,"sea_level_change")
bamber19.ssp585.AIS.year <- ncvar_get(nc_bamber19.ssp585.AIS,"years")
bamber19.ssp585.AIS.sample <- ncvar_get(nc_bamber19.ssp585.AIS,"samples")
nc_close(nc_bamber19.ssp585.AIS)

# Get values in tibble format to work with ggplot
df_long <- function(slc,year,sample) {
  colnames(slc) <- sample
  slc_df <- as.data.frame(slc)
  slc_df$year <- year
  
  slc_long <- slc_df %>%
    pivot_longer(
      cols = -year,
      names_to = "sample",
      values_to = "sea_level_change"
    )
  return(slc_long)
}

# Get data tibbles
fittedismip.ssp585.long <- df_long(fittedismip.ssp585.slc,fittedismip.ssp585.year,fittedismip.ssp585.sample)
ar5k14.thermalexpansion.long <- df_long(ar5k14.thermalexpansion.slc,ar5k14.thermalexpansion.year,ar5k14.thermalexpansion.sample)
bamber19.ssp585.long <- df_long(bamber19.ssp585.AIS.slc,bamber19.ssp585.AIS.year,bamber19.ssp585.AIS.sample)

# Plot experiment outputs
fittedismip.ssp585.plot <- ggplot() +
  geom_line(data = fittedismip.ssp585.long, aes(x=year,y=sea_level_change,group=sample),color="black",alpha=0.2) +
  labs(title = "fittedismip.ssp585 - GrIS_GIS output",
       x = "Year",
       y = "Sea Level Change (mm)") +
  theme_minimal()

ar5k14.thermalexpansion.plot <- ggplot() +
  geom_line(data = ar5k14.thermalexpansion.long, aes(x=year,y=sea_level_change,group=sample),color="black",alpha=0.1) +
  labs(title = "ar5k14.rcp85 experiment - thermalexpansion output",
       x = "Year",
       y = "Sea Level Change (mm)") +
  theme_minimal()

bamber19.ssp585.plot <- ggplot() +
  geom_line(data = bamber19.ssp585.long, aes(x=year,y=sea_level_change,group=sample),color="black",alpha=0.2) +
  labs(title = "bamber19.ssp585 experiment - AIS output",
       x = "Year",
       y = "Sea Level Change (mm)") +
  theme_minimal()
