import os
import sys
import argparse
import pickle
import pandas as pd
import xarray as xr


def hector_fit_temperature(param_file, pipeline_id):

	# Read in the parameter values for Hector
	pars = pd.read_csv('./hector_params.csv')
	output = {"pars": pars, "param_file": param_file}
	outfile = open(os.path.join(os.path.dirname(__file__), "{}_fit.pkl".format(pipeline_id)), 'wb')
	pickle.dump(output, outfile, protocol=-1)
	outfile.close()

	return(None)


if __name__ == "__main__":

	# Initialize the command-line argument parser
	parser = argparse.ArgumentParser(description="Run the fit stage for the FAIR AR6 temperature module",\
	epilog="Note: This is meant to be run as part of the Framework for the Assessment of Changes To Sea-level (FACTS)")

	# Define the command line arguments to be expected
	parser.add_argument('--pipeline_id', help="Unique identifier for this instance of the module", required=True)
	parser.add_argument('--param_file', help="Full path to Hector parameter file", default="./hector_params.tgz")

	# Parse the arguments
	args = parser.parse_args()

	# Run the code
	hector_fit_temperature(param_file=args.param_file, pipeline_id=args.pipeline_id)


	sys.exit()
