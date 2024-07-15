# Plot output of offline tlm (two-layer model) SLR experiment

library(ncdf4)
library(ggplot2)
library(tidyverse)

# set path to netCDF file
file_dir <- "C:/Users/done231/OneDrive - PNNL/Desktop/SLR_output"
setwd(file_dir)

# Get variables from ncdf file
nc_offline <- nc_open("offline_output.nc")

sea_level_change <- ncvar_get(nc_offline,"sea_level_change")
samples <- ncvar_get(nc_offline,"samples")
years <- ncvar_get(nc_offline,"years")

nc_close(nc_offline)

# Get values in dataframe format to work with ggplot
colnames(sea_level_change) <- samples
slr_df <- as.data.frame(sea_level_change)
slr_df$year <- years

slr_long <- slr_df %>%
  pivot_longer(
    cols = -year,
    names_to = "sample",
    values_to = "sea_level_change"
  )

# Get average SLR value
slr_avg <- slr_long %>%
  group_by(year) %>%
  summarize(avg = mean(sea_level_change))

# Plot data
slr_plot <- ggplot() +
  geom_line(data = slr_long, aes(x=year,y=sea_level_change,group=sample),color="gray",alpha=0.5) +
  geom_line(data = slr_avg, aes(x=year,y=avg),color="blue",linewidth=1) +
  labs(title = "FACTS Offline Experiment",
       x = "Year",
       y = "Sea Level Change (mm)") +
  theme_minimal()

# Histogram of values in year 2100
slr_2100 <- filter(slr_long,year==2100)
slr_hist <- ggplot(slr_2100,aes(x=sea_level_change)) +
  geom_histogram(color="black",fill="steelblue") +
  labs(title = "FACTS Offline Experiment: Year 2100",
       x = "Sea Level Rise (mm)",
       y = "Samples") +
  theme_minimal()
