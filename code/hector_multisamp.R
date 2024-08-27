# Hector run with multiple samples
library(hector)
library(dplyr)
library(ncdf4)
library(ggplot2)
library(tidyverse)

# set path to netCDF file
file_dir <- "C:/Users/done231/OneDrive - PNNL/Desktop/SLR_output"
setwd(file_dir)

# Default SSP585
ini_file <- system.file("input/hector_ssp585.ini",package='hector')
core <- newcore(ini_file)
run(core)

default_heatflux <- fetchvars(core,1750:2300,vars=list(HEAT_FLUX()))
default_gmst <- fetchvars(core,1750:2300,vars=list(GMST()))

# W/m^2 * (SA of ocean in m^2) * (seconds in a year) = J
default_ohc <- default_heatflux
default_ohc$value <- default_ohc$value*5.10065e14*(0.71)*31556930 # times total area of ocean and seconds per year (365.2425 days). units J
default_ohc$value <- cumsum(default_ohc$value)
default_ohc$variable <- "ohc"
default_ohc$units <- "J"

# Extend Hector data out to 2500 -- only 2050-2150 used for experiment, so value doesn't matter (will matter if we want to run an experiment with later dates though)
default_ohc_val <- default_ohc$value
default_gmst_val <- default_gmst$value
nas <- rep(NA,200)

default_ohc_ext <- c(default_ohc_val,nas)
default_gmst_ext <- c(default_gmst_val,nas)

## High run (parameters adjusted to get high temperature rise)
core <- newcore(ini_file)

# Set parameters
setvar(core,NA,AERO_SCALE(),0.01,"(unitless)")
setvar(core,NA,BETA(),0.01,"(unitless)")
setvar(core,NA,DIFFUSIVITY(),1,"cm2/s")
setvar(core,NA,ECS(),6,"degC")
setvar(core,NA,Q10_RH(),5,"(unitless)")
setvar(core,NA,VOLCANIC_SCALE(),1,"(unitless)")

reset(core)
run(core)

high_heatflux <- fetchvars(core,1750:2300,vars=list(HEAT_FLUX()))
high_gmst <- fetchvars(core,1750:2300,vars=list(GMST()))

# W/m^2 * (SA of ocean in m^2) * (seconds in a year) = J
high_ohc <- high_heatflux
high_ohc$value <- high_ohc$value*5.10065e14*(0.71)*31556930 # times total area of ocean and seconds per year (365.2425 days). units J
high_ohc$value <- cumsum(high_ohc$value)
high_ohc$variable <- "ohc"
high_ohc$units <- "J"

# Extend Hector data out to 2500 -- only 2050-2150 used for experiment, so value doesn't matter (will matter if we want to run an experiment with later dates though)
high_ohc_val <- high_ohc$value
high_gmst_val <- high_gmst$value
nas <- rep(NA,200)

high_ohc_ext <- c(high_ohc_val,nas)
high_gmst_ext <- c(high_gmst_val,nas)

## Low run (parameters adjusted to get low temperature rise)
core <- newcore(ini_file)

# Set parameters
setvar(core,NA,AERO_SCALE(),1,"(unitless)")
setvar(core,NA,BETA(),4,"(unitless)")
setvar(core,NA,DIFFUSIVITY(),5,"cm2/s")
setvar(core,NA,ECS(),1,"degC")
setvar(core,NA,Q10_RH(),1,"(unitless)")
setvar(core,NA,VOLCANIC_SCALE(),0,"(unitless)")

reset(core)
run(core)

low_heatflux <- fetchvars(core,1750:2300,vars=list(HEAT_FLUX()))
low_gmst <- fetchvars(core,1750:2300,vars=list(GMST()))

# W/m^2 * (SA of ocean in m^2) * (seconds in a year) = J
low_ohc <- low_heatflux
low_ohc$value <- low_ohc$value*5.10065e14*(0.71)*31556930 # times total area of ocean and seconds per year (365.2425 days). units J
low_ohc$value <- cumsum(low_ohc$value)
low_ohc$variable <- "ohc"
low_ohc$units <- "J"

# Extend Hector data out to 2500 -- only 2050-2150 used for experiment, so value doesn't matter (will matter if we want to run an experiment with later dates though)
low_ohc_val <- low_ohc$value
low_gmst_val <- low_gmst$value
nas <- rep(NA,200)

low_ohc_ext <- c(low_ohc_val,nas)
low_gmst_ext <- c(low_gmst_val,nas)

# Three sample FaIR run -- replace gmst and ohc, leaving oceantemp from FaIR (not a Hector)
nc_threesamp <- nc_open("threesamp.nc",write=TRUE)
f_gmst <- ncvar_get(nc_threesamp,"ssp585/surface_temperature")
f_ohc <- ncvar_get(nc_threesamp,"ssp585/ocean_heat_content")

# Replace ohc
f_ohc[1,] <- default_ohc_ext
f_ohc[2,] <- high_ohc_ext
f_ohc[3,] <- low_ohc_ext

# Replace gmst
f_gmst[1,] <- default_gmst_ext
f_gmst[2,] <- high_gmst_ext
f_gmst[3,] <- low_gmst_ext

# Replace values in ncdf
ncvar_put(nc_threesamp,"ssp585/surface_temperature",f_gmst)
ncvar_put(nc_threesamp,"ssp585/ocean_heat_content",f_ohc)
nc_close(nc_threesamp)

# Three sample run with hector
nc_hthreesamp <- nc_open("tlm.hthreesamp.ocean.tlm.sterodynamics_globalsl.nc")
h3_slr <- ncvar_get(nc_hthreesamp,"sea_level_change")
samples <- ncvar_get(nc_hthreesamp,"samples")
years <- ncvar_get(nc_hthreesamp,"years")
nc_close(nc_hthreesamp)

# Plot
# Get values in dataframe format to work with ggplot
colnames(h3_slr) <- samples
h3_df <- as.data.frame(h3_slr)
h3_df$year <- years

h3_long <- h3_df %>%
  pivot_longer(
    cols = -year,
    names_to = "sample",
    values_to = "sea_level_change"
  )

# Plot data
h3_plot <- ggplot() +
  geom_line(data = slr_long, aes(x=year,y=sea_level_change,group=sample),color="gray",alpha=0.5) +
  geom_line(data = h3_long, aes(x=year,y=sea_level_change,group=sample),color="blue") +
  
  #geom_line(data = slr_avg, aes(x=year,y=avg),color="blue",linewidth=1) +
  #geom_line(aes(x=years,y=h_output),color="red",linewidth=1) +
  labs(title = "Hector - Three Sample Run",
       x = "Year",
       y = "Sea Level Change (mm)") +
  theme_minimal()
