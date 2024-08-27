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

#EXPERIMENT STEP:  sealevel_step 


# - Pipeline ar5k14.rcp85.ar5glaciers.ipccar5.glaciers:


PIPELINEDIR=$WORKDIR/ar5k14.rcp85.ar5glaciers.ipccar5.glaciers
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/ar5k14.rcp85/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp ./modules/ipccar5/glaciers/ipccar5_glaciers_preprocess.py ./modules/ipccar5/glaciers/Import2lmData.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
pip install --upgrade pip; pip install numpy scipy netCDF4 pyyaml matplotlib h5py
python3 ipccar5_glaciers_preprocess.py --scenario rcp85 --baseyear 2005 --tlm_data 0 --pipeline_id ar5k14.rcp85.ar5glaciers.ipccar5.glaciers


# ---- Stage fit:

cd $BASEDIR
cp ./modules/ipccar5/glaciers/ipccar5_glaciers_fit.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 ipccar5_glaciers_fit.py --pipeline_id ar5k14.rcp85.ar5glaciers.ipccar5.glaciers


# ---- Stage project:

cd $BASEDIR
cp ./modules-data/ipccar5_glaciers_project_data.tgz ./modules/ipccar5/glaciers/ipccar5_glaciers_project.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf ipccar5_glaciers_project_data.tgz 2> /dev/null; rm ipccar5_glaciers_project_data.tgz
python3 ipccar5_glaciers_project.py --nsamps 2000 --pyear_start 2020 --pyear_end 2100 --pyear_step 10 --pipeline_id ar5k14.rcp85.ar5glaciers.ipccar5.glaciers

cp ar5k14.rcp85.ar5glaciers.ipccar5.glaciers_globalsl.nc $OUTPUTDIR

# ---- Stage postprocess:

cd $BASEDIR
cp ./modules/ipccar5/glaciers/ipccar5_glaciers_postprocess.py ./modules/ipccar5/glaciers/ReadFingerprint.py ./modules-data/grd_fingerprints_data.tgz ./modules/ipccar5/glaciers/AssignFP.py ./modules/ipccar5/glaciers/read_locationfile.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf grd_fingerprints_data.tgz 2> /dev/null; rm grd_fingerprints_data.tgz
python3 ipccar5_glaciers_postprocess.py --pipeline_id ar5k14.rcp85.ar5glaciers.ipccar5.glaciers

cp ar5k14.rcp85.ar5glaciers.ipccar5.glaciers_localsl.nc $OUTPUTDIR

# - Pipeline ar5k14.rcp85.ar5icesheets.ipccar5.icesheets:


PIPELINEDIR=$WORKDIR/ar5k14.rcp85.ar5icesheets.ipccar5.icesheets
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/ar5k14.rcp85/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp ./modules/ipccar5/icesheets/ipccar5_icesheets_preprocess.py ./modules/ipccar5/icesheets/Import2lmData.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
pip install --upgrade pip; pip install numpy scipy netCDF4 pyyaml matplotlib h5py
python3 ipccar5_icesheets_preprocess.py --scenario rcp85 --pipeline_id ar5k14.rcp85.ar5icesheets.ipccar5.icesheets --baseyear 2005 --tlm_data 0


# ---- Stage fit:

cd $BASEDIR
cp ./modules/ipccar5/icesheets/ipccar5_icesheets_fit.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 ipccar5_icesheets_fit.py --pipeline_id ar5k14.rcp85.ar5icesheets.ipccar5.icesheets


# ---- Stage project:

cd $BASEDIR
cp ./modules/ipccar5/icesheets/ipccar5_icesheets_project.py ./modules-data/ipccar5_icesheets_project_data.tgz $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf ipccar5_icesheets_project_data.tgz 2> /dev/null; rm ipccar5_icesheets_project_data.tgz
python3 ipccar5_icesheets_project.py --nsamps 2000 --pyear_start 2020 --pyear_end 2100 --pyear_step 10 --pipeline_id ar5k14.rcp85.ar5icesheets.ipccar5.icesheets

cp ar5k14.rcp85.ar5icesheets.ipccar5.icesheets_WAIS_globalsl.nc $OUTPUTDIR
cp ar5k14.rcp85.ar5icesheets.ipccar5.icesheets_AIS_globalsl.nc $OUTPUTDIR
cp ar5k14.rcp85.ar5icesheets.ipccar5.icesheets_EAIS_globalsl.nc $OUTPUTDIR
cp ar5k14.rcp85.ar5icesheets.ipccar5.icesheets_GIS_globalsl.nc $OUTPUTDIR

# ---- Stage postprocess:

cd $BASEDIR
cp ./modules/ipccar5/icesheets/ipccar5_icesheets_postprocess.py ./modules/ipccar5/icesheets/read_locationfile.py ./modules/ipccar5/icesheets/AssignFP.py ./modules/ipccar5/icesheets/ReadFingerprint.py ./modules-data/grd_fingerprints_data.tgz $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf grd_fingerprints_data.tgz 2> /dev/null; rm grd_fingerprints_data.tgz
python3 ipccar5_icesheets_postprocess.py --pipeline_id ar5k14.rcp85.ar5icesheets.ipccar5.icesheets

cp ar5k14.rcp85.ar5icesheets.ipccar5.icesheets_WAIS_localsl.nc $OUTPUTDIR
cp ar5k14.rcp85.ar5icesheets.ipccar5.icesheets_GIS_localsl.nc $OUTPUTDIR
cp ar5k14.rcp85.ar5icesheets.ipccar5.icesheets_EAIS_localsl.nc $OUTPUTDIR

# - Pipeline ar5k14.rcp85.ar5TE.ipccar5.thermalexpansion:


PIPELINEDIR=$WORKDIR/ar5k14.rcp85.ar5TE.ipccar5.thermalexpansion
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/ar5k14.rcp85/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp ./modules/ipccar5/thermalexpansion/ipccar5_thermalexpansion_preprocess.py ./modules-data/ipccar5_climate_data.tgz $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf ipccar5_climate_data.tgz 2> /dev/null; rm ipccar5_climate_data.tgz
pip install --upgrade pip; pip install numpy scipy netCDF4 pyyaml matplotlib
python3 ipccar5_thermalexpansion_preprocess.py --scenario rcp85 --baseyear 2005 --pipeline_id ar5k14.rcp85.ar5TE.ipccar5.thermalexpansion


# ---- Stage fit:

cd $BASEDIR
cp ./modules/ipccar5/thermalexpansion/ipccar5_thermalexpansion_fit.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 ipccar5_thermalexpansion_fit.py --pipeline_id ar5k14.rcp85.ar5TE.ipccar5.thermalexpansion


# ---- Stage project:

cd $BASEDIR
cp ./modules/ipccar5/thermalexpansion/ipccar5_thermalexpansion_project.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 ipccar5_thermalexpansion_project.py --nsamps 2000 --pyear_start 2020 --pyear_end 2100 --pyear_step 10 --pipeline_id ar5k14.rcp85.ar5TE.ipccar5.thermalexpansion

cp ar5k14.rcp85.ar5TE.ipccar5.thermalexpansion_globalsl.nc $OUTPUTDIR

# ---- Stage postprocess:

cd $BASEDIR
cp ./modules/ipccar5/thermalexpansion/read_locationfile.py ./modules/ipccar5/thermalexpansion/ipccar5_thermalexpansion_postprocess.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 ipccar5_thermalexpansion_postprocess.py --pipeline_id ar5k14.rcp85.ar5TE.ipccar5.thermalexpansion

cp ar5k14.rcp85.ar5TE.ipccar5.thermalexpansion_localsl.nc $OUTPUTDIR

# - Pipeline ar5k14.rcp85.k14glaciers.kopp14.glaciers:


PIPELINEDIR=$WORKDIR/ar5k14.rcp85.k14glaciers.kopp14.glaciers
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/ar5k14.rcp85/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp ./modules/kopp14/glaciers/readMarzeion.py ./modules-data/kopp14_glaciers_preprocess_data.tgz ./modules/kopp14/glaciers/kopp14_glaciers_preprocess.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf kopp14_glaciers_preprocess_data.tgz 2> /dev/null; rm kopp14_glaciers_preprocess_data.tgz
pip install --upgrade pip; pip install  numpy scipy netCDF4 pyyaml matplotlib
python3 kopp14_glaciers_preprocess.py --scenario rcp85 --baseyear 2005 --pyear_start 2020 --pyear_end 2100 --pyear_step 10 --pipeline_id ar5k14.rcp85.k14glaciers.kopp14.glaciers


# ---- Stage fit:

cd $BASEDIR
cp ./modules/kopp14/glaciers/kopp14_glaciers_fit.py ./modules/kopp14/glaciers/cholcov.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 kopp14_glaciers_fit.py --pipeline_id ar5k14.rcp85.k14glaciers.kopp14.glaciers


# ---- Stage project:

cd $BASEDIR
cp ./modules/kopp14/glaciers/kopp14_glaciers_project.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 kopp14_glaciers_project.py --nsamps 2000 --pipeline_id ar5k14.rcp85.k14glaciers.kopp14.glaciers

cp ar5k14.rcp85.k14glaciers.kopp14.glaciers_globalsl.nc $OUTPUTDIR

# ---- Stage postprocess:

cd $BASEDIR
cp ./modules/kopp14/glaciers/ReadFingerprint.py ./modules/kopp14/glaciers/AssignFP.py ./modules/kopp14/glaciers/read_locationfile.py ./modules/kopp14/glaciers/kopp14_glaciers_postprocess.py ./modules-data/grd_fingerprints_data.tgz $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf grd_fingerprints_data.tgz 2> /dev/null; rm grd_fingerprints_data.tgz
python3 kopp14_glaciers_postprocess.py --pipeline_id ar5k14.rcp85.k14glaciers.kopp14.glaciers

cp ar5k14.rcp85.k14glaciers.kopp14.glaciers_localsl.nc $OUTPUTDIR

# - Pipeline ar5k14.rcp85.k14icesheets.kopp14.icesheets:


PIPELINEDIR=$WORKDIR/ar5k14.rcp85.k14icesheets.kopp14.icesheets
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/ar5k14.rcp85/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp ./modules/kopp14/icesheets/kopp14_icesheets_preprocess.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
pip install --upgrade pip; pip install numpy scipy netCDF4 pyyaml matplotlib
python3 kopp14_icesheets_preprocess.py --scenario rcp85 --pipeline_id ar5k14.rcp85.k14icesheets.kopp14.icesheets


# ---- Stage fit:

cd $BASEDIR
cp ./modules/kopp14/icesheets/CalcISDists.py ./modules/kopp14/icesheets/FitLNDistQuants.py ./modules/kopp14/icesheets/kopp14_icesheets_fit.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 kopp14_icesheets_fit.py --pipeline_id ar5k14.rcp85.k14icesheets.kopp14.icesheets


# ---- Stage project:

cd $BASEDIR
cp ./modules/kopp14/icesheets/SampleISDists.py ./modules/kopp14/icesheets/cholcov.py ./modules/kopp14/icesheets/ProjectGSL.py ./modules/kopp14/icesheets/kopp14_icesheets_project.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 kopp14_icesheets_project.py --nsamps 2000 --baseyear 2005 --pyear_start 2020 --pyear_end 2100 --pyear_step 10 --pipeline_id ar5k14.rcp85.k14icesheets.kopp14.icesheets

cp ar5k14.rcp85.k14icesheets.kopp14.icesheets_GIS_globalsl.nc $OUTPUTDIR
cp ar5k14.rcp85.k14icesheets.kopp14.icesheets_AIS_globalsl.nc $OUTPUTDIR
cp ar5k14.rcp85.k14icesheets.kopp14.icesheets_WAIS_globalsl.nc $OUTPUTDIR
cp ar5k14.rcp85.k14icesheets.kopp14.icesheets_EAIS_globalsl.nc $OUTPUTDIR

# ---- Stage postprocess:

cd $BASEDIR
cp ./modules/kopp14/icesheets/kopp14_icesheets_postprocess.py ./modules/kopp14/icesheets/AssignFP.py ./modules/kopp14/icesheets/SampleISDists.py ./modules-data/grd_fingerprints_data.tgz ./modules/kopp14/icesheets/read_locationfile.py ./modules/kopp14/icesheets/ReadFingerprint.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf grd_fingerprints_data.tgz 2> /dev/null; rm grd_fingerprints_data.tgz
python3 kopp14_icesheets_postprocess.py --pipeline_id ar5k14.rcp85.k14icesheets.kopp14.icesheets

cp ar5k14.rcp85.k14icesheets.kopp14.icesheets_WAIS_localsl.nc $OUTPUTDIR
cp ar5k14.rcp85.k14icesheets.kopp14.icesheets_EAIS_localsl.nc $OUTPUTDIR
cp ar5k14.rcp85.k14icesheets.kopp14.icesheets_GIS_localsl.nc $OUTPUTDIR

# - Pipeline ar5k14.rcp85.k14sterodynamics.kopp14.sterodynamics:


PIPELINEDIR=$WORKDIR/ar5k14.rcp85.k14sterodynamics.kopp14.sterodynamics
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/ar5k14.rcp85/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp ./modules/kopp14/sterodynamics/DriftCorr.py ./modules/kopp14/sterodynamics/read_locationfile.py ./modules/kopp14/sterodynamics/kopp14_oceandynamics_preprocess.py ./modules/kopp14/sterodynamics/Smooth.py ./modules/kopp14/sterodynamics/SmoothZOSTOGA.py ./modules/kopp14/sterodynamics/read_CSIRO.py ./modules-data/kopp14_sterodynamics_data.tgz ./modules/kopp14/sterodynamics/readMarzeion.py ./modules/kopp14/sterodynamics/IncludeModels.py ./modules/kopp14/sterodynamics/IncludeDABZOSModels.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf kopp14_sterodynamics_data.tgz 2> /dev/null; rm kopp14_sterodynamics_data.tgz
pip install --upgrade pip; pip install numpy scipy netCDF4 pyyaml h5py
python3 kopp14_oceandynamics_preprocess.py --scenario rcp85 --baseyear 2005 --pyear_start 2020 --pyear_end 2100 --pyear_step 10 --pipeline_id ar5k14.rcp85.k14sterodynamics.kopp14.sterodynamics


# ---- Stage fit:

cd $BASEDIR
cp ./modules/kopp14/sterodynamics/kopp14_oceandynamics_fit.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 kopp14_oceandynamics_fit.py --pipeline_id ar5k14.rcp85.k14sterodynamics.kopp14.sterodynamics


# ---- Stage project:

cd $BASEDIR
cp ./modules/kopp14/sterodynamics/kopp14_oceandynamics_project.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 kopp14_oceandynamics_project.py --pipeline_id ar5k14.rcp85.k14sterodynamics.kopp14.sterodynamics --nsamps 2000

cp ar5k14.rcp85.k14sterodynamics.kopp14.sterodynamics_globalsl.nc $OUTPUTDIR

# ---- Stage postprocess:

cd $BASEDIR
cp ./modules/kopp14/sterodynamics/kopp14_oceandynamics_postprocess.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 kopp14_oceandynamics_postprocess.py --nsamps 2000 --pipeline_id ar5k14.rcp85.k14sterodynamics.kopp14.sterodynamics

cp ar5k14.rcp85.k14sterodynamics.kopp14.sterodynamics_localsl.nc $OUTPUTDIR

# - Pipeline ar5k14.rcp85.k14lws.kopp14.landwaterstorage:


PIPELINEDIR=$WORKDIR/ar5k14.rcp85.k14lws.kopp14.landwaterstorage
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/ar5k14.rcp85/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp ./modules-data/kopp14_landwaterstorage_preprocess_data.tgz ./modules/kopp14/landwaterstorage/kopp14_landwaterstorage_preprocess.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf kopp14_landwaterstorage_preprocess_data.tgz 2> /dev/null; rm kopp14_landwaterstorage_preprocess_data.tgz
pip install --upgrade pip; pip install numpy scipy netCDF4 pyyaml matplotlib
python3 kopp14_landwaterstorage_preprocess.py --baseyear 2005 --pyear_start 2020 --pyear_end 2100 --pyear_step 10 --pipeline_id ar5k14.rcp85.k14lws.kopp14.landwaterstorage


# ---- Stage fit:

cd $BASEDIR
cp ./modules/kopp14/landwaterstorage/kopp14_landwaterstorage_fit.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 kopp14_landwaterstorage_fit.py --pipeline_id ar5k14.rcp85.k14lws.kopp14.landwaterstorage


# ---- Stage project:

cd $BASEDIR
cp ./modules/kopp14/landwaterstorage/kopp14_landwaterstorage_project.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 kopp14_landwaterstorage_project.py --nsamps 2000 --pipeline_id ar5k14.rcp85.k14lws.kopp14.landwaterstorage

cp ar5k14.rcp85.k14lws.kopp14.landwaterstorage_globalsl.nc $OUTPUTDIR

# ---- Stage postprocess:

cd $BASEDIR
cp ./modules/kopp14/landwaterstorage/kopp14_landwaterstorage_postprocess.py ./modules/kopp14/landwaterstorage/read_locationfile.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 kopp14_landwaterstorage_postprocess.py --pipeline_id ar5k14.rcp85.k14lws.kopp14.landwaterstorage

cp ar5k14.rcp85.k14lws.kopp14.landwaterstorage_localsl.nc $OUTPUTDIR

# - Pipeline ar5k14.rcp85.k14vlm.kopp14.verticallandmotion:


PIPELINEDIR=$WORKDIR/ar5k14.rcp85.k14vlm.kopp14.verticallandmotion
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/ar5k14.rcp85/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp ./modules-data/kopp14_verticallandmotion_preprocess_data.tgz ./modules/kopp14/verticallandmotion/kopp14_verticallandmotion_preprocess.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf kopp14_verticallandmotion_preprocess_data.tgz 2> /dev/null; rm kopp14_verticallandmotion_preprocess_data.tgz
pip install --upgrade pip; pip install numpy scipy netCDF4 pyyaml
python3 kopp14_verticallandmotion_preprocess.py --pipeline_id ar5k14.rcp85.k14vlm.kopp14.verticallandmotion


# ---- Stage fit:

cd $BASEDIR
cp ./modules/kopp14/verticallandmotion/kopp14_verticallandmotion_fit.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 kopp14_verticallandmotion_fit.py --pipeline_id ar5k14.rcp85.k14vlm.kopp14.verticallandmotion


# ---- Stage project:

cd $BASEDIR
cp ./modules/kopp14/verticallandmotion/kopp14_verticallandmotion_project.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 kopp14_verticallandmotion_project.py --pipeline_id ar5k14.rcp85.k14vlm.kopp14.verticallandmotion


# ---- Stage postprocess:

cd $BASEDIR
cp ./modules/kopp14/verticallandmotion/kopp14_verticallandmotion_postprocess.py ./modules/kopp14/verticallandmotion/read_locationfile.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 kopp14_verticallandmotion_postprocess.py --nsamps 2000 --baseyear 2005 --pyear_start 2020 --pyear_end 2100 --pyear_step 10 --pipeline_id ar5k14.rcp85.k14vlm.kopp14.verticallandmotion

cp ar5k14.rcp85.k14vlm.kopp14.verticallandmotion_localsl.nc $OUTPUTDIR

# - Pipeline ar5k14.rcp85.deconto16.deconto16.AIS:


PIPELINEDIR=$WORKDIR/ar5k14.rcp85.deconto16.deconto16.AIS
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/ar5k14.rcp85/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp ./modules/deconto16/AIS/deconto16_AIS_preprocess.py ./modules-data/deconto16_AIS_preprocess_data.tgz $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf deconto16_AIS_preprocess_data.tgz 2> /dev/null; rm deconto16_AIS_preprocess_data.tgz
pip install --upgrade pip; pip install numpy scipy netCDF4 pyyaml matplotlib
python3 deconto16_AIS_preprocess.py --scenario rcp85 --pipeline_id ar5k14.rcp85.deconto16.deconto16.AIS --baseyear 2005


# ---- Stage fit:

cd $BASEDIR
cp ./modules/deconto16/AIS/deconto16_AIS_fit.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 deconto16_AIS_fit.py --pipeline_id ar5k14.rcp85.deconto16.deconto16.AIS


# ---- Stage project:

cd $BASEDIR
cp ./modules/deconto16/AIS/deconto16_AIS_project.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 deconto16_AIS_project.py --nsamps 2000 --pyear_start 2020 --pyear_end 2100 --pyear_step 10 --pipeline_id ar5k14.rcp85.deconto16.deconto16.AIS

cp ar5k14.rcp85.deconto16.deconto16.AIS_WAIS_globalsl.nc $OUTPUTDIR
cp ar5k14.rcp85.deconto16.deconto16.AIS_AIS_globalsl.nc $OUTPUTDIR
cp ar5k14.rcp85.deconto16.deconto16.AIS_EAIS_globalsl.nc $OUTPUTDIR

# ---- Stage postprocess:

cd $BASEDIR
cp ./modules/deconto16/AIS/deconto16_AIS_postprocess.py ./modules/deconto16/AIS/read_locationfile.py ./modules/deconto16/AIS/AssignFP.py ./modules-data/grd_fingerprints_data.tgz ./modules/deconto16/AIS/ReadFingerprint.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf grd_fingerprints_data.tgz 2> /dev/null; rm grd_fingerprints_data.tgz
python3 deconto16_AIS_postprocess.py --pipeline_id ar5k14.rcp85.deconto16.deconto16.AIS

cp ar5k14.rcp85.deconto16.deconto16.AIS_AIS_localsl.nc $OUTPUTDIR
cp ar5k14.rcp85.deconto16.deconto16.AIS_EAIS_localsl.nc $OUTPUTDIR
cp ar5k14.rcp85.deconto16.deconto16.AIS_WAIS_localsl.nc $OUTPUTDIR

#EXPERIMENT STEP:  totaling_step 


# - Pipeline ar5k14.rcp85.total.facts.total.ar5.global:


PIPELINEDIR=$WORKDIR/ar5k14.rcp85.total.facts.total.ar5.global
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/ar5k14.rcp85/location.lst $PIPELINEDIR

# ---- Stage workflow:

cd $BASEDIR
cp ./modules/facts/total/total_workflow.py experiments/ar5k14.rcp85/workflows.yml $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
pip install --upgrade pip; pip install numpy netCDF4 pyyaml dask[array]
python3 total_workflow.py --directory $RP_PILOT_SANDBOX/to_total --workflows workflows.yml --workflow ar5 --scale global --experiment_name ar5k14.rcp85 --pyear_start 2020 --pyear_end 2100 --pyear_step 10

cp ar5k14.rcp85.total.workflow.ar5.global.nc $OUTPUTDIR

# - Pipeline ar5k14.rcp85.total.facts.total.ar5.local:


PIPELINEDIR=$WORKDIR/ar5k14.rcp85.total.facts.total.ar5.local
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/ar5k14.rcp85/location.lst $PIPELINEDIR

# ---- Stage workflow:

cd $BASEDIR
cp ./modules/facts/total/total_workflow.py experiments/ar5k14.rcp85/workflows.yml $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
pip install --upgrade pip; pip install numpy netCDF4 pyyaml dask[array]
python3 total_workflow.py --directory $RP_PILOT_SANDBOX/to_total --workflows workflows.yml --workflow ar5 --scale local --experiment_name ar5k14.rcp85 --pyear_start 2020 --pyear_end 2100 --pyear_step 10

cp ar5k14.rcp85.total.workflow.ar5.local.nc $OUTPUTDIR

# - Pipeline ar5k14.rcp85.total.facts.total.k14.global:


PIPELINEDIR=$WORKDIR/ar5k14.rcp85.total.facts.total.k14.global
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/ar5k14.rcp85/location.lst $PIPELINEDIR

# ---- Stage workflow:

cd $BASEDIR
cp ./modules/facts/total/total_workflow.py experiments/ar5k14.rcp85/workflows.yml $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
pip install --upgrade pip; pip install numpy netCDF4 pyyaml dask[array]
python3 total_workflow.py --directory $RP_PILOT_SANDBOX/to_total --workflows workflows.yml --workflow k14 --scale global --experiment_name ar5k14.rcp85 --pyear_start 2020 --pyear_end 2100 --pyear_step 10

cp ar5k14.rcp85.total.workflow.k14.global.nc $OUTPUTDIR

# - Pipeline ar5k14.rcp85.total.facts.total.k14.local:


PIPELINEDIR=$WORKDIR/ar5k14.rcp85.total.facts.total.k14.local
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/ar5k14.rcp85/location.lst $PIPELINEDIR

# ---- Stage workflow:

cd $BASEDIR
cp ./modules/facts/total/total_workflow.py experiments/ar5k14.rcp85/workflows.yml $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
pip install --upgrade pip; pip install numpy netCDF4 pyyaml dask[array]
python3 total_workflow.py --directory $RP_PILOT_SANDBOX/to_total --workflows workflows.yml --workflow k14 --scale local --experiment_name ar5k14.rcp85 --pyear_start 2020 --pyear_end 2100 --pyear_step 10

cp ar5k14.rcp85.total.workflow.k14.local.nc $OUTPUTDIR
