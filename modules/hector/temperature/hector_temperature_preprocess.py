import os
import sys
import argparse
import pickle
import numpy as np
import pandas as pd



def hector_preprocess_temperature(scenario, rcmip_file, pipeline_id):

	# TODO - delete the rcmip file argument or add the Hector rcmip conversions
	# TODO - change emis from none to actual emissions information?
	sys.stdout.write("Hello, World KD's preprocessing!\n")

	# Definitions
	REFERENCE_YEAR = 1750

	# Save the preprocessed data to a pickle
	output = {"emis": None, "REFERENCE_YEAR": REFERENCE_YEAR, "scenario": scenario, "rcmip_file": rcmip_file}
	outfile = open(os.path.join(os.path.dirname(__file__), "{}_preprocess.pkl".format(pipeline_id)), 'wb')
	pickle.dump(output, outfile, protocol=-1)
	outfile.close()
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
