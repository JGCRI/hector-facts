import argparse
import sys


def hector_postprocess_temperature(pipeline_id):

	# There is no post-processing steps at this time.
    sys.stdout.write("Hello, World my post processing script!\n")

	return(None)


if __name__ == "__main__":

	# Initialize the command-line argument parser
	parser = argparse.ArgumentParser(description="Run the postprocess stage for the Hector temperature module",\
	epilog="Note: This is meant to be run as part of the Framework for the Assessment of Changes To Sea-level (FACTS)")

	# Define the command line arguments to be expected
	parser.add_argument('--pipeline_id', help="Unique identifier for this instance of the module", required=True)

	# Parse the arguments
	args = parser.parse_args()

	# Run the code
	hector_postprocess_temperature(pipeline_id=args.pipeline_id)


	sys.exit()
