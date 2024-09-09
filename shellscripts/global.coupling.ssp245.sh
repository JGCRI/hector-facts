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


# - Pipeline global.coupling.ssp245.temperature.fair.temperature:


PIPELINEDIR=$WORKDIR/global.coupling.ssp245.temperature.fair.temperature
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/global.coupling.ssp245/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp ./modules-data/fair_temperature_preprocess_data.tgz ./modules/fair/temperature/fair_temperature_preprocess.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf fair_temperature_preprocess_data.tgz 2> /dev/null; rm fair_temperature_preprocess_data.tgz
pip install --upgrade pip; pip install numpy scipy netCDF4 pyyaml matplotlib pandas xarray dask fair==1.6.4
python3 fair_temperature_preprocess.py --scenario ssp245 --pipeline_id global.coupling.ssp245.temperature.fair.temperature


# ---- Stage fit:

cd $BASEDIR
cp ./modules-data/fair_temperature_fit_data.tgz ./modules/fair/temperature/fair_temperature_fit.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf fair_temperature_fit_data.tgz 2> /dev/null; rm fair_temperature_fit_data.tgz
python3 fair_temperature_fit.py --pipeline_id global.coupling.ssp245.temperature.fair.temperature


# ---- Stage project:

cd $BASEDIR
cp ./modules/fair/temperature/my_FAIR_forward.py ./modules/fair/temperature/fair_temperature_project.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 fair_temperature_project.py --pipeline_id global.coupling.ssp245.temperature.fair.temperature --nsamps 2000

cp global.coupling.ssp245.temperature.fair.temperature_climate.nc $OUTPUTDIR
cp global.coupling.ssp245.temperature.fair.temperature_ohc.nc $OUTPUTDIR
cp global.coupling.ssp245.temperature.fair.temperature_oceantemp.nc $OUTPUTDIR
cp global.coupling.ssp245.temperature.fair.temperature_gsat.nc $OUTPUTDIR

#EXPERIMENT STEP:  sealevel_step 


# - Pipeline global.coupling.ssp245.GrIS1f.FittedISMIP.GrIS:


PIPELINEDIR=$WORKDIR/global.coupling.ssp245.GrIS1f.FittedISMIP.GrIS
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/global.coupling.ssp245/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp ./modules/FittedISMIP/GrIS/Import2lmData.py ./modules/FittedISMIP/GrIS/FittedISMIP_GrIS_preprocess.py ./modules/FittedISMIP/GrIS/filter_temp_data.py ./modules/FittedISMIP/GrIS/import_temp_data.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
pip install --upgrade pip; pip install numpy scipy netCDF4 pyyaml matplotlib h5py xarray dask[array]
python3 FittedISMIP_GrIS_preprocess.py --climate_data_file $SHARED/climate/global.coupling.ssp245.temperature.fair.temperature_climate.nc --scenario ssp245 --pipeline_id global.coupling.ssp245.GrIS1f.FittedISMIP.GrIS


# ---- Stage fit:

cd $BASEDIR
cp ./modules-data/FittedISMIP_icesheet_fit_data.tgz ./modules/FittedISMIP/GrIS/FittedISMIP_GrIS_fit.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf FittedISMIP_icesheet_fit_data.tgz 2> /dev/null; rm FittedISMIP_icesheet_fit_data.tgz
python3 FittedISMIP_GrIS_fit.py --pipeline_id global.coupling.ssp245.GrIS1f.FittedISMIP.GrIS


# ---- Stage project:

cd $BASEDIR
cp ./modules/FittedISMIP/GrIS/FittedISMIP_GrIS_project.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 FittedISMIP_GrIS_project.py --nsamps 2000 --pyear_start 2020 --pyear_end 2150 --pyear_step 10 --baseyear 2005 --pipeline_id global.coupling.ssp245.GrIS1f.FittedISMIP.GrIS

cp global.coupling.ssp245.GrIS1f.FittedISMIP.GrIS_GIS_globalsl.nc $OUTPUTDIR

# - Pipeline global.coupling.ssp245.deconto21.deconto21.AIS:


PIPELINEDIR=$WORKDIR/global.coupling.ssp245.deconto21.deconto21.AIS
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/global.coupling.ssp245/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp ./modules/deconto21/AIS/deconto21_AIS_preprocess.py ./modules-data/deconto21_AIS_preprocess_data.tgz $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf deconto21_AIS_preprocess_data.tgz 2> /dev/null; rm deconto21_AIS_preprocess_data.tgz
pip install --upgrade pip; pip install numpy scipy netCDF4 pyyaml matplotlib xarray dask h5py
python3 deconto21_AIS_preprocess.py --scenario ssp245 --pipeline_id global.coupling.ssp245.deconto21.deconto21.AIS --baseyear 2005 --climate_data_file $SHARED/climate/global.coupling.ssp245.temperature.fair.temperature_climate.nc


# ---- Stage fit:

cd $BASEDIR
cp ./modules/deconto21/AIS/deconto21_AIS_fit.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 deconto21_AIS_fit.py --pipeline_id global.coupling.ssp245.deconto21.deconto21.AIS


# ---- Stage project:

cd $BASEDIR
cp ./modules/deconto21/AIS/deconto21_AIS_project.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 deconto21_AIS_project.py --nsamps 2000 --pyear_start 2020 --pyear_end 2150 --pyear_step 10 --pipeline_id global.coupling.ssp245.deconto21.deconto21.AIS --climate_data_file $SHARED/climate/global.coupling.ssp245.temperature.fair.temperature_climate.nc

cp global.coupling.ssp245.deconto21.deconto21.AIS_EAIS_globalsl.nc $OUTPUTDIR
cp global.coupling.ssp245.deconto21.deconto21.AIS_AIS_globalsl.nc $OUTPUTDIR
cp global.coupling.ssp245.deconto21.deconto21.AIS_WAIS_globalsl.nc $OUTPUTDIR

# - Pipeline global.coupling.ssp245.bamber19.bamber19.icesheets:


PIPELINEDIR=$WORKDIR/global.coupling.ssp245.bamber19.bamber19.icesheets
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/global.coupling.ssp245/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp ./modules/bamber19/icesheets/bamber19_icesheets_preprocess.py ./modules-data/bamber19_icesheets_preprocess_data.tgz $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf bamber19_icesheets_preprocess_data.tgz 2> /dev/null; rm bamber19_icesheets_preprocess_data.tgz
pip install --upgrade pip; pip install numpy scipy netCDF4 pyyaml matplotlib h5py
python3 bamber19_icesheets_preprocess.py --pipeline_id global.coupling.ssp245.bamber19.bamber19.icesheets --pyear_start 2020 --pyear_end 2150 --pyear_step 10 --scenario ssp245 --baseyear 2005 --climate_data_file $SHARED/climate/global.coupling.ssp245.temperature.fair.temperature_climate.nc


# ---- Stage fit:

cd $BASEDIR
cp ./modules/bamber19/icesheets/bamber19_icesheets_fit.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 bamber19_icesheets_fit.py --pipeline_id global.coupling.ssp245.bamber19.bamber19.icesheets


# ---- Stage project:

cd $BASEDIR
cp ./modules/bamber19/icesheets/bamber19_icesheets_project.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 bamber19_icesheets_project.py --nsamps 2000 --pipeline_id global.coupling.ssp245.bamber19.bamber19.icesheets --climate_data_file $SHARED/climate/global.coupling.ssp245.temperature.fair.temperature_climate.nc

cp global.coupling.ssp245.bamber19.bamber19.icesheets_EAIS_globalsl.nc $OUTPUTDIR
cp global.coupling.ssp245.bamber19.bamber19.icesheets_WAIS_globalsl.nc $OUTPUTDIR
cp global.coupling.ssp245.bamber19.bamber19.icesheets_GIS_globalsl.nc $OUTPUTDIR
cp global.coupling.ssp245.bamber19.bamber19.icesheets_AIS_globalsl.nc $OUTPUTDIR

# - Pipeline global.coupling.ssp245.emuAIS.emulandice.AIS:


PIPELINEDIR=$WORKDIR/global.coupling.ssp245.emuAIS.emulandice.AIS
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/global.coupling.ssp245/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp ./modules/emulandice/AIS/../shared/emulandice_preprocess.py ./modules/emulandice/AIS/../shared/FACTS_CLIMATE_FORCING.csv.head $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
pip install --upgrade pip; pip install numpy scipy netCDF4 pyyaml matplotlib xarray dask
python3 emulandice_preprocess.py --input_data_file $SHARED/climate/global.coupling.ssp245.temperature.fair.temperature_gsat.nc --baseyear 2005 --pipeline_id global.coupling.ssp245.emuAIS.emulandice.AIS


# ---- Stage fit:

cd $BASEDIR
cp ./modules/emulandice/AIS/emulandice_AIS_fit.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 emulandice_AIS_fit.py --pipeline_id global.coupling.ssp245.emuAIS.emulandice.AIS


# ---- Stage project:

cd $BASEDIR
cp ./modules/emulandice/AIS/emulandice_AIS_project.py ./modules/emulandice/AIS/../shared/emulandice_bundled_dependencies.tgz ./modules/emulandice/AIS/../shared/emulandice_environment.sh ./modules/emulandice/AIS/../shared/emulandice_steer.sh $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf emulandice_bundled_dependencies.tgz 2> /dev/null; rm emulandice_bundled_dependencies.tgz
python3 emulandice_AIS_project.py --pipeline_id global.coupling.ssp245.emuAIS.emulandice.AIS

cp global.coupling.ssp245.emuAIS.emulandice.AIS_EAIS_globalsl.nc $OUTPUTDIR
cp global.coupling.ssp245.emuAIS.emulandice.AIS_globalsl.nc $OUTPUTDIR
cp global.coupling.ssp245.emuAIS.emulandice.AIS_WAIS_globalsl.nc $OUTPUTDIR
cp global.coupling.ssp245.emuAIS.emulandice.AIS_PEN_globalsl.nc $OUTPUTDIR

# - Pipeline global.coupling.ssp245.emuGrIS.emulandice.GrIS:


PIPELINEDIR=$WORKDIR/global.coupling.ssp245.emuGrIS.emulandice.GrIS
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/global.coupling.ssp245/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp ./modules/emulandice/GrIS/../shared/emulandice_preprocess.py ./modules/emulandice/GrIS/../shared/FACTS_CLIMATE_FORCING.csv.head $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
pip install --upgrade pip; pip install numpy scipy netCDF4 pyyaml matplotlib xarray dask
python3 emulandice_preprocess.py --input_data_file $SHARED/climate/global.coupling.ssp245.temperature.fair.temperature_gsat.nc --baseyear 2005 --pipeline_id global.coupling.ssp245.emuGrIS.emulandice.GrIS


# ---- Stage fit:

cd $BASEDIR
cp ./modules/emulandice/GrIS/emulandice_GrIS_fit.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 emulandice_GrIS_fit.py --pipeline_id global.coupling.ssp245.emuGrIS.emulandice.GrIS


# ---- Stage project:

cd $BASEDIR
cp ./modules/emulandice/GrIS/../shared/emulandice_environment.sh ./modules/emulandice/GrIS/../shared/emulandice_steer.sh ./modules/emulandice/GrIS/../shared/emulandice_bundled_dependencies.tgz ./modules/emulandice/GrIS/emulandice_GrIS_project.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf emulandice_bundled_dependencies.tgz 2> /dev/null; rm emulandice_bundled_dependencies.tgz
python3 emulandice_GrIS_project.py --pipeline_id global.coupling.ssp245.emuGrIS.emulandice.GrIS

cp global.coupling.ssp245.emuGrIS.emulandice.GrIS_globalsl.nc $OUTPUTDIR

# - Pipeline global.coupling.ssp245.emuglaciers.emulandice.glaciers:


PIPELINEDIR=$WORKDIR/global.coupling.ssp245.emuglaciers.emulandice.glaciers
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/global.coupling.ssp245/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp ./modules/emulandice/glaciers/../shared/FACTS_CLIMATE_FORCING.csv.head ./modules/emulandice/glaciers/../shared/emulandice_preprocess.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
pip install --upgrade pip; pip install numpy scipy netCDF4 pyyaml matplotlib xarray dask
python3 emulandice_preprocess.py --input_data_file $SHARED/climate/global.coupling.ssp245.temperature.fair.temperature_gsat.nc --baseyear 2005 --pipeline_id global.coupling.ssp245.emuglaciers.emulandice.glaciers


# ---- Stage fit:

cd $BASEDIR
cp ./modules/emulandice/glaciers/emulandice_glaciers_fit.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 emulandice_glaciers_fit.py --pipeline_id global.coupling.ssp245.emuglaciers.emulandice.glaciers


# ---- Stage project:

cd $BASEDIR
cp ./modules/emulandice/glaciers/../shared/emulandice_environment.sh ./modules/emulandice/glaciers/../shared/emulandice_bundled_dependencies.tgz ./modules/emulandice/glaciers/../shared/emulandice_steer.sh ./modules/emulandice/glaciers/emulandice_glaciers_project.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf emulandice_bundled_dependencies.tgz 2> /dev/null; rm emulandice_bundled_dependencies.tgz
python3 emulandice_glaciers_project.py --pipeline_id global.coupling.ssp245.emuglaciers.emulandice.glaciers

cp global.coupling.ssp245.emuglaciers.emulandice.glaciers_glac18_globalsl.nc $OUTPUTDIR
cp global.coupling.ssp245.emuglaciers.emulandice.glaciers_glac13_globalsl.nc $OUTPUTDIR
cp global.coupling.ssp245.emuglaciers.emulandice.glaciers_glac19_globalsl.nc $OUTPUTDIR
cp global.coupling.ssp245.emuglaciers.emulandice.glaciers_glac15_globalsl.nc $OUTPUTDIR
cp global.coupling.ssp245.emuglaciers.emulandice.glaciers_globalsl.nc $OUTPUTDIR
cp global.coupling.ssp245.emuglaciers.emulandice.glaciers_glac8_globalsl.nc $OUTPUTDIR
cp global.coupling.ssp245.emuglaciers.emulandice.glaciers_glac14_globalsl.nc $OUTPUTDIR
cp global.coupling.ssp245.emuglaciers.emulandice.glaciers_glac5_globalsl.nc $OUTPUTDIR
cp global.coupling.ssp245.emuglaciers.emulandice.glaciers_glac6_globalsl.nc $OUTPUTDIR
cp global.coupling.ssp245.emuglaciers.emulandice.glaciers_glac11_globalsl.nc $OUTPUTDIR
cp global.coupling.ssp245.emuglaciers.emulandice.glaciers_glac10_globalsl.nc $OUTPUTDIR
cp global.coupling.ssp245.emuglaciers.emulandice.glaciers_glac16_globalsl.nc $OUTPUTDIR
cp global.coupling.ssp245.emuglaciers.emulandice.glaciers_glac7_globalsl.nc $OUTPUTDIR
cp global.coupling.ssp245.emuglaciers.emulandice.glaciers_glac17_globalsl.nc $OUTPUTDIR
cp global.coupling.ssp245.emuglaciers.emulandice.glaciers_glac2_globalsl.nc $OUTPUTDIR
cp global.coupling.ssp245.emuglaciers.emulandice.glaciers_glac9_globalsl.nc $OUTPUTDIR
cp global.coupling.ssp245.emuglaciers.emulandice.glaciers_glac12_globalsl.nc $OUTPUTDIR
cp global.coupling.ssp245.emuglaciers.emulandice.glaciers_glac4_globalsl.nc $OUTPUTDIR
cp global.coupling.ssp245.emuglaciers.emulandice.glaciers_glac1_globalsl.nc $OUTPUTDIR
cp global.coupling.ssp245.emuglaciers.emulandice.glaciers_glac3_globalsl.nc $OUTPUTDIR

# - Pipeline global.coupling.ssp245.larmip.larmip.AIS:


PIPELINEDIR=$WORKDIR/global.coupling.ssp245.larmip.larmip.AIS
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/global.coupling.ssp245/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp ./modules/larmip/AIS/larmip_icesheet_preprocess.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
pip install --upgrade pip; pip install numpy scipy netCDF4 pyyaml matplotlib h5py
python larmip_icesheet_preprocess.py --scenario ssp245 --pipeline_id global.coupling.ssp245.larmip.larmip.AIS --climate_data_file $SHARED/climate/global.coupling.ssp245.temperature.fair.temperature_climate.nc


# ---- Stage fit:

cd $BASEDIR
cp ./modules-data/larmip_icesheet_fit_data.tgz ./modules/larmip/AIS/larmip_icesheet_fit.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf larmip_icesheet_fit_data.tgz 2> /dev/null; rm larmip_icesheet_fit_data.tgz
python larmip_icesheet_fit.py --pipeline_id global.coupling.ssp245.larmip.larmip.AIS


# ---- Stage project:

cd $BASEDIR
cp ./modules/larmip/AIS/larmip_icesheet_project.py ./modules-data/larmip_icesheet_project_data.tgz $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf larmip_icesheet_project_data.tgz 2> /dev/null; rm larmip_icesheet_project_data.tgz
python larmip_icesheet_project.py --nsamps 2000 --baseyear 2005 --pyear_start 2020 --pyear_end 2150 --pyear_step 10 --pipeline_id global.coupling.ssp245.larmip.larmip.AIS

cp global.coupling.ssp245.larmip.larmip.AIS_WAIS_globalsl.nc $OUTPUTDIR
cp global.coupling.ssp245.larmip.larmip.AIS_EAIS_globalsl.nc $OUTPUTDIR
cp global.coupling.ssp245.larmip.larmip.AIS_SMB_globalsl.nc $OUTPUTDIR
cp global.coupling.ssp245.larmip.larmip.AIS_PEN_globalsl.nc $OUTPUTDIR
cp global.coupling.ssp245.larmip.larmip.AIS_globalsl.nc $OUTPUTDIR

# - Pipeline global.coupling.ssp245.ar5glaciers.ipccar5.glaciers:


PIPELINEDIR=$WORKDIR/global.coupling.ssp245.ar5glaciers.ipccar5.glaciers
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/global.coupling.ssp245/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp ./modules/ipccar5/glaciers/ipccar5_glaciers_preprocess.py ./modules/ipccar5/glaciers/Import2lmData.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
pip install --upgrade pip; pip install numpy scipy netCDF4 pyyaml matplotlib h5py
python3 ipccar5_glaciers_preprocess.py --scenario ssp245 --baseyear 2005 --pipeline_id global.coupling.ssp245.ar5glaciers.ipccar5.glaciers --climate_data_file $SHARED/climate/global.coupling.ssp245.temperature.fair.temperature_climate.nc


# ---- Stage fit:

cd $BASEDIR
cp ./modules/ipccar5/glaciers/ipccar5_glaciers_fit.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 ipccar5_glaciers_fit.py --pipeline_id global.coupling.ssp245.ar5glaciers.ipccar5.glaciers --gmip 2


# ---- Stage project:

cd $BASEDIR
cp ./modules-data/ipccar5_glaciers_project_data.tgz ./modules/ipccar5/glaciers/ipccar5_glaciers_project.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf ipccar5_glaciers_project_data.tgz 2> /dev/null; rm ipccar5_glaciers_project_data.tgz
python3 ipccar5_glaciers_project.py --nsamps 2000 --pyear_start 2020 --pyear_end 2150 --pyear_step 10 --pipeline_id global.coupling.ssp245.ar5glaciers.ipccar5.glaciers

cp global.coupling.ssp245.ar5glaciers.ipccar5.glaciers_globalsl.nc $OUTPUTDIR

# - Pipeline global.coupling.ssp245.ar5AIS.ipccar5.icesheets:


PIPELINEDIR=$WORKDIR/global.coupling.ssp245.ar5AIS.ipccar5.icesheets
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/global.coupling.ssp245/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp ./modules/ipccar5/icesheets/ipccar5_icesheets_preprocess.py ./modules/ipccar5/icesheets/Import2lmData.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
pip install --upgrade pip; pip install numpy scipy netCDF4 pyyaml matplotlib h5py
python3 ipccar5_icesheets_preprocess.py --scenario ssp245 --pipeline_id global.coupling.ssp245.ar5AIS.ipccar5.icesheets --baseyear 2005 --climate_data_file $SHARED/climate/global.coupling.ssp245.temperature.fair.temperature_climate.nc


# ---- Stage fit:

cd $BASEDIR
cp ./modules/ipccar5/icesheets/ipccar5_icesheets_fit.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 ipccar5_icesheets_fit.py --pipeline_id global.coupling.ssp245.ar5AIS.ipccar5.icesheets


# ---- Stage project:

cd $BASEDIR
cp ./modules-data/ipccar5_icesheets_project_data.tgz ./modules/ipccar5/icesheets/ipccar5_icesheets_project.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf ipccar5_icesheets_project_data.tgz 2> /dev/null; rm ipccar5_icesheets_project_data.tgz
python3 ipccar5_icesheets_project.py --nsamps 2000 --pyear_start 2020 --pyear_end 2150 --pyear_step 10 --pipeline_id global.coupling.ssp245.ar5AIS.ipccar5.icesheets

cp global.coupling.ssp245.ar5AIS.ipccar5.icesheets_WAIS_globalsl.nc $OUTPUTDIR
cp global.coupling.ssp245.ar5AIS.ipccar5.icesheets_EAIS_globalsl.nc $OUTPUTDIR
cp global.coupling.ssp245.ar5AIS.ipccar5.icesheets_AIS_globalsl.nc $OUTPUTDIR

# - Pipeline global.coupling.ssp245.ocean.tlm.sterodynamics:


PIPELINEDIR=$WORKDIR/global.coupling.ssp245.ocean.tlm.sterodynamics
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/global.coupling.ssp245/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp ./modules/tlm/sterodynamics/tlm_sterodynamics_preprocess_thermalexpansion.py ./modules/tlm/sterodynamics/Import2lmData.py ./modules-data/tlm_sterodynamics_preprocess_data.tgz $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf tlm_sterodynamics_preprocess_data.tgz 2> /dev/null; rm tlm_sterodynamics_preprocess_data.tgz
pip install --upgrade pip; pip install numpy scipy netCDF4 pyyaml h5py
python3 tlm_sterodynamics_preprocess_thermalexpansion.py --scenario ssp245 --climate_data_file $SHARED/climate/global.coupling.ssp245.temperature.fair.temperature_climate.nc --pipeline_id global.coupling.ssp245.ocean.tlm.sterodynamics


# ---- Stage fit:

cd $BASEDIR
cp ./modules/tlm/sterodynamics/tlm_sterodynamics_fit_thermalexpansion.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 tlm_sterodynamics_fit_thermalexpansion.py --pipeline_id global.coupling.ssp245.ocean.tlm.sterodynamics


# ---- Stage project:

cd $BASEDIR
cp ./modules/tlm/sterodynamics/tlm_sterodynamics_project.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 tlm_sterodynamics_project.py --pipeline_id global.coupling.ssp245.ocean.tlm.sterodynamics --nsamps 2000 --scenario ssp245 --baseyear 2005 --pyear_start 2020 --pyear_end 2150 --pyear_step 10

cp global.coupling.ssp245.ocean.tlm.sterodynamics_globalsl.nc $OUTPUTDIR

# - Pipeline global.coupling.ssp245.lws.ssp.landwaterstorage:


PIPELINEDIR=$WORKDIR/global.coupling.ssp245.lws.ssp.landwaterstorage
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/global.coupling.ssp245/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp ./modules/ssp/landwaterstorage/ssp_landwaterstorage_preprocess.py ./modules-data/ssp_landwaterstorage_preprocess_data.tgz $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf ssp_landwaterstorage_preprocess_data.tgz 2> /dev/null; rm ssp_landwaterstorage_preprocess_data.tgz
pip install --upgrade pip; pip install numpy scipy netCDF4 pyyaml matplotlib
python3 ssp_landwaterstorage_preprocess.py --scenario ssp2 --baseyear 2005 --pyear_start 2020 --pyear_end 2150 --pyear_step 10 --pipeline_id global.coupling.ssp245.lws.ssp.landwaterstorage


# ---- Stage fit:

cd $BASEDIR
cp ./modules/ssp/landwaterstorage/ssp_landwaterstorage_fit.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 ssp_landwaterstorage_fit.py --pipeline_id global.coupling.ssp245.lws.ssp.landwaterstorage


# ---- Stage project:

cd $BASEDIR
cp ./modules/ssp/landwaterstorage/ssp_landwaterstorage_project.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 ssp_landwaterstorage_project.py --pipeline_id global.coupling.ssp245.lws.ssp.landwaterstorage --nsamps 2000 --dcrate_lo -0.4

cp global.coupling.ssp245.lws.ssp.landwaterstorage_globalsl.nc $OUTPUTDIR

#EXPERIMENT STEP:  totaling_step 


# - Pipeline global.coupling.ssp245.total.facts.total.wf1f.global:


PIPELINEDIR=$WORKDIR/global.coupling.ssp245.total.facts.total.wf1f.global
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/global.coupling.ssp245/location.lst $PIPELINEDIR

# ---- Stage workflow:

cd $BASEDIR
cp experiments/global.coupling.ssp245/workflows.yml ./modules/facts/total/total_workflow.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
pip install --upgrade pip; pip install numpy netCDF4 pyyaml dask[array]
python3 total_workflow.py --directory $RP_PILOT_SANDBOX/to_total --workflows workflows.yml --workflow wf1f --scale global --experiment_name global.coupling.ssp245 --pyear_start 2020 --pyear_end 2150 --pyear_step 10

cp global.coupling.ssp245.total.workflow.wf1f.global.nc $OUTPUTDIR

# - Pipeline global.coupling.ssp245.total.facts.total.wf2f.global:


PIPELINEDIR=$WORKDIR/global.coupling.ssp245.total.facts.total.wf2f.global
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/global.coupling.ssp245/location.lst $PIPELINEDIR

# ---- Stage workflow:

cd $BASEDIR
cp experiments/global.coupling.ssp245/workflows.yml ./modules/facts/total/total_workflow.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
pip install --upgrade pip; pip install numpy netCDF4 pyyaml dask[array]
python3 total_workflow.py --directory $RP_PILOT_SANDBOX/to_total --workflows workflows.yml --workflow wf2f --scale global --experiment_name global.coupling.ssp245 --pyear_start 2020 --pyear_end 2150 --pyear_step 10

cp global.coupling.ssp245.total.workflow.wf2f.global.nc $OUTPUTDIR

# - Pipeline global.coupling.ssp245.total.facts.total.wf3f.global:


PIPELINEDIR=$WORKDIR/global.coupling.ssp245.total.facts.total.wf3f.global
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/global.coupling.ssp245/location.lst $PIPELINEDIR

# ---- Stage workflow:

cd $BASEDIR
cp experiments/global.coupling.ssp245/workflows.yml ./modules/facts/total/total_workflow.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
pip install --upgrade pip; pip install numpy netCDF4 pyyaml dask[array]
python3 total_workflow.py --directory $RP_PILOT_SANDBOX/to_total --workflows workflows.yml --workflow wf3f --scale global --experiment_name global.coupling.ssp245 --pyear_start 2020 --pyear_end 2150 --pyear_step 10

cp global.coupling.ssp245.total.workflow.wf3f.global.nc $OUTPUTDIR

# - Pipeline global.coupling.ssp245.total.facts.total.wf3e.global:


PIPELINEDIR=$WORKDIR/global.coupling.ssp245.total.facts.total.wf3e.global
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/global.coupling.ssp245/location.lst $PIPELINEDIR

# ---- Stage workflow:

cd $BASEDIR
cp experiments/global.coupling.ssp245/workflows.yml ./modules/facts/total/total_workflow.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
pip install --upgrade pip; pip install numpy netCDF4 pyyaml dask[array]
python3 total_workflow.py --directory $RP_PILOT_SANDBOX/to_total --workflows workflows.yml --workflow wf3e --scale global --experiment_name global.coupling.ssp245 --pyear_start 2020 --pyear_end 2100 --pyear_step 10

cp global.coupling.ssp245.total.workflow.wf3e.global.nc $OUTPUTDIR

# - Pipeline global.coupling.ssp245.total.facts.total.wf4.global:


PIPELINEDIR=$WORKDIR/global.coupling.ssp245.total.facts.total.wf4.global
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/global.coupling.ssp245/location.lst $PIPELINEDIR

# ---- Stage workflow:

cd $BASEDIR
cp experiments/global.coupling.ssp245/workflows.yml ./modules/facts/total/total_workflow.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
pip install --upgrade pip; pip install numpy netCDF4 pyyaml dask[array]
python3 total_workflow.py --directory $RP_PILOT_SANDBOX/to_total --workflows workflows.yml --workflow wf4 --scale global --experiment_name global.coupling.ssp245 --pyear_start 2020 --pyear_end 2150 --pyear_step 10

cp global.coupling.ssp245.total.workflow.wf4.global.nc $OUTPUTDIR

# - Pipeline global.coupling.ssp245.total.facts.total.wf1e.global:


PIPELINEDIR=$WORKDIR/global.coupling.ssp245.total.facts.total.wf1e.global
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/global.coupling.ssp245/location.lst $PIPELINEDIR

# ---- Stage workflow:

cd $BASEDIR
cp experiments/global.coupling.ssp245/workflows.yml ./modules/facts/total/total_workflow.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
pip install --upgrade pip; pip install numpy netCDF4 pyyaml dask[array]
python3 total_workflow.py --directory $RP_PILOT_SANDBOX/to_total --workflows workflows.yml --workflow wf1e --scale global --experiment_name global.coupling.ssp245 --pyear_start 2020 --pyear_end 2100 --pyear_step 10

cp global.coupling.ssp245.total.workflow.wf1e.global.nc $OUTPUTDIR

# - Pipeline global.coupling.ssp245.total.facts.total.wf2e.global:


PIPELINEDIR=$WORKDIR/global.coupling.ssp245.total.facts.total.wf2e.global
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/global.coupling.ssp245/location.lst $PIPELINEDIR

# ---- Stage workflow:

cd $BASEDIR
cp experiments/global.coupling.ssp245/workflows.yml ./modules/facts/total/total_workflow.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
pip install --upgrade pip; pip install numpy netCDF4 pyyaml dask[array]
python3 total_workflow.py --directory $RP_PILOT_SANDBOX/to_total --workflows workflows.yml --workflow wf2e --scale global --experiment_name global.coupling.ssp245 --pyear_start 2020 --pyear_end 2100 --pyear_step 10

cp global.coupling.ssp245.total.workflow.wf2e.global.nc $OUTPUTDIR
