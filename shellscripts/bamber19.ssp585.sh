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


# - Pipeline bamber19.ssp585.temperature.fair.temperature:


PIPELINEDIR=$WORKDIR/bamber19.ssp585.temperature.fair.temperature
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/bamber19.ssp585/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp ./modules/fair/temperature/fair_temperature_preprocess.py ./modules-data/fair_temperature_preprocess_data.tgz $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf fair_temperature_preprocess_data.tgz 2> /dev/null; rm fair_temperature_preprocess_data.tgz
pip install --upgrade pip; pip install numpy scipy netCDF4 pyyaml matplotlib pandas xarray dask fair==1.6.4
python3 fair_temperature_preprocess.py --scenario ssp585 --pipeline_id bamber19.ssp585.temperature.fair.temperature


# ---- Stage fit:

cd $BASEDIR
cp ./modules/fair/temperature/fair_temperature_fit.py ./modules-data/fair_temperature_fit_data.tgz $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf fair_temperature_fit_data.tgz 2> /dev/null; rm fair_temperature_fit_data.tgz
python3 fair_temperature_fit.py --pipeline_id bamber19.ssp585.temperature.fair.temperature


# ---- Stage project:

cd $BASEDIR
cp ./modules/fair/temperature/my_FAIR_forward.py ./modules/fair/temperature/fair_temperature_project.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 fair_temperature_project.py --pipeline_id bamber19.ssp585.temperature.fair.temperature --nsamps 500

cp bamber19.ssp585.temperature.fair.temperature_oceantemp.nc $OUTPUTDIR
cp bamber19.ssp585.temperature.fair.temperature_climate.nc $OUTPUTDIR
cp bamber19.ssp585.temperature.fair.temperature_ohc.nc $OUTPUTDIR
cp bamber19.ssp585.temperature.fair.temperature_gsat.nc $OUTPUTDIR

# ---- Stage postprocess:

cd $BASEDIR
cp ./modules/fair/temperature/fair_temperature_postprocess.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 fair_temperature_postprocess.py --pipeline_id bamber19.ssp585.temperature.fair.temperature


#EXPERIMENT STEP:  sealevel_step 


# - Pipeline bamber19.ssp585.bamber19.bamber19.icesheets:


PIPELINEDIR=$WORKDIR/bamber19.ssp585.bamber19.bamber19.icesheets
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/bamber19.ssp585/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp ./modules-data/bamber19_icesheets_preprocess_data.tgz ./modules/bamber19/icesheets/bamber19_icesheets_preprocess.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf bamber19_icesheets_preprocess_data.tgz 2> /dev/null; rm bamber19_icesheets_preprocess_data.tgz
pip install --upgrade pip; pip install numpy scipy netCDF4 pyyaml matplotlib h5py
python3 bamber19_icesheets_preprocess.py --pipeline_id bamber19.ssp585.bamber19.bamber19.icesheets --pyear_start 2020 --pyear_end 2150 --pyear_step 10 --scenario ssp585 --baseyear 2005 --climate_data_file $SHARED/climate/bamber19.ssp585.temperature.fair.temperature_climate.nc


# ---- Stage fit:

cd $BASEDIR
cp ./modules/bamber19/icesheets/bamber19_icesheets_fit.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 bamber19_icesheets_fit.py --pipeline_id bamber19.ssp585.bamber19.bamber19.icesheets


# ---- Stage project:

cd $BASEDIR
cp ./modules/bamber19/icesheets/bamber19_icesheets_project.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 bamber19_icesheets_project.py --nsamps 500 --pipeline_id bamber19.ssp585.bamber19.bamber19.icesheets --climate_data_file $SHARED/climate/bamber19.ssp585.temperature.fair.temperature_climate.nc

cp bamber19.ssp585.bamber19.bamber19.icesheets_AIS_globalsl.nc $OUTPUTDIR
cp bamber19.ssp585.bamber19.bamber19.icesheets_EAIS_globalsl.nc $OUTPUTDIR
cp bamber19.ssp585.bamber19.bamber19.icesheets_WAIS_globalsl.nc $OUTPUTDIR
cp bamber19.ssp585.bamber19.bamber19.icesheets_GIS_globalsl.nc $OUTPUTDIR

# ---- Stage postprocess:

cd $BASEDIR
cp ./modules/bamber19/icesheets/bamber19_icesheets_postprocess.py ./modules-data/grd_fingerprints_data.tgz ./modules/bamber19/icesheets/ReadFingerprint.py ./modules/bamber19/icesheets/read_locationfile.py ./modules/bamber19/icesheets/AssignFP.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf grd_fingerprints_data.tgz 2> /dev/null; rm grd_fingerprints_data.tgz
python3 bamber19_icesheets_postprocess.py --pipeline_id bamber19.ssp585.bamber19.bamber19.icesheets

cp bamber19.ssp585.bamber19.bamber19.icesheets_WAIS_localsl.nc $OUTPUTDIR
cp bamber19.ssp585.bamber19.bamber19.icesheets_GIS_localsl.nc $OUTPUTDIR
cp bamber19.ssp585.bamber19.bamber19.icesheets_EAIS_localsl.nc $OUTPUTDIR
cp bamber19.ssp585.bamber19.bamber19.icesheets_AIS_localsl.nc $OUTPUTDIR

# - Pipeline bamber19.ssp585.bamber19raw.bamber19.icesheets:


PIPELINEDIR=$WORKDIR/bamber19.ssp585.bamber19raw.bamber19.icesheets
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/bamber19.ssp585/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp ./modules-data/bamber19_icesheets_preprocess_data.tgz ./modules/bamber19/icesheets/bamber19_icesheets_preprocess.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf bamber19_icesheets_preprocess_data.tgz 2> /dev/null; rm bamber19_icesheets_preprocess_data.tgz
pip install --upgrade pip; pip install numpy scipy netCDF4 pyyaml matplotlib h5py
python3 bamber19_icesheets_preprocess.py --pipeline_id bamber19.ssp585.bamber19raw.bamber19.icesheets --pyear_start 2020 --pyear_end 2150 --pyear_step 10 --scenario rcp85 --baseyear 2005 --climate_data_file 


# ---- Stage fit:

cd $BASEDIR
cp ./modules/bamber19/icesheets/bamber19_icesheets_fit.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 bamber19_icesheets_fit.py --pipeline_id bamber19.ssp585.bamber19raw.bamber19.icesheets


# ---- Stage project:

cd $BASEDIR
cp ./modules/bamber19/icesheets/bamber19_icesheets_project.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 bamber19_icesheets_project.py --nsamps 500 --pipeline_id bamber19.ssp585.bamber19raw.bamber19.icesheets --climate_data_file 

cp bamber19.ssp585.bamber19raw.bamber19.icesheets_GIS_globalsl.nc $OUTPUTDIR
cp bamber19.ssp585.bamber19raw.bamber19.icesheets_WAIS_globalsl.nc $OUTPUTDIR
cp bamber19.ssp585.bamber19raw.bamber19.icesheets_EAIS_globalsl.nc $OUTPUTDIR
cp bamber19.ssp585.bamber19raw.bamber19.icesheets_AIS_globalsl.nc $OUTPUTDIR

# ---- Stage postprocess:

cd $BASEDIR
cp ./modules/bamber19/icesheets/bamber19_icesheets_postprocess.py ./modules-data/grd_fingerprints_data.tgz ./modules/bamber19/icesheets/ReadFingerprint.py ./modules/bamber19/icesheets/read_locationfile.py ./modules/bamber19/icesheets/AssignFP.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf grd_fingerprints_data.tgz 2> /dev/null; rm grd_fingerprints_data.tgz
python3 bamber19_icesheets_postprocess.py --pipeline_id bamber19.ssp585.bamber19raw.bamber19.icesheets

cp bamber19.ssp585.bamber19raw.bamber19.icesheets_GIS_localsl.nc $OUTPUTDIR
cp bamber19.ssp585.bamber19raw.bamber19.icesheets_EAIS_localsl.nc $OUTPUTDIR
cp bamber19.ssp585.bamber19raw.bamber19.icesheets_WAIS_localsl.nc $OUTPUTDIR
cp bamber19.ssp585.bamber19raw.bamber19.icesheets_AIS_localsl.nc $OUTPUTDIR
