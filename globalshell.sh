#!/bin/bash

if [ -z "$WORKDIR" ]; then  
   WORKDIR=/opt/facts/`whoami`/test.`date +%s`
fi
mkdir -p $WORKDIR

if [ -z "$OUTPUTDIR" ]; then  
   OUTPUTDIR=/opt/facts/`whoami`/test.`date +%s`/output
fi
mkdir -p $OUTPUTDIR
BASEDIR=`pwd`

#EXPERIMENT STEP:  climate_step 


# - Pipeline tlm.global.temperature.fair.temperature:


PIPELINEDIR=$WORKDIR/tlm.global.temperature.fair.temperature
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/tlm.global/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp ./modules-data/fair_temperature_preprocess_data.tgz ./modules/fair/temperature/fair_temperature_preprocess.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf fair_temperature_preprocess_data.tgz 2> /dev/null; rm fair_temperature_preprocess_data.tgz
pip install --upgrade pip; pip install numpy scipy netCDF4 pyyaml matplotlib pandas xarray dask fair==1.6.4
python3 fair_temperature_preprocess.py --scenario ssp585 --pipeline_id tlm.global.temperature.fair.temperature


# ---- Stage fit:

cd $BASEDIR
cp ./modules-data/fair_temperature_fit_data.tgz ./modules/fair/temperature/fair_temperature_fit.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf fair_temperature_fit_data.tgz 2> /dev/null; rm fair_temperature_fit_data.tgz
python3 fair_temperature_fit.py --pipeline_id tlm.global.temperature.fair.temperature


# ---- Stage project:

cd $BASEDIR
cp ./modules/fair/temperature/my_FAIR_forward.py ./modules/fair/temperature/fair_temperature_project.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 fair_temperature_project.py --pipeline_id tlm.global.temperature.fair.temperature --nsamps 200

cp tlm.global.temperature.fair.temperature_oceantemp.nc $OUTPUTDIR
cp tlm.global.temperature.fair.temperature_ohc.nc $OUTPUTDIR
cp tlm.global.temperature.fair.temperature_climate.nc $OUTPUTDIR
cp tlm.global.temperature.fair.temperature_gsat.nc $OUTPUTDIR

# ---- Stage postprocess:

cd $BASEDIR
cp ./modules/fair/temperature/fair_temperature_postprocess.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 fair_temperature_postprocess.py --pipeline_id tlm.global.temperature.fair.temperature


#EXPERIMENT STEP:  sealevel_step 


# - Pipeline tlm.global.ocean.tlm.sterodynamics:


PIPELINEDIR=$WORKDIR/tlm.global.ocean.tlm.sterodynamics
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/tlm.global/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp ./modules/tlm/sterodynamics/tlm_sterodynamics_preprocess_thermalexpansion.py ./modules-data/tlm_sterodynamics_preprocess_data.tgz ./modules/tlm/sterodynamics/Import2lmData.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf tlm_sterodynamics_preprocess_data.tgz 2> /dev/null; rm tlm_sterodynamics_preprocess_data.tgz
pip install --upgrade pip; pip install numpy scipy netCDF4 pyyaml h5py
python3 tlm_sterodynamics_preprocess_thermalexpansion.py --scenario ssp585 --climate_data_file tlm.global.temperature.fair.temperature_climate.nc --pipeline_id tlm.global.ocean.tlm.sterodynamics
# ^ edited location of tlm.global.temperature.fair.temperature_climate.nc because $SHARED isn't defined


# ---- Stage fit:

cd $BASEDIR
cp ./modules/tlm/sterodynamics/tlm_sterodynamics_fit_thermalexpansion.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 tlm_sterodynamics_fit_thermalexpansion.py --pipeline_id tlm.global.ocean.tlm.sterodynamics


# ---- Stage project:

cd $BASEDIR
cp ./modules/tlm/sterodynamics/tlm_sterodynamics_project.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 tlm_sterodynamics_project.py --pipeline_id tlm.global.ocean.tlm.sterodynamics --nsamps 200 --scenario ssp585 --baseyear 2005 --pyear_start 2020 --pyear_end 2150 --pyear_step 10

cp tlm.global.ocean.tlm.sterodynamics_globalsl.nc $OUTPUTDIR
