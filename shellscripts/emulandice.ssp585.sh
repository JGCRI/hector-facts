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


# - Pipeline emulandice.ssp585.temperature.fair.temperature:


PIPELINEDIR=$WORKDIR/emulandice.ssp585.temperature.fair.temperature
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/emulandice.ssp585/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp ./modules/fair/temperature/fair_temperature_preprocess.py ./modules-data/fair_temperature_preprocess_data.tgz $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf fair_temperature_preprocess_data.tgz 2> /dev/null; rm fair_temperature_preprocess_data.tgz
pip install --upgrade pip; pip install numpy scipy netCDF4 pyyaml matplotlib pandas xarray dask fair==1.6.4
python3 fair_temperature_preprocess.py --scenario ssp585 --pipeline_id emulandice.ssp585.temperature.fair.temperature


# ---- Stage fit:

cd $BASEDIR
cp ./modules/fair/temperature/fair_temperature_fit.py ./modules-data/fair_temperature_fit_data.tgz $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf fair_temperature_fit_data.tgz 2> /dev/null; rm fair_temperature_fit_data.tgz
python3 fair_temperature_fit.py --pipeline_id emulandice.ssp585.temperature.fair.temperature


# ---- Stage project:

cd $BASEDIR
cp ./modules/fair/temperature/fair_temperature_project.py ./modules/fair/temperature/my_FAIR_forward.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 fair_temperature_project.py --pipeline_id emulandice.ssp585.temperature.fair.temperature --nsamps 50

cp emulandice.ssp585.temperature.fair.temperature_climate.nc $OUTPUTDIR
cp emulandice.ssp585.temperature.fair.temperature_gsat.nc $OUTPUTDIR
cp emulandice.ssp585.temperature.fair.temperature_oceantemp.nc $OUTPUTDIR
cp emulandice.ssp585.temperature.fair.temperature_ohc.nc $OUTPUTDIR

#EXPERIMENT STEP:  sealevel_step 


# - Pipeline emulandice.ssp585.emuAIS.emulandice.AIS:


PIPELINEDIR=$WORKDIR/emulandice.ssp585.emuAIS.emulandice.AIS
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/emulandice.ssp585/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp ./modules/emulandice/AIS/../shared/FACTS_CLIMATE_FORCING.csv.head ./modules/emulandice/AIS/../shared/emulandice_preprocess.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
pip install --upgrade pip; pip install numpy scipy netCDF4 pyyaml matplotlib xarray dask
python3 emulandice_preprocess.py --input_data_file $SHARED/climate/emulandice.ssp585.temperature.fair.temperature_gsat.nc --baseyear 2005 --pipeline_id emulandice.ssp585.emuAIS.emulandice.AIS


# ---- Stage fit:

cd $BASEDIR
cp ./modules/emulandice/AIS/emulandice_AIS_fit.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 emulandice_AIS_fit.py --pipeline_id emulandice.ssp585.emuAIS.emulandice.AIS


# ---- Stage project:

cd $BASEDIR
cp ./modules/emulandice/AIS/../shared/emulandice_environment.sh ./modules/emulandice/AIS/../shared/emulandice_steer.sh ./modules/emulandice/AIS/../shared/emulandice_bundled_dependencies.tgz ./modules/emulandice/AIS/emulandice_AIS_project.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf emulandice_bundled_dependencies.tgz 2> /dev/null; rm emulandice_bundled_dependencies.tgz
python3 emulandice_AIS_project.py --pipeline_id emulandice.ssp585.emuAIS.emulandice.AIS

cp emulandice.ssp585.emuAIS.emulandice.AIS_globalsl.nc $OUTPUTDIR
cp emulandice.ssp585.emuAIS.emulandice.AIS_EAIS_globalsl.nc $OUTPUTDIR
cp emulandice.ssp585.emuAIS.emulandice.AIS_WAIS_globalsl.nc $OUTPUTDIR
cp emulandice.ssp585.emuAIS.emulandice.AIS_PEN_globalsl.nc $OUTPUTDIR
