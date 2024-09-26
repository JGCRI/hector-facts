import os
import sys
import xarray as xr
import pandas as pd
import numpy as np
import argparse
import pickle
from datetime import datetime
import subprocess


# Function that generates a samples form Hector model with specified emissions scenarios and
# the data frame of all the parameter values that used be used to drive the Hector runs.
def my_run_hector(scn, pfile):

	hector_script = "runHector.R"

	if (os.path.exists(hector_script) == False):
		raise ValueError("Hector R script not found!")

	rslt = subprocess.run(['Rscript', hector_script, scn, pfile], capture_output=True, text=True)

	# Check for errors
	if rslt.returncode != 0:
		print("R script failed with the following error:")
		print(rslt.stderr)

	return(None)


# Function that centers and smooths a set of temperature trajectories
def CenterSmooth(temp, years, cyear_start, cyear_end, smooth_win):

	# Which years fall into the range of years for centering?
	ref_idx = np.flatnonzero(np.logical_and(years >= cyear_start, years <= cyear_end))

	# Take the mean over the centering range for each sample and subtract
	ref_temp = np.nanmean(temp[:,ref_idx], axis=1)
	center_temp = temp - ref_temp[:,np.newaxis]

	# Smooth the centered temperatures
	if smooth_win > 1:
		csmooth_temp = np.apply_along_axis(Smooth, axis=1, arr=center_temp, w=smooth_win)
	else:
		csmooth_temp = center_temp

	# Return the centered and smoothed temperature trajectories
	return(csmooth_temp)


# Function that smooths data in similar fashion to Matlab's "smooth" function
def Smooth(x, w=5):
	out0 = np.convolve(x, np.ones(w,dtype='double'), 'valid')/w
	r = np.arange(1,w-1,2, dtype="double")
	start = np.cumsum(x[:w-1])[::2]/r
	stop = (np.cumsum(x[:-w:-1])[::2]/r)[::-1]
	y = np.concatenate((start, out0, stop))
	return(y)



def hector_project_temperature(nsamps, seed, cyear_start, cyear_end, smooth_win, pipeline_id):

	# Load the preprocessed data
	preprocess_file = "{}_preprocess.pkl".format(pipeline_id)
	with open(preprocess_file, 'rb') as f:
		preprocess_data = pickle.load(f)

	REFERENCE_YEAR = preprocess_data["REFERENCE_YEAR"]
	scenario = preprocess_data["scenario"]
	# TODO add rcmip file information if/when we swtich to using the rcmip files
	rcmip_file = None

	# Load the fit data
	fit_file = "{}_fit.pkl".format(pipeline_id)
	with open(fit_file, 'rb') as f:
		fit_data = pickle.load(f)

	pars = fit_data["pars"]
	param_file = fit_data["param_file"]

	# Projection years
	proj_years = np.arange(REFERENCE_YEAR, 2501)

	# TODO automate this instead of hard coding this
	hector_version = "V3.2.0"

	# How many parameter sets do we have? And how
	# to handel to generate the nsamps?
	nsims = len(pars)
	rng = np.random.default_rng(seed)

	if nsamps > nsims:
		run_idx = np.arange(nsims)
		sample_idx = rng.choice(nsims, nsamps, nsamps>nsims)
	else:
		run_idx = rng.choice(nsims, nsamps, nsamps>nsims)
		sample_idx = np.arange(nsamps)

	# Save parameter combinations want to use in Hector
	# then run Hector
	pars_to_run = pars.iloc[run_idx].reset_index(drop=True)
	pfile = 'pars_to_use.csv'
	pars_to_run.to_csv(pfile, index=False)
	my_run_hector(scenario, pfile)

	# Load the Hector results and format for the CenterSmooth function
	temps = np.transpose(np.array(pd.read_csv('hector_gsat.csv')))
	ohcs =  np.transpose(np.array(pd.read_csv('hector_ohc.csv')))

	# Center and smooth the samples
	temps = CenterSmooth(temps, proj_years, cyear_start=cyear_start, cyear_end=cyear_end, smooth_win=smooth_win)
    # TODO there is some issue with the CenterSmooth function and the ocean heat content data
	#ohcs = CenterSmooth(ohcs, proj_years, cyear_start=cyear_start, cyear_end=cyear_end, smooth_win=smooth_win)

	# Conform the output to shapes appropriate for output
	temps = temps[sample_idx,:,np.newaxis]
	ohcs = ohcs[sample_idx,:,np.newaxis]

	# Set up the global attributes for the output netcdf files
	attrs = {"Source": "FACTS",
			 "Date Created": str(datetime.now()),
			 "Description": (
				 f"Hector v={hector_version} scenario simulations."
			 " Simulations based on parameters developed here: https://github.com/JGCRI/hector-facts-support."
			 " Parameters obtained from: https://zenodo.org/records/13774542."),
			"Method": (
				"Temperature and ocean heat content were returned from Hector in emission-driven mode."),
			"Scenario emissions file": "default Hector SSPX inputs",
			"Hector Parameters file": param_file,
			"Hector version": hector_version,
			 "Scenario": scenario,
			 "Centered": "{}-{} mean".format(cyear_start, cyear_end),
			 "Smoothing window": "{} years".format(smooth_win),
			 "Note": "Code adapted for Hector by K. Dorheim and C. Donegan based on https://zenodo.org/records/10403331"
			}

	# Create the variable datasets
	tempds = xr.Dataset({"surface_temperature": (("samples", "years", "locations"), temps, {"units":"degC"}),
							"lat": (("locations"), [np.inf]),
							"lon": (("locations"), [np.inf])},
		coords={"years": proj_years, "locations": [-1], "samples": np.arange(nsamps)}, attrs=attrs)

	ohcds = xr.Dataset({"ocean_heat_content": (("samples", "years", "locations"), ohcs, {"units":"J"}),
							"lat": (("locations"), [np.inf]),
							"lon": (("locations"), [np.inf])},
		coords={"years": proj_years, "locations": [-1], "samples": np.arange(nsamps)}, attrs=attrs)

	# Write the datasets to netCDF
	tempds.to_netcdf("{}_gsat.nc".format(pipeline_id), encoding={"surface_temperature": {"dtype": "float32", "zlib": True, "complevel":4}})
	ohcds.to_netcdf("{}_ohc.nc".format(pipeline_id), encoding={"ocean_heat_content": {"dtype": "float32", "zlib": True, "complevel":4}})

	# create a single netCDF file that is compatible with modules expecting parameters organized in a certain fashion
	pooledds = xr.Dataset({"surface_temperature": (("years","samples"), temps[::,::,0].transpose(), {"units":"degC"}),
							"ocean_heat_content": (("years","samples"), ohcs[::,::,0].transpose(), {"units":"J"})},
		coords={"years": proj_years, "samples": np.arange(nsamps)}, attrs=attrs)
	pooledds.to_netcdf("{}_climate.nc".format(pipeline_id), group=scenario,encoding={"ocean_heat_content": {"dtype": "float32", "zlib": True, "complevel":4},
		"surface_temperature": {"dtype": "float32", "zlib": True, "complevel":4}})
	yearsds = xr.Dataset({"year": proj_years})
	yearsds.to_netcdf("{}_climate.nc".format(pipeline_id), mode='a')

	# Done
	return(None)


if __name__ == "__main__":

	# Initialize the command-line argument parser
	parser = argparse.ArgumentParser(description="Run the project stage for the FAIR AR6 temperature module",\
	epilog="Note: This is meant to be run as part of the Framework for the Assessment of Changes To Sea-level (FACTS)")

	# Define the command line arguments to be expected
	parser.add_argument('--pipeline_id', help="Unique identifier for this instance of the module", required=True)
	parser.add_argument('--nsamps', help="Number of samples to create (uses replacement if nsamps > n parameters) (default=10)", type=int, default=10)
	parser.add_argument('--seed', help="Seed value for random number generator (default=1234)", type=int, default=1234)
	parser.add_argument('--cyear_start', help="Start year of temporal range for centering (default=1850)", type=int, default=1850)
	parser.add_argument('--cyear_end', help="End year of temporal range for centering (default=1900)", type=int, default=1900)
	parser.add_argument('--smooth_win', help="Number of years to use as a smoothing window (default=19)", type=int, default=19)

	# Parse the arguments
	args = parser.parse_args()

	# Run the code
	hector_project_temperature(nsamps=args.nsamps, seed=args.seed, cyear_start=args.cyear_start, cyear_end=args.cyear_end, smooth_win=args.smooth_win, pipeline_id=args.pipeline_id)


	sys.exit()
