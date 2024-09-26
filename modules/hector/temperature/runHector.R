# Complete and format all of the Hector runs!
# 0. Set Up --------------------------------------------
# Load the required R libraries
library(hector)

# Parse out the information that is being passed between python and R
args <- commandArgs(trailingOnly = TRUE)
scn <- args[1]
pfile <- args[2]

# Check script arguments, we need to make sure that the ini file and the params
# we want to run do exist. We want to use the ini files that were created for
# this project.
ini_path <- paste0("./hector-input/hector_", scn, ".ini")
stopifnot(file.exists(ini_path))
stopifnot(file.exists(pfile))

# Import the params to be used here and rename the data frame so that the parameter
# names are recognized by the hector helper functions.
hector_names <- c("simluation", BETA(), Q10_RH(), NPP_FLUX0(), AERO_SCALE(), DIFFUSIVITY(), ECS())
params <- read.csv(pfile)
colnames(params) <- hector_names

# 1. Define Helper Functions ---------------------------------------------------
# Helper function to run Hector with a set of parameter values, this is designed
# to be used to apply to a large dataframe of different Hector parameter values
# to explore. And a helper function can be useful to ti
# Args
#   hc: active hector core object
#   pars: single row of a data frame containing the Hector parameter values
# Returns: list of hector output
runhector <- function(hc, pars){

    years <- 1750:2500

    tryCatch({
        # Not the best way to do this but will do for now
        setvar(hc, dates = NA, var = BETA(), values = pars[[BETA()]], unit = getunits(BETA()))
        setvar(hc, dates = NA, var = Q10_RH(), values = pars[[Q10_RH()]], unit = getunits(Q10_RH()))
        setvar(hc, dates = NA, var = NPP_FLUX0(), values = pars[[NPP_FLUX0()]], unit = getunits(NPP_FLUX0()))
        setvar(hc, dates = NA, var = AERO_SCALE(), values = pars[[AERO_SCALE()]], unit = getunits(AERO_SCALE()))
        setvar(hc, dates = NA, var = DIFFUSIVITY(), values = pars[[DIFFUSIVITY()]], unit = getunits(DIFFUSIVITY()))
        setvar(hc, dates = NA, var = ECS(), values = pars[[ECS()]], unit = getunits(ECS()))
        reset(hc)

        # TODO set up ini and emissions tables that extend all the way to 2500 so we can
        # have Hector results to 2500 without doing the padding with NAs.
        run(hc, runtodate = max(years))

        gsat <- fetchvars(hc, years, GLOBAL_TAS())[['value']]
        heatflux <- fetchvars(hc, years, HEAT_FLUX())[['value']]
        interior_heatflux <- fetchvars(hc, years, FLUX_INTERIOR())[['value']]


        # Convert from heat flux to ocean heat content
        OCEAN_AREA <- 3.6e14 # The total area of the ocean
        UNITS <- 60.0 * 60.0 * 24.0 * 365.2422  # Seconds per year
        ohc <-  cumsum(heatflux) * OCEAN_AREA * UNITS

        return(list(gsat = gsat, ohc = ohc))
    }, error = function(e){


        gsat <- ohc <-  deeptemps <- rep(NA, length.out = length(years))

        return(list(gsat = gsat, ohc = ohc))

    })


}

# Helper function that formats the nested list returned by applying runhector to
# a parameter dataframe into a nice matrix for each variable.
# Args
#   outlist: nested list created by applying runhector to a parameter dataframe
#   var: str name of the hector variable to extract from the netcdf list
# Returns: matrix of results years x simulation for a single variable
format_runhector <- function(outlist, var){
    do.call('cbind', lapply(outlist, function(x){
        return(x[[var]])
    })) ->
        out
    return(out)
}


# 2. Complete Hector Runs -----------------------------------------------------
# Initialize the Hector core
hc <- newcore(ini_path)

# Run Hector with all the different parameter values.
hector_results <- apply(params, 1, runhector, hc = hc)

# Format and save results
# TODO we might want to clean up this intermediate files that are being used to
# pass information between R and Python.
write.csv(x = format_runhector(hector_results, "gsat"), file = "hector_gsat.csv", row.names = FALSE)
write.csv(x = format_runhector(hector_results, "ohc"), file = "hector_ohc.csv", row.names = FALSE)
