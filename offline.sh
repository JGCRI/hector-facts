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


# - Pipeline tlm.offline.dummy.facts.dummy:


PIPELINEDIR=$WORKDIR/tlm.offline.dummy.facts.dummy
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/tlm.offline/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp ./modules/facts/dummy/facts_dummy_preprocess.py experiments/tlm.offline/input/tlm.offline.temperature.fair.temperature_climate.nc $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python facts_dummy_preprocess.py --pipeline_id tlm.offline.dummy.facts.dummy

cp tlm.offline.temperature.fair.temperature_climate.nc $OUTPUTDIR

#EXPERIMENT STEP:  sealevel_step 


# - Pipeline tlm.offline.ocean.tlm.sterodynamics:


PIPELINEDIR=$WORKDIR/tlm.offline.ocean.tlm.sterodynamics
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/tlm.offline/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp ./modules-data/tlm_sterodynamics_preprocess_data.tgz ./modules/tlm/sterodynamics/Import2lmData.py ./modules/tlm/sterodynamics/tlm_sterodynamics_preprocess_thermalexpansion.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf tlm_sterodynamics_preprocess_data.tgz 2> /dev/null; rm tlm_sterodynamics_preprocess_data.tgz
pip install --upgrade pip; pip install numpy scipy netCDF4 pyyaml h5py
python3 tlm_sterodynamics_preprocess_thermalexpansion.py --scenario ssp585 --climate_data_file tlm.offline.temperature.fair.temperature_climate.nc --pipeline_id tlm.offline.ocean.tlm.sterodynamics


# ---- Stage fit:

cd $BASEDIR
cp ./modules/tlm/sterodynamics/tlm_sterodynamics_fit_thermalexpansion.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 tlm_sterodynamics_fit_thermalexpansion.py --pipeline_id tlm.offline.ocean.tlm.sterodynamics


# ---- Stage project:

cd $BASEDIR
cp ./modules/tlm/sterodynamics/tlm_sterodynamics_project.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 tlm_sterodynamics_project.py --pipeline_id tlm.offline.ocean.tlm.sterodynamics --nsamps 200 --scenario ssp585 --baseyear 2005 --pyear_start 2020 --pyear_end 2150 --pyear_step 10

cp tlm.offline.ocean.tlm.sterodynamics_globalsl.nc $OUTPUTDIR
