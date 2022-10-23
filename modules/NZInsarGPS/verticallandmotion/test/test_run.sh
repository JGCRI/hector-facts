#!/bin/bash

python NZInsarGPS_preprocess_verticallandmotion.py --pipeline_id verticallandmotion-NZInsarGPS-verticallandmotion
python NZInsarGPS_fit_verticallandmotion.py --pipeline_id verticallandmotion-NZInsarGPS-verticallandmotion
python NZInsarGPS_project_verticallandmotion.py --pipeline_id verticallandmotion-NZInsarGPS-verticallandmotion
python NZInsarGPS_postprocess_verticallandmotion.py --pipeline_id verticallandmotion-NZInsarGPS-verticallandmotion --nsamps 20000 --seed 7331 --baseyear 2005 --pyear_start 2020 --pyear_end 2300 --pyear_step 10 --chunksize 662 --locationfile $LFILE