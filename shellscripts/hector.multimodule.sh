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


# - Pipeline hector.multimodule.dummy.facts.dummy:


PIPELINEDIR=$WORKDIR/hector.multimodule.dummy.facts.dummy
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/hector.multimodule/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp experiments/hector.multimodule/input/hector.multimodule.temperature.fair.temperature_climate.nc ./modules/facts/dummy/facts_dummy_preprocess.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python facts_dummy_preprocess.py --pipeline_id hector.multimodule.dummy.facts.dummy

cp hector.multimodule.temperature.fair.temperature_climate.nc $OUTPUTDIR

#EXPERIMENT STEP:  sealevel_step 


# - Pipeline hector.multimodule.GrIS1f.FittedISMIP.GrIS:


PIPELINEDIR=$WORKDIR/hector.multimodule.GrIS1f.FittedISMIP.GrIS
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/hector.multimodule/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp ./modules/FittedISMIP/GrIS/Import2lmData.py ./modules/FittedISMIP/GrIS/import_temp_data.py ./modules/FittedISMIP/GrIS/filter_temp_data.py ./modules/FittedISMIP/GrIS/FittedISMIP_GrIS_preprocess.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
pip install --upgrade pip; pip install numpy scipy netCDF4 pyyaml matplotlib h5py xarray dask[array]
python3 FittedISMIP_GrIS_preprocess.py --climate_data_file $SHARED/climate/hector.multimodule.temperature.fair.temperature_climate.nc --scenario ssp585 --pipeline_id hector.multimodule.GrIS1f.FittedISMIP.GrIS


# ---- Stage fit:

cd $BASEDIR
cp ./modules/FittedISMIP/GrIS/FittedISMIP_GrIS_fit.py ./modules-data/FittedISMIP_icesheet_fit_data.tgz $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf FittedISMIP_icesheet_fit_data.tgz 2> /dev/null; rm FittedISMIP_icesheet_fit_data.tgz
python3 FittedISMIP_GrIS_fit.py --pipeline_id hector.multimodule.GrIS1f.FittedISMIP.GrIS


# ---- Stage project:

cd $BASEDIR
cp ./modules/FittedISMIP/GrIS/FittedISMIP_GrIS_project.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 FittedISMIP_GrIS_project.py --nsamps 1 --pyear_start 2020 --pyear_end 2150 --pyear_step 10 --baseyear 2005 --pipeline_id hector.multimodule.GrIS1f.FittedISMIP.GrIS

cp hector.multimodule.GrIS1f.FittedISMIP.GrIS_GIS_globalsl.nc $OUTPUTDIR

# ---- Stage postprocess:

cd $BASEDIR
cp ./modules-data/grd_fingerprints_data.tgz ./modules/FittedISMIP/GrIS/ReadFingerprint.py ./modules/FittedISMIP/GrIS/AssignFP.py ./modules/FittedISMIP/GrIS/FittedISMIP_GrIS_postprocess.py ./modules/FittedISMIP/GrIS/read_locationfile.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf grd_fingerprints_data.tgz 2> /dev/null; rm grd_fingerprints_data.tgz
python3 FittedISMIP_GrIS_postprocess.py --pipeline_id hector.multimodule.GrIS1f.FittedISMIP.GrIS

cp hector.multimodule.GrIS1f.FittedISMIP.GrIS_GIS_localsl.nc $OUTPUTDIR

# - Pipeline hector.multimodule.ocean.tlm.sterodynamics:


PIPELINEDIR=$WORKDIR/hector.multimodule.ocean.tlm.sterodynamics
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/hector.multimodule/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp ./modules-data/tlm_sterodynamics_preprocess_data.tgz ./modules/tlm/sterodynamics/tlm_sterodynamics_preprocess_thermalexpansion.py ./modules/tlm/sterodynamics/Import2lmData.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf tlm_sterodynamics_preprocess_data.tgz 2> /dev/null; rm tlm_sterodynamics_preprocess_data.tgz
pip install --upgrade pip; pip install numpy scipy netCDF4 pyyaml h5py
python3 tlm_sterodynamics_preprocess_thermalexpansion.py --scenario ssp585 --climate_data_file $SHARED/climate/hector.multimodule.temperature.fair.temperature_climate.nc --pipeline_id hector.multimodule.ocean.tlm.sterodynamics


# ---- Stage fit:

cd $BASEDIR
cp ./modules/tlm/sterodynamics/tlm_sterodynamics_fit_thermalexpansion.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 tlm_sterodynamics_fit_thermalexpansion.py --pipeline_id hector.multimodule.ocean.tlm.sterodynamics


# ---- Stage project:

cd $BASEDIR
cp ./modules/tlm/sterodynamics/tlm_sterodynamics_project.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 tlm_sterodynamics_project.py --pipeline_id hector.multimodule.ocean.tlm.sterodynamics --nsamps 1 --scenario ssp585 --baseyear 2005 --pyear_start 2020 --pyear_end 2150 --pyear_step 10

cp hector.multimodule.ocean.tlm.sterodynamics_globalsl.nc $OUTPUTDIR

#EXPERIMENT STEP:  totaling_step 

