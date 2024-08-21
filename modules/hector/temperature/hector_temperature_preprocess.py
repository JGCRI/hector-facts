import os
import sys
import argparse
import pickle
import numpy as np
import pandas as pd



def hector_preprocess_temperature(scenario, rcmip_file, pipeline_id):

	# TODO - delete the arguments and stuff
	# TODO this might be a one day thing if it turns out we need to do the rcmip conversions our selves...
	# open an issue about this??? idk if necessary this only needs to be added


	sys.stdout.write("Hello, World my preprocessing!\n")
	return(None)


if __name__ == "__main__":

	# Initialize the command-line argument parser
	parser = argparse.ArgumentParser(description="Run the preprocessing stage for the FAIR AR6 temperature module",\
	epilog="Note: This is meant to be run as part of the Framework for the Assessment of Changes To Sea-level (FACTS)")

	# Define the command line arguments to be expected
	parser.add_argument('--pipeline_id', help="Unique identifier for this instance of the module", required=True)
	parser.add_argument('--rcmip_file', help="Full path to RCMIP emissions file", default="./rcmip/rcmip-emissions-annual-means-v5-1-0.csv")
	parser.add_argument('--scenario', help="SSP Emissions scenario",  default="ssp585")

	# Parse the arguments
	args = parser.parse_args()

	# Run the code
	hector_preprocess_temperature(scenario=args.scenario, rcmip_file=args.rcmip_file, pipeline_id=args.pipeline_id)


	sys.exit()
