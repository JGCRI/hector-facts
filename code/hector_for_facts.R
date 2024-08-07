# Hector run for FACTS sea level rise experiment

library(hector)
library(dplyr)
library(ncdf4)
library(ggplot2)
library(tidyverse)

# set path to netCDF file
file_dir <- "C:/Users/done231/OneDrive - PNNL/Desktop/SLR_output"
setwd(file_dir)

# SSP 585, default scenario for this FACTS run (can select a different one)
ini_file <- system.file("input/hector_ssp585.ini",package='hector')
core <- newcore(ini_file)
run(core)

h_heatflux <- fetchvars(core,1750:2300,vars=list(HEAT_FLUX()))
h_gmst <- fetchvars(core,1750:2300,vars=list(GMST()))
h_tas <- fetchvars(core,1750:2300,vars=list(GLOBAL_TAS()))

# W/m^2 * (SA of ocean in m^2) * (seconds in a year) = J
h_ohc <- h_heatflux
h_ohc$value <- h_ohc$value*5.10065e14*(0.71)*31556930 # times total area of ocean and seconds per year (365.2425 days). units J
h_ohc$variable <- "ohc"
h_ohc$units <- "J"

# Extend Hector data out to 2500 -- only 2050-2150 used for experiment, so value doesn't matter (will matter if we want to run an experiment with later dates though)
h_ohc_val <- h_ohc$value
h_gmst_val <- h_gmst$value
h_tas_val <- h_tas$value
nas <- rep(NA,200)

h_ohc_ext <- c(h_ohc_val,nas)
h_ohc_ext <- cumsum(h_ohc_ext)
h_gmst_ext <- c(h_gmst_val,nas)
#h_tas_ext <- c(h_tas_val,nas)

# Single sample FaIR run -- replace gmst and ohc, leaving oceantemp from FaIR (not a Hector)
# nc_onesamp <- nc_open("onesamp_climate.nc",write=TRUE)
# #f_gmst <- ncvar_get(nc_onesamp,"ssp585/surface_temperature")
# #f_ohc <- ncvar_get(nc_onesamp,"ssp585/ocean_heat_content")
# #f_oceantemp <- ncvar_get(nc_onesamp,"ssp585/deep_ocean_temperature")
# #years <- ncvar_get(nc_onesamp,"ssp585/years")
# ncvar_put(nc_onesamp,"ssp585/surface_temperature",h_gmst_ext)
# ncvar_put(nc_onesamp,"ssp585/ocean_heat_content",h_ohc_ext)
# nc_close(nc_onesamp)

# Single sample FaIR run (unedited)
# nc_onesamp <- nc_open("onesamp_climate - backup.nc")
# f_gmst <- ncvar_get(nc_onesamp,"ssp585/surface_temperature")
# f_ohc <- ncvar_get(nc_onesamp,"ssp585/ocean_heat_content")
# f_oceantemp <- ncvar_get(nc_onesamp,"ssp585/deep_ocean_temperature")
# years <- ncvar_get(nc_onesamp,"ssp585/years")
# nc_close(nc_onesamp)
# 
# # Compare Hector and FaIR
# gmst_diff <- f_gmst-h_gmst_ext
# gmst_diff <- gmst_diff[!is.na(gmst_diff)]
# ohc_diff <- f_ohc-h_ohc_ext
# ohc_diff <- ohc_diff[!is.na(ohc_diff)]
# 
# mean(gmst_diff)
# mean(ohc_diff)
# 
# Load in tlm.hector ncdf output
nc_hector <- nc_open("hector_output_8-6.nc")
h_output <- ncvar_get(nc_hector,"sea_level_change")
years <- ncvar_get(nc_hector,"years")
nc_close(nc_hector)

# Plot tlm.hector output
h_slr_plot <- ggplot() +
  geom_line(aes(x=years,y=h_output)) +
  labs(title = "FACTS experiment with Hector input",
       x = "Year",
       y = "Sea Level Change (mm)") +
  theme_minimal()


# # let's try with RF_total instead of heat flux...
# h_rf <- fetchvars(core,1750:2300,vars=list(RF_TOTAL()))
# h_rf$value <- h_rf$value*5.10065e14*(0.71)*31556930 # times total area of ocean and seconds per year (365.2425 days). units J
# h_rf$variable <- "rf_integral"
# h_rf$units <- "J"
# h_rf_val <- h_rf$value
# 
# # maybe SST is more correct than GMST?
# h_sst <- fetchvars(core,1750:2300,vars=SST())
# h_sst_val <- h_sst$value
# h_sst_ext <- c(h_sst_val,nas)
# 
# # entire surface of earth??
# tot_earth_ohc <- h_ohc_val/0.71
# # doesn't work out of course because we're still a few orders of magnitude off...
# 
# 
# # Try cumsum of hector ohc
# h_ohc_sum <- cumsum(h_ohc_ext)
# # Compare sum w/ FaIR values
# baseyears <- 1750:2500
# ohc_comparison <- ggplot() +
#   geom_line(aes(x=baseyears,y=h_ohc_sum,color="blue")) +
#   geom_line(aes(x=baseyears,y=f_ohc,color="red"))
# 
# # compare temp vars
# temp_comparison <- ggplot() +
#   geom_line(aes(x=baseyears,y=h_gmst_ext,color="Hector GMST")) +
#   geom_line(aes(x=baseyears,y=h_tas_ext,color="Hector TAS")) +
#   geom_line(aes(x=baseyears,y=f_gmst,color="FaIR Sfc Temp")) +
#   scale_color_manual("",
#                      values = c("Hector GMST" = "blue",
#                                 "Hector TAS" = "green",
#                                 "FaIR Sfc Temp" = "red")) + 
#   labs(title = "Temperature Variable Comparison",
#        x = "Year",
#        y = "Temperature (degC)")
# 
# 
# # Plot hector OHC within fair OHC samples -- run plot_slr_output.R first
# # Get values in dataframe format to work with ggplot
# colnames(ohc) <- samples
# ohc_df <- as.data.frame(ohc)
# ohc_df$year <- baseyears
# 
# ohc_long <- ohc_df %>%
#   pivot_longer(
#     cols = -year,
#     names_to = "sample",
#     values_to = "ohc"
#   )
# 
# # Get average SLR value
# ohc_avg <- ohc_long %>%
#   group_by(year) %>%
#   summarize(avg = mean(ohc))
# 
# # Plot data
# ohc_plot <- ggplot() +
#   geom_line(data = ohc_long, aes(x=year,y=ohc,group=sample,color="FaIR Samples"),alpha=0.5) +
#   geom_line(data = ohc_avg, aes(x=year,y=avg,color="FaIR Mean"),linewidth=1) +
#   geom_line(aes(x=baseyears,y=h_ohc_sum,color="Hector"),linewidth=1) +
#   scale_color_manual("",
#                      values = c("FaIR Samples"="gray",
#                                 "FaIR Mean"="blue",
#                                 "Hector"="red")) +
#   labs(title = "OHC: FaIR vs Hector",
#        x = "Year",
#        y = "Ocean Heat Content (J)") +
#   theme_minimal()
