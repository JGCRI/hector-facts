# Complete and format all of the Hector runs!
# 0. Set Up --------------------------------------------
# Load the required R libraries
library(hector)

# Parse out the information that is being passed between python and R
args <- commandArgs(trailingOnly = TRUE)
scn <- args[1]
pfile <- args[2]

#scn <- "ssp585"
#pfile <- "~/Documents/2024/Hector-SLR/hector-facts/modules-data/hector_params.csv"
# Check script arguments, we need to make sure that the ini file and the params
# we want to run do exist.
ini_path <- system.file(paste0("input/hector_", scn, ".ini"), package = "hector")
message(ini_path)
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
    run(hc, runtodate = 2300)

    years <- 1750:2300
    nas <- rep(NA, 200)

    gmst <- c(fetchvars(hc, years, GMST())[['value']], nas)
    heatflux <- c(fetchvars(hc, years, HEAT_FLUX())[['value']], nas)
    #gmst <- fetchvars(hc, years, GMST())[['value']]
    #heatflux <- fetchvars(hc, years, HEAT_FLUX())[['value']]

    # Convert from heat flux to ocean heat content
    OCEAN_AREA <- 5100656e8 * (1 - 0.29) # The total area of the ocean
    W_TO_ZJ <- 3.155693e-14              # Watts to ZJ
    ohc <- cumsum(heatflux * OCEAN_AREA * W_TO_ZJ)

    return(list(gmst = gmst, heatflux = heatflux))

}

# Helper function that formats the nested list returned by applying runhector to
# a parameter dataframe into a nice matrix for each variable.
# Args
#   outlist: nested list created by applying runhector to a parameter dataframe
#   var: str name of the hector variable to extract from the nexted list
# Returns: matrix of results years x simluation for a single variable
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

# Format the outputs
gmst <- data.frame(format_runhector(hector_results, "gmst"))
ohc <- data.frame(format_runhector(hector_results, "heatflux"))

# Format and save results
# TODO we might want to clean up this intermediate files that are being used to
# pass information between R and Python.
write.csv(x = format_runhector(hector_results, "gmst"), file = "hector_gmst.csv", row.names = FALSE)
write.csv(x = format_runhector(hector_results, "heatflux"), file = "hector_heatflux.csv", row.names = FALSE)
