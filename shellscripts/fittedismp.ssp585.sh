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


# - Pipeline fittedismip.ssp585.temperature.fair.temperature:


PIPELINEDIR=$WORKDIR/fittedismip.ssp585.temperature.fair.temperature
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/fittedismip.ssp585/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp ./modules/fair/temperature/fair_temperature_preprocess.py ./modules-data/fair_temperature_preprocess_data.tgz $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf fair_temperature_preprocess_data.tgz 2> /dev/null; rm fair_temperature_preprocess_data.tgz
pip install --upgrade pip; pip install numpy scipy netCDF4 pyyaml matplotlib pandas xarray dask fair==1.6.4
python3 fair_temperature_preprocess.py --scenario ssp585 --pipeline_id fittedismip.ssp585.temperature.fair.temperature


# ---- Stage fit:

cd $BASEDIR
cp ./modules-data/fair_temperature_fit_data.tgz ./modules/fair/temperature/fair_temperature_fit.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf fair_temperature_fit_data.tgz 2> /dev/null; rm fair_temperature_fit_data.tgz
python3 fair_temperature_fit.py --pipeline_id fittedismip.ssp585.temperature.fair.temperature


# ---- Stage project:

cd $BASEDIR
cp ./modules/fair/temperature/fair_temperature_project.py ./modules/fair/temperature/my_FAIR_forward.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 fair_temperature_project.py --pipeline_id fittedismip.ssp585.temperature.fair.temperature --nsamps 200

cp fittedismip.ssp585.temperature.fair.temperature_gsat.nc $OUTPUTDIR
cp fittedismip.ssp585.temperature.fair.temperature_ohc.nc $OUTPUTDIR
cp fittedismip.ssp585.temperature.fair.temperature_oceantemp.nc $OUTPUTDIR
cp fittedismip.ssp585.temperature.fair.temperature_climate.nc $OUTPUTDIR

# ---- Stage postprocess:

cd $BASEDIR
cp ./modules/fair/temperature/fair_temperature_postprocess.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 fair_temperature_postprocess.py --pipeline_id fittedismip.ssp585.temperature.fair.temperature


#EXPERIMENT STEP:  sealevel_step 


# - Pipeline fittedismip.ssp585.GrIS1f.FittedISMIP.GrIS:


PIPELINEDIR=$WORKDIR/fittedismip.ssp585.GrIS1f.FittedISMIP.GrIS
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/fittedismip.ssp585/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp ./modules/FittedISMIP/GrIS/Import2lmData.py ./modules/FittedISMIP/GrIS/import_temp_data.py ./modules/FittedISMIP/GrIS/FittedISMIP_GrIS_preprocess.py ./modules/FittedISMIP/GrIS/filter_temp_data.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
pip install --upgrade pip; pip install numpy scipy netCDF4 pyyaml matplotlib h5py xarray dask[array]
python3 FittedISMIP_GrIS_preprocess.py --climate_data_file $SHARED/climate/fittedismip.ssp585.temperature.fair.temperature_climate.nc --scenario ssp585 --pipeline_id fittedismip.ssp585.GrIS1f.FittedISMIP.GrIS


# ---- Stage fit:

cd $BASEDIR
cp ./modules-data/FittedISMIP_icesheet_fit_data.tgz ./modules/FittedISMIP/GrIS/FittedISMIP_GrIS_fit.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf FittedISMIP_icesheet_fit_data.tgz 2> /dev/null; rm FittedISMIP_icesheet_fit_data.tgz
python3 FittedISMIP_GrIS_fit.py --pipeline_id fittedismip.ssp585.GrIS1f.FittedISMIP.GrIS


# ---- Stage project:

cd $BASEDIR
cp ./modules/FittedISMIP/GrIS/FittedISMIP_GrIS_project.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 FittedISMIP_GrIS_project.py --nsamps 200 --pyear_start 2020 --pyear_end 2300 --pyear_step 10 --baseyear 2005 --pipeline_id fittedismip.ssp585.GrIS1f.FittedISMIP.GrIS

cp fittedismip.ssp585.GrIS1f.FittedISMIP.GrIS_GIS_globalsl.nc $OUTPUTDIR

# ---- Stage postprocess:

cd $BASEDIR
cp ./modules/FittedISMIP/GrIS/FittedISMIP_GrIS_postprocess.py ./modules/FittedISMIP/GrIS/AssignFP.py ./modules/FittedISMIP/GrIS/read_locationfile.py ./modules-data/grd_fingerprints_data.tgz ./modules/FittedISMIP/GrIS/ReadFingerprint.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf grd_fingerprints_data.tgz 2> /dev/null; rm grd_fingerprints_data.tgz
python3 FittedISMIP_GrIS_postprocess.py --pipeline_id fittedismip.ssp585.GrIS1f.FittedISMIP.GrIS

cp fittedismip.ssp585.GrIS1f.FittedISMIP.GrIS_GIS_localsl.nc $OUTPUTDIR

# - Pipeline fittedismip.ssp585.GrIS1fnoextrap.FittedISMIP.GrIS:


PIPELINEDIR=$WORKDIR/fittedismip.ssp585.GrIS1fnoextrap.FittedISMIP.GrIS
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/fittedismip.ssp585/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp ./modules/FittedISMIP/GrIS/Import2lmData.py ./modules/FittedISMIP/GrIS/import_temp_data.py ./modules/FittedISMIP/GrIS/FittedISMIP_GrIS_preprocess.py ./modules/FittedISMIP/GrIS/filter_temp_data.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
pip install --upgrade pip; pip install numpy scipy netCDF4 pyyaml matplotlib h5py xarray dask[array]
python3 FittedISMIP_GrIS_preprocess.py --climate_data_file $SHARED/climate/fittedismip.ssp585.temperature.fair.temperature_climate.nc --scenario ssp585 --pipeline_id fittedismip.ssp585.GrIS1fnoextrap.FittedISMIP.GrIS


# ---- Stage fit:

cd $BASEDIR
cp ./modules-data/FittedISMIP_icesheet_fit_data.tgz ./modules/FittedISMIP/GrIS/FittedISMIP_GrIS_fit.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf FittedISMIP_icesheet_fit_data.tgz 2> /dev/null; rm FittedISMIP_icesheet_fit_data.tgz
python3 FittedISMIP_GrIS_fit.py --pipeline_id fittedismip.ssp585.GrIS1fnoextrap.FittedISMIP.GrIS


# ---- Stage project:

cd $BASEDIR
cp ./modules/FittedISMIP/GrIS/FittedISMIP_GrIS_project.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 FittedISMIP_GrIS_project.py --nsamps 200 --pyear_start 2020 --pyear_end 2300 --pyear_step 10 --crateyear_end 2300 --baseyear 2005 --pipeline_id fittedismip.ssp585.GrIS1fnoextrap.FittedISMIP.GrIS

cp fittedismip.ssp585.GrIS1fnoextrap.FittedISMIP.GrIS_GIS_globalsl.nc $OUTPUTDIR

# ---- Stage postprocess:

cd $BASEDIR
cp ./modules/FittedISMIP/GrIS/FittedISMIP_GrIS_postprocess.py ./modules/FittedISMIP/GrIS/AssignFP.py ./modules/FittedISMIP/GrIS/read_locationfile.py ./modules-data/grd_fingerprints_data.tgz ./modules/FittedISMIP/GrIS/ReadFingerprint.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf grd_fingerprints_data.tgz 2> /dev/null; rm grd_fingerprints_data.tgz
python3 FittedISMIP_GrIS_postprocess.py --pipeline_id fittedismip.ssp585.GrIS1fnoextrap.FittedISMIP.GrIS

cp fittedismip.ssp585.GrIS1fnoextrap.FittedISMIP.GrIS_GIS_localsl.nc $OUTPUTDIR
