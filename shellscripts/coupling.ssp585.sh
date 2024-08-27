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


# - Pipeline coupling.ssp585.temperature.fair.temperature:


PIPELINEDIR=$WORKDIR/coupling.ssp585.temperature.fair.temperature
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/coupling.ssp585/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp ./modules/fair/temperature/fair_temperature_preprocess.py ./modules-data/fair_temperature_preprocess_data.tgz $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf fair_temperature_preprocess_data.tgz 2> /dev/null; rm fair_temperature_preprocess_data.tgz
pip install --upgrade pip; pip install numpy scipy netCDF4 pyyaml matplotlib pandas xarray dask fair==1.6.4
python3 fair_temperature_preprocess.py --scenario ssp585 --pipeline_id coupling.ssp585.temperature.fair.temperature


# ---- Stage fit:

cd $BASEDIR
cp ./modules-data/fair_temperature_fit_data.tgz ./modules/fair/temperature/fair_temperature_fit.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf fair_temperature_fit_data.tgz 2> /dev/null; rm fair_temperature_fit_data.tgz
python3 fair_temperature_fit.py --pipeline_id coupling.ssp585.temperature.fair.temperature


# ---- Stage project:

cd $BASEDIR
cp ./modules/fair/temperature/fair_temperature_project.py ./modules/fair/temperature/my_FAIR_forward.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 fair_temperature_project.py --pipeline_id coupling.ssp585.temperature.fair.temperature --nsamps 2000

cp coupling.ssp585.temperature.fair.temperature_ohc.nc $OUTPUTDIR
cp coupling.ssp585.temperature.fair.temperature_climate.nc $OUTPUTDIR
cp coupling.ssp585.temperature.fair.temperature_oceantemp.nc $OUTPUTDIR
cp coupling.ssp585.temperature.fair.temperature_gsat.nc $OUTPUTDIR

# ---- Stage postprocess:

cd $BASEDIR
cp ./modules/fair/temperature/fair_temperature_postprocess.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 fair_temperature_postprocess.py --pipeline_id coupling.ssp585.temperature.fair.temperature


#EXPERIMENT STEP:  sealevel_step 


# - Pipeline coupling.ssp585.GrIS1f.FittedISMIP.GrIS:


PIPELINEDIR=$WORKDIR/coupling.ssp585.GrIS1f.FittedISMIP.GrIS
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/coupling.ssp585/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp ./modules/FittedISMIP/GrIS/filter_temp_data.py ./modules/FittedISMIP/GrIS/Import2lmData.py ./modules/FittedISMIP/GrIS/import_temp_data.py ./modules/FittedISMIP/GrIS/FittedISMIP_GrIS_preprocess.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
pip install --upgrade pip; pip install numpy scipy netCDF4 pyyaml matplotlib h5py xarray dask[array]
python3 FittedISMIP_GrIS_preprocess.py --climate_data_file $SHARED/climate/coupling.ssp585.temperature.fair.temperature_climate.nc --scenario ssp585 --pipeline_id coupling.ssp585.GrIS1f.FittedISMIP.GrIS


# ---- Stage fit:

cd $BASEDIR
cp ./modules/FittedISMIP/GrIS/FittedISMIP_GrIS_fit.py ./modules-data/FittedISMIP_icesheet_fit_data.tgz $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf FittedISMIP_icesheet_fit_data.tgz 2> /dev/null; rm FittedISMIP_icesheet_fit_data.tgz
python3 FittedISMIP_GrIS_fit.py --pipeline_id coupling.ssp585.GrIS1f.FittedISMIP.GrIS


# ---- Stage project:

cd $BASEDIR
cp ./modules/FittedISMIP/GrIS/FittedISMIP_GrIS_project.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 FittedISMIP_GrIS_project.py --nsamps 2000 --pyear_start 2020 --pyear_end 2150 --pyear_step 10 --baseyear 2005 --pipeline_id coupling.ssp585.GrIS1f.FittedISMIP.GrIS

cp coupling.ssp585.GrIS1f.FittedISMIP.GrIS_GIS_globalsl.nc $OUTPUTDIR

# ---- Stage postprocess:

cd $BASEDIR
cp ./modules/FittedISMIP/GrIS/ReadFingerprint.py ./modules-data/grd_fingerprints_data.tgz ./modules/FittedISMIP/GrIS/FittedISMIP_GrIS_postprocess.py ./modules/FittedISMIP/GrIS/AssignFP.py ./modules/FittedISMIP/GrIS/read_locationfile.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf grd_fingerprints_data.tgz 2> /dev/null; rm grd_fingerprints_data.tgz
python3 FittedISMIP_GrIS_postprocess.py --pipeline_id coupling.ssp585.GrIS1f.FittedISMIP.GrIS

cp coupling.ssp585.GrIS1f.FittedISMIP.GrIS_GIS_localsl.nc $OUTPUTDIR

# - Pipeline coupling.ssp585.deconto21.deconto21.AIS:


PIPELINEDIR=$WORKDIR/coupling.ssp585.deconto21.deconto21.AIS
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/coupling.ssp585/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp ./modules-data/deconto21_AIS_preprocess_data.tgz ./modules/deconto21/AIS/deconto21_AIS_preprocess.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf deconto21_AIS_preprocess_data.tgz 2> /dev/null; rm deconto21_AIS_preprocess_data.tgz
pip install --upgrade pip; pip install numpy scipy netCDF4 pyyaml matplotlib xarray dask h5py
python3 deconto21_AIS_preprocess.py --scenario ssp585 --pipeline_id coupling.ssp585.deconto21.deconto21.AIS --baseyear 2005 --climate_data_file $SHARED/climate/coupling.ssp585.temperature.fair.temperature_climate.nc


# ---- Stage fit:

cd $BASEDIR
cp ./modules/deconto21/AIS/deconto21_AIS_fit.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 deconto21_AIS_fit.py --pipeline_id coupling.ssp585.deconto21.deconto21.AIS


# ---- Stage project:

cd $BASEDIR
cp ./modules/deconto21/AIS/deconto21_AIS_project.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 deconto21_AIS_project.py --nsamps 2000 --pyear_start 2020 --pyear_end 2150 --pyear_step 10 --pipeline_id coupling.ssp585.deconto21.deconto21.AIS --climate_data_file $SHARED/climate/coupling.ssp585.temperature.fair.temperature_climate.nc

cp coupling.ssp585.deconto21.deconto21.AIS_EAIS_globalsl.nc $OUTPUTDIR
cp coupling.ssp585.deconto21.deconto21.AIS_WAIS_globalsl.nc $OUTPUTDIR
cp coupling.ssp585.deconto21.deconto21.AIS_AIS_globalsl.nc $OUTPUTDIR

# ---- Stage postprocess:

cd $BASEDIR
cp ./modules-data/grd_fingerprints_data.tgz ./modules/deconto21/AIS/ReadFingerprint.py ./modules/deconto21/AIS/deconto21_AIS_postprocess.py ./modules/deconto21/AIS/read_locationfile.py ./modules/deconto21/AIS/AssignFP.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf grd_fingerprints_data.tgz 2> /dev/null; rm grd_fingerprints_data.tgz
python3 deconto21_AIS_postprocess.py --pipeline_id coupling.ssp585.deconto21.deconto21.AIS

cp coupling.ssp585.deconto21.deconto21.AIS_AIS_localsl.nc $OUTPUTDIR
cp coupling.ssp585.deconto21.deconto21.AIS_EAIS_localsl.nc $OUTPUTDIR
cp coupling.ssp585.deconto21.deconto21.AIS_WAIS_localsl.nc $OUTPUTDIR

# - Pipeline coupling.ssp585.bamber19.bamber19.icesheets:


PIPELINEDIR=$WORKDIR/coupling.ssp585.bamber19.bamber19.icesheets
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/coupling.ssp585/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp ./modules/bamber19/icesheets/bamber19_icesheets_preprocess.py ./modules-data/bamber19_icesheets_preprocess_data.tgz $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf bamber19_icesheets_preprocess_data.tgz 2> /dev/null; rm bamber19_icesheets_preprocess_data.tgz
pip install --upgrade pip; pip install numpy scipy netCDF4 pyyaml matplotlib h5py
python3 bamber19_icesheets_preprocess.py --pipeline_id coupling.ssp585.bamber19.bamber19.icesheets --pyear_start 2020 --pyear_end 2150 --pyear_step 10 --scenario ssp585 --baseyear 2005 --climate_data_file $SHARED/climate/coupling.ssp585.temperature.fair.temperature_climate.nc


# ---- Stage fit:

cd $BASEDIR
cp ./modules/bamber19/icesheets/bamber19_icesheets_fit.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 bamber19_icesheets_fit.py --pipeline_id coupling.ssp585.bamber19.bamber19.icesheets


# ---- Stage project:

cd $BASEDIR
cp ./modules/bamber19/icesheets/bamber19_icesheets_project.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 bamber19_icesheets_project.py --nsamps 2000 --pipeline_id coupling.ssp585.bamber19.bamber19.icesheets --climate_data_file $SHARED/climate/coupling.ssp585.temperature.fair.temperature_climate.nc

cp coupling.ssp585.bamber19.bamber19.icesheets_GIS_globalsl.nc $OUTPUTDIR
cp coupling.ssp585.bamber19.bamber19.icesheets_WAIS_globalsl.nc $OUTPUTDIR
cp coupling.ssp585.bamber19.bamber19.icesheets_AIS_globalsl.nc $OUTPUTDIR
cp coupling.ssp585.bamber19.bamber19.icesheets_EAIS_globalsl.nc $OUTPUTDIR

# ---- Stage postprocess:

cd $BASEDIR
cp ./modules-data/grd_fingerprints_data.tgz ./modules/bamber19/icesheets/AssignFP.py ./modules/bamber19/icesheets/read_locationfile.py ./modules/bamber19/icesheets/bamber19_icesheets_postprocess.py ./modules/bamber19/icesheets/ReadFingerprint.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf grd_fingerprints_data.tgz 2> /dev/null; rm grd_fingerprints_data.tgz
python3 bamber19_icesheets_postprocess.py --pipeline_id coupling.ssp585.bamber19.bamber19.icesheets

cp coupling.ssp585.bamber19.bamber19.icesheets_EAIS_localsl.nc $OUTPUTDIR
cp coupling.ssp585.bamber19.bamber19.icesheets_AIS_localsl.nc $OUTPUTDIR
cp coupling.ssp585.bamber19.bamber19.icesheets_WAIS_localsl.nc $OUTPUTDIR
cp coupling.ssp585.bamber19.bamber19.icesheets_GIS_localsl.nc $OUTPUTDIR

# - Pipeline coupling.ssp585.emuAIS.emulandice.AIS:


PIPELINEDIR=$WORKDIR/coupling.ssp585.emuAIS.emulandice.AIS
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/coupling.ssp585/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp ./modules/emulandice/AIS/../shared/emulandice_preprocess.py ./modules/emulandice/AIS/../shared/FACTS_CLIMATE_FORCING.csv.head $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
pip install --upgrade pip; pip install numpy scipy netCDF4 pyyaml matplotlib xarray dask
python3 emulandice_preprocess.py --input_data_file $SHARED/climate/coupling.ssp585.temperature.fair.temperature_gsat.nc --baseyear 2005 --pipeline_id coupling.ssp585.emuAIS.emulandice.AIS


# ---- Stage fit:

cd $BASEDIR
cp ./modules/emulandice/AIS/emulandice_AIS_fit.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 emulandice_AIS_fit.py --pipeline_id coupling.ssp585.emuAIS.emulandice.AIS


# ---- Stage project:

cd $BASEDIR
cp ./modules/emulandice/AIS/../shared/emulandice_environment.sh ./modules/emulandice/AIS/../shared/emulandice_bundled_dependencies.tgz ./modules/emulandice/AIS/emulandice_AIS_project.py ./modules/emulandice/AIS/../shared/emulandice_steer.sh $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf emulandice_bundled_dependencies.tgz 2> /dev/null; rm emulandice_bundled_dependencies.tgz
python3 emulandice_AIS_project.py --pipeline_id coupling.ssp585.emuAIS.emulandice.AIS

cp coupling.ssp585.emuAIS.emulandice.AIS_WAIS_globalsl.nc $OUTPUTDIR
cp coupling.ssp585.emuAIS.emulandice.AIS_globalsl.nc $OUTPUTDIR
cp coupling.ssp585.emuAIS.emulandice.AIS_PEN_globalsl.nc $OUTPUTDIR
cp coupling.ssp585.emuAIS.emulandice.AIS_EAIS_globalsl.nc $OUTPUTDIR

# ---- Stage postprocess:

cd $BASEDIR
cp ./modules-data/grd_fingerprints_data.tgz ./modules/emulandice/AIS/ReadFingerprint.py ./modules/emulandice/AIS/AssignFP.py ./modules/emulandice/AIS/emulandice_AIS_postprocess.py ./modules/emulandice/AIS/read_locationfile.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf grd_fingerprints_data.tgz 2> /dev/null; rm grd_fingerprints_data.tgz
python3 emulandice_AIS_postprocess.py --pipeline_id coupling.ssp585.emuAIS.emulandice.AIS

cp coupling.ssp585.emuAIS.emulandice.AIS_EAIS_localsl.nc $OUTPUTDIR
cp coupling.ssp585.emuAIS.emulandice.AIS_WAIS_localsl.nc $OUTPUTDIR
cp coupling.ssp585.emuAIS.emulandice.AIS_localsl.nc $OUTPUTDIR

# - Pipeline coupling.ssp585.emuGrIS.emulandice.GrIS:


PIPELINEDIR=$WORKDIR/coupling.ssp585.emuGrIS.emulandice.GrIS
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/coupling.ssp585/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp ./modules/emulandice/GrIS/../shared/FACTS_CLIMATE_FORCING.csv.head ./modules/emulandice/GrIS/../shared/emulandice_preprocess.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
pip install --upgrade pip; pip install numpy scipy netCDF4 pyyaml matplotlib xarray dask
python3 emulandice_preprocess.py --input_data_file $SHARED/climate/coupling.ssp585.temperature.fair.temperature_gsat.nc --baseyear 2005 --pipeline_id coupling.ssp585.emuGrIS.emulandice.GrIS


# ---- Stage fit:

cd $BASEDIR
cp ./modules/emulandice/GrIS/emulandice_GrIS_fit.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 emulandice_GrIS_fit.py --pipeline_id coupling.ssp585.emuGrIS.emulandice.GrIS


# ---- Stage project:

cd $BASEDIR
cp ./modules/emulandice/GrIS/../shared/emulandice_bundled_dependencies.tgz ./modules/emulandice/GrIS/../shared/emulandice_environment.sh ./modules/emulandice/GrIS/../shared/emulandice_steer.sh ./modules/emulandice/GrIS/emulandice_GrIS_project.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf emulandice_bundled_dependencies.tgz 2> /dev/null; rm emulandice_bundled_dependencies.tgz
python3 emulandice_GrIS_project.py --pipeline_id coupling.ssp585.emuGrIS.emulandice.GrIS

cp coupling.ssp585.emuGrIS.emulandice.GrIS_globalsl.nc $OUTPUTDIR

# ---- Stage postprocess:

cd $BASEDIR
cp ./modules-data/grd_fingerprints_data.tgz ./modules/emulandice/GrIS/AssignFP.py ./modules/emulandice/GrIS/ReadFingerprint.py ./modules/emulandice/GrIS/emulandice_GrIS_postprocess.py ./modules/emulandice/GrIS/read_locationfile.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf grd_fingerprints_data.tgz 2> /dev/null; rm grd_fingerprints_data.tgz
python3 emulandice_GrIS_postprocess.py --pipeline_id coupling.ssp585.emuGrIS.emulandice.GrIS

cp coupling.ssp585.emuGrIS.emulandice.GrIS_localsl.nc $OUTPUTDIR

# - Pipeline coupling.ssp585.emuglaciers.emulandice.glaciers:


PIPELINEDIR=$WORKDIR/coupling.ssp585.emuglaciers.emulandice.glaciers
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/coupling.ssp585/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp ./modules/emulandice/glaciers/../shared/emulandice_preprocess.py ./modules/emulandice/glaciers/../shared/FACTS_CLIMATE_FORCING.csv.head $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
pip install --upgrade pip; pip install numpy scipy netCDF4 pyyaml matplotlib xarray dask
python3 emulandice_preprocess.py --input_data_file $SHARED/climate/coupling.ssp585.temperature.fair.temperature_gsat.nc --baseyear 2005 --pipeline_id coupling.ssp585.emuglaciers.emulandice.glaciers


# ---- Stage fit:

cd $BASEDIR
cp ./modules/emulandice/glaciers/emulandice_glaciers_fit.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 emulandice_glaciers_fit.py --pipeline_id coupling.ssp585.emuglaciers.emulandice.glaciers


# ---- Stage project:

cd $BASEDIR
cp ./modules/emulandice/glaciers/emulandice_glaciers_project.py ./modules/emulandice/glaciers/../shared/emulandice_environment.sh ./modules/emulandice/glaciers/../shared/emulandice_bundled_dependencies.tgz ./modules/emulandice/glaciers/../shared/emulandice_steer.sh $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf emulandice_bundled_dependencies.tgz 2> /dev/null; rm emulandice_bundled_dependencies.tgz
python3 emulandice_glaciers_project.py --pipeline_id coupling.ssp585.emuglaciers.emulandice.glaciers

cp coupling.ssp585.emuglaciers.emulandice.glaciers_glac11_globalsl.nc $OUTPUTDIR
cp coupling.ssp585.emuglaciers.emulandice.glaciers_glac17_globalsl.nc $OUTPUTDIR
cp coupling.ssp585.emuglaciers.emulandice.glaciers_glac4_globalsl.nc $OUTPUTDIR
cp coupling.ssp585.emuglaciers.emulandice.glaciers_glac14_globalsl.nc $OUTPUTDIR
cp coupling.ssp585.emuglaciers.emulandice.glaciers_glac10_globalsl.nc $OUTPUTDIR
cp coupling.ssp585.emuglaciers.emulandice.glaciers_glac15_globalsl.nc $OUTPUTDIR
cp coupling.ssp585.emuglaciers.emulandice.glaciers_glac8_globalsl.nc $OUTPUTDIR
cp coupling.ssp585.emuglaciers.emulandice.glaciers_glac13_globalsl.nc $OUTPUTDIR
cp coupling.ssp585.emuglaciers.emulandice.glaciers_glac12_globalsl.nc $OUTPUTDIR
cp coupling.ssp585.emuglaciers.emulandice.glaciers_glac3_globalsl.nc $OUTPUTDIR
cp coupling.ssp585.emuglaciers.emulandice.glaciers_glac1_globalsl.nc $OUTPUTDIR
cp coupling.ssp585.emuglaciers.emulandice.glaciers_glac16_globalsl.nc $OUTPUTDIR
cp coupling.ssp585.emuglaciers.emulandice.glaciers_glac19_globalsl.nc $OUTPUTDIR
cp coupling.ssp585.emuglaciers.emulandice.glaciers_glac6_globalsl.nc $OUTPUTDIR
cp coupling.ssp585.emuglaciers.emulandice.glaciers_glac7_globalsl.nc $OUTPUTDIR
cp coupling.ssp585.emuglaciers.emulandice.glaciers_glac18_globalsl.nc $OUTPUTDIR
cp coupling.ssp585.emuglaciers.emulandice.glaciers_glac2_globalsl.nc $OUTPUTDIR
cp coupling.ssp585.emuglaciers.emulandice.glaciers_glac9_globalsl.nc $OUTPUTDIR
cp coupling.ssp585.emuglaciers.emulandice.glaciers_glac5_globalsl.nc $OUTPUTDIR
cp coupling.ssp585.emuglaciers.emulandice.glaciers_globalsl.nc $OUTPUTDIR

# ---- Stage postprocess:

cd $BASEDIR
cp ./modules-data/grd_fingerprints_data.tgz ./modules/emulandice/glaciers/ReadFingerprint.py ./modules/emulandice/glaciers/AssignFP.py ./modules/emulandice/glaciers/read_locationfile.py ./modules/emulandice/glaciers/emulandice_glaciers_postprocess.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf grd_fingerprints_data.tgz 2> /dev/null; rm grd_fingerprints_data.tgz
python3 emulandice_glaciers_postprocess.py --pipeline_id coupling.ssp585.emuglaciers.emulandice.glaciers

cp coupling.ssp585.emuglaciers.emulandice.glaciers_localsl.nc $OUTPUTDIR

# - Pipeline coupling.ssp585.larmip.larmip.AIS:


PIPELINEDIR=$WORKDIR/coupling.ssp585.larmip.larmip.AIS
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/coupling.ssp585/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp ./modules/larmip/AIS/larmip_icesheet_preprocess.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
pip install --upgrade pip; pip install numpy scipy netCDF4 pyyaml matplotlib h5py
python larmip_icesheet_preprocess.py --scenario ssp585 --pipeline_id coupling.ssp585.larmip.larmip.AIS --climate_data_file $SHARED/climate/coupling.ssp585.temperature.fair.temperature_climate.nc


# ---- Stage fit:

cd $BASEDIR
cp ./modules/larmip/AIS/larmip_icesheet_fit.py ./modules-data/larmip_icesheet_fit_data.tgz $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf larmip_icesheet_fit_data.tgz 2> /dev/null; rm larmip_icesheet_fit_data.tgz
python larmip_icesheet_fit.py --pipeline_id coupling.ssp585.larmip.larmip.AIS


# ---- Stage project:

cd $BASEDIR
cp ./modules-data/larmip_icesheet_project_data.tgz ./modules/larmip/AIS/larmip_icesheet_project.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf larmip_icesheet_project_data.tgz 2> /dev/null; rm larmip_icesheet_project_data.tgz
python larmip_icesheet_project.py --nsamps 2000 --baseyear 2005 --pyear_start 2020 --pyear_end 2150 --pyear_step 10 --pipeline_id coupling.ssp585.larmip.larmip.AIS

cp coupling.ssp585.larmip.larmip.AIS_SMB_globalsl.nc $OUTPUTDIR
cp coupling.ssp585.larmip.larmip.AIS_WAIS_globalsl.nc $OUTPUTDIR
cp coupling.ssp585.larmip.larmip.AIS_globalsl.nc $OUTPUTDIR
cp coupling.ssp585.larmip.larmip.AIS_EAIS_globalsl.nc $OUTPUTDIR
cp coupling.ssp585.larmip.larmip.AIS_PEN_globalsl.nc $OUTPUTDIR

# ---- Stage postprocess:

cd $BASEDIR
cp ./modules-data/grd_fingerprints_data.tgz ./modules/larmip/AIS/read_locationfile.py ./modules/larmip/AIS/ReadFingerprint.py ./modules/larmip/AIS/AssignFP.py ./modules/larmip/AIS/larmip_icesheet_postprocess.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf grd_fingerprints_data.tgz 2> /dev/null; rm grd_fingerprints_data.tgz
python larmip_icesheet_postprocess.py --pipeline_id coupling.ssp585.larmip.larmip.AIS

cp coupling.ssp585.larmip.larmip.AIS_EAIS_localsl.nc $OUTPUTDIR
cp coupling.ssp585.larmip.larmip.AIS_localsl.nc $OUTPUTDIR
cp coupling.ssp585.larmip.larmip.AIS_WAIS_localsl.nc $OUTPUTDIR

# - Pipeline coupling.ssp585.ar5glaciers.ipccar5.glaciers:


PIPELINEDIR=$WORKDIR/coupling.ssp585.ar5glaciers.ipccar5.glaciers
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/coupling.ssp585/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp ./modules/ipccar5/glaciers/Import2lmData.py ./modules/ipccar5/glaciers/ipccar5_glaciers_preprocess.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
pip install --upgrade pip; pip install numpy scipy netCDF4 pyyaml matplotlib h5py
python3 ipccar5_glaciers_preprocess.py --scenario ssp585 --baseyear 2005 --pipeline_id coupling.ssp585.ar5glaciers.ipccar5.glaciers --climate_data_file $SHARED/climate/coupling.ssp585.temperature.fair.temperature_climate.nc


# ---- Stage fit:

cd $BASEDIR
cp ./modules/ipccar5/glaciers/ipccar5_glaciers_fit.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 ipccar5_glaciers_fit.py --pipeline_id coupling.ssp585.ar5glaciers.ipccar5.glaciers --gmip 2


# ---- Stage project:

cd $BASEDIR
cp ./modules/ipccar5/glaciers/ipccar5_glaciers_project.py ./modules-data/ipccar5_glaciers_project_data.tgz $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf ipccar5_glaciers_project_data.tgz 2> /dev/null; rm ipccar5_glaciers_project_data.tgz
python3 ipccar5_glaciers_project.py --nsamps 2000 --pyear_start 2020 --pyear_end 2150 --pyear_step 10 --pipeline_id coupling.ssp585.ar5glaciers.ipccar5.glaciers

cp coupling.ssp585.ar5glaciers.ipccar5.glaciers_globalsl.nc $OUTPUTDIR

# ---- Stage postprocess:

cd $BASEDIR
cp ./modules-data/grd_fingerprints_data.tgz ./modules/ipccar5/glaciers/ipccar5_glaciers_postprocess.py ./modules/ipccar5/glaciers/ReadFingerprint.py ./modules/ipccar5/glaciers/read_locationfile.py ./modules/ipccar5/glaciers/AssignFP.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf grd_fingerprints_data.tgz 2> /dev/null; rm grd_fingerprints_data.tgz
python3 ipccar5_glaciers_postprocess.py --pipeline_id coupling.ssp585.ar5glaciers.ipccar5.glaciers

cp coupling.ssp585.ar5glaciers.ipccar5.glaciers_localsl.nc $OUTPUTDIR

# - Pipeline coupling.ssp585.ar5AIS.ipccar5.icesheets:


PIPELINEDIR=$WORKDIR/coupling.ssp585.ar5AIS.ipccar5.icesheets
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/coupling.ssp585/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp ./modules/ipccar5/icesheets/ipccar5_icesheets_preprocess.py ./modules/ipccar5/icesheets/Import2lmData.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
pip install --upgrade pip; pip install numpy scipy netCDF4 pyyaml matplotlib h5py
python3 ipccar5_icesheets_preprocess.py --scenario ssp585 --pipeline_id coupling.ssp585.ar5AIS.ipccar5.icesheets --baseyear 2005 --climate_data_file $SHARED/climate/coupling.ssp585.temperature.fair.temperature_climate.nc


# ---- Stage fit:

cd $BASEDIR
cp ./modules/ipccar5/icesheets/ipccar5_icesheets_fit.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 ipccar5_icesheets_fit.py --pipeline_id coupling.ssp585.ar5AIS.ipccar5.icesheets


# ---- Stage project:

cd $BASEDIR
cp ./modules/ipccar5/icesheets/ipccar5_icesheets_project.py ./modules-data/ipccar5_icesheets_project_data.tgz $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf ipccar5_icesheets_project_data.tgz 2> /dev/null; rm ipccar5_icesheets_project_data.tgz
python3 ipccar5_icesheets_project.py --nsamps 2000 --pyear_start 2020 --pyear_end 2150 --pyear_step 10 --pipeline_id coupling.ssp585.ar5AIS.ipccar5.icesheets

cp coupling.ssp585.ar5AIS.ipccar5.icesheets_WAIS_globalsl.nc $OUTPUTDIR
cp coupling.ssp585.ar5AIS.ipccar5.icesheets_EAIS_globalsl.nc $OUTPUTDIR
cp coupling.ssp585.ar5AIS.ipccar5.icesheets_AIS_globalsl.nc $OUTPUTDIR

# ---- Stage postprocess:

cd $BASEDIR
cp ./modules-data/grd_fingerprints_data.tgz ./modules/ipccar5/icesheets/read_locationfile.py ./modules/ipccar5/icesheets/ipccar5_icesheets_postprocess.py ./modules/ipccar5/icesheets/ReadFingerprint.py ./modules/ipccar5/icesheets/AssignFP.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf grd_fingerprints_data.tgz 2> /dev/null; rm grd_fingerprints_data.tgz
python3 ipccar5_icesheets_postprocess.py --pipeline_id coupling.ssp585.ar5AIS.ipccar5.icesheets

cp coupling.ssp585.ar5AIS.ipccar5.icesheets_EAIS_localsl.nc $OUTPUTDIR
cp coupling.ssp585.ar5AIS.ipccar5.icesheets_WAIS_localsl.nc $OUTPUTDIR

# - Pipeline coupling.ssp585.ocean.tlm.sterodynamics:


PIPELINEDIR=$WORKDIR/coupling.ssp585.ocean.tlm.sterodynamics
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/coupling.ssp585/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp ./modules/tlm/sterodynamics/IncludeCMIP6Models.py ./modules/tlm/sterodynamics/IncludeCMIP6ZOSModels.py ./modules/tlm/sterodynamics/Smooth.py ./modules/tlm/sterodynamics/SmoothZOSTOGA.py ./modules-data/tlm_sterodynamics_cmip6_data.tgz ./modules/tlm/sterodynamics/read_locationfile.py ./modules/tlm/sterodynamics/tlm_sterodynamics_preprocess_oceandynamics.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf tlm_sterodynamics_cmip6_data.tgz 2> /dev/null; rm tlm_sterodynamics_cmip6_data.tgz
python3 tlm_sterodynamics_preprocess_oceandynamics.py --scenario ssp585 --baseyear 2005 --pyear_start 2020 --pyear_end 2150 --pyear_step 10 --pipeline_id coupling.ssp585.ocean.tlm.sterodynamics

cd $BASEDIR
cp ./modules/tlm/sterodynamics/tlm_sterodynamics_preprocess_thermalexpansion.py ./modules/tlm/sterodynamics/Import2lmData.py ./modules-data/tlm_sterodynamics_preprocess_data.tgz $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf tlm_sterodynamics_preprocess_data.tgz 2> /dev/null; rm tlm_sterodynamics_preprocess_data.tgz
pip install --upgrade pip; pip install numpy scipy netCDF4 pyyaml h5py
python3 tlm_sterodynamics_preprocess_thermalexpansion.py --scenario ssp585 --climate_data_file $SHARED/climate/coupling.ssp585.temperature.fair.temperature_climate.nc --pipeline_id coupling.ssp585.ocean.tlm.sterodynamics


# ---- Stage fit:

cd $BASEDIR
cp ./modules/tlm/sterodynamics/tlm_sterodynamics_fit_thermalexpansion.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 tlm_sterodynamics_fit_thermalexpansion.py --pipeline_id coupling.ssp585.ocean.tlm.sterodynamics

cd $BASEDIR
cp ./modules/tlm/sterodynamics/tlm_sterodynamics_fit_oceandynamics.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 tlm_sterodynamics_fit_oceandynamics.py --pipeline_id coupling.ssp585.ocean.tlm.sterodynamics


# ---- Stage project:

cd $BASEDIR
cp ./modules/tlm/sterodynamics/tlm_sterodynamics_project.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 tlm_sterodynamics_project.py --pipeline_id coupling.ssp585.ocean.tlm.sterodynamics --nsamps 2000 --scenario ssp585 --baseyear 2005 --pyear_start 2020 --pyear_end 2150 --pyear_step 10

cp coupling.ssp585.ocean.tlm.sterodynamics_globalsl.nc $OUTPUTDIR

# ---- Stage postprocess:

cd $BASEDIR
cp ./modules/tlm/sterodynamics/tlm_sterodynamics_postprocess.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 tlm_sterodynamics_postprocess.py --nsamps 2000 --pipeline_id coupling.ssp585.ocean.tlm.sterodynamics

cp coupling.ssp585.ocean.tlm.sterodynamics_localsl.nc $OUTPUTDIR

# - Pipeline coupling.ssp585.k14vlm.kopp14.verticallandmotion:


PIPELINEDIR=$WORKDIR/coupling.ssp585.k14vlm.kopp14.verticallandmotion
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/coupling.ssp585/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp ./modules/kopp14/verticallandmotion/kopp14_verticallandmotion_preprocess.py ./modules-data/kopp14_verticallandmotion_preprocess_data.tgz $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf kopp14_verticallandmotion_preprocess_data.tgz 2> /dev/null; rm kopp14_verticallandmotion_preprocess_data.tgz
pip install --upgrade pip; pip install numpy scipy netCDF4 pyyaml
python3 kopp14_verticallandmotion_preprocess.py --pipeline_id coupling.ssp585.k14vlm.kopp14.verticallandmotion


# ---- Stage fit:

cd $BASEDIR
cp ./modules/kopp14/verticallandmotion/kopp14_verticallandmotion_fit.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 kopp14_verticallandmotion_fit.py --pipeline_id coupling.ssp585.k14vlm.kopp14.verticallandmotion


# ---- Stage project:

cd $BASEDIR
cp ./modules/kopp14/verticallandmotion/kopp14_verticallandmotion_project.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 kopp14_verticallandmotion_project.py --pipeline_id coupling.ssp585.k14vlm.kopp14.verticallandmotion


# ---- Stage postprocess:

cd $BASEDIR
cp ./modules/kopp14/verticallandmotion/kopp14_verticallandmotion_postprocess.py ./modules/kopp14/verticallandmotion/read_locationfile.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 kopp14_verticallandmotion_postprocess.py --nsamps 2000 --baseyear 2005 --pyear_start 2020 --pyear_end 2150 --pyear_step 10 --pipeline_id coupling.ssp585.k14vlm.kopp14.verticallandmotion

cp coupling.ssp585.k14vlm.kopp14.verticallandmotion_localsl.nc $OUTPUTDIR

# - Pipeline coupling.ssp585.lws.ssp.landwaterstorage:


PIPELINEDIR=$WORKDIR/coupling.ssp585.lws.ssp.landwaterstorage
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/coupling.ssp585/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp ./modules-data/ssp_landwaterstorage_preprocess_data.tgz ./modules/ssp/landwaterstorage/ssp_landwaterstorage_preprocess.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf ssp_landwaterstorage_preprocess_data.tgz 2> /dev/null; rm ssp_landwaterstorage_preprocess_data.tgz
pip install --upgrade pip; pip install numpy scipy netCDF4 pyyaml matplotlib
python3 ssp_landwaterstorage_preprocess.py --scenario ssp5 --baseyear 2005 --pyear_start 2020 --pyear_end 2150 --pyear_step 10 --pipeline_id coupling.ssp585.lws.ssp.landwaterstorage


# ---- Stage fit:

cd $BASEDIR
cp ./modules/ssp/landwaterstorage/ssp_landwaterstorage_fit.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 ssp_landwaterstorage_fit.py --pipeline_id coupling.ssp585.lws.ssp.landwaterstorage


# ---- Stage project:

cd $BASEDIR
cp ./modules/ssp/landwaterstorage/ssp_landwaterstorage_project.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 ssp_landwaterstorage_project.py --pipeline_id coupling.ssp585.lws.ssp.landwaterstorage --nsamps 2000 --dcrate_lo -0.4

cp coupling.ssp585.lws.ssp.landwaterstorage_globalsl.nc $OUTPUTDIR

# ---- Stage postprocess:

cd $BASEDIR
cp ./modules/ssp/landwaterstorage/read_locationfile.py ./modules/ssp/landwaterstorage/AssignFP.py ./modules-data/ssp_landwaterstorage_postprocess_data.tgz ./modules/ssp/landwaterstorage/ssp_landwaterstorage_postprocess.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf ssp_landwaterstorage_postprocess_data.tgz 2> /dev/null; rm ssp_landwaterstorage_postprocess_data.tgz
python3 ssp_landwaterstorage_postprocess.py --pipeline_id coupling.ssp585.lws.ssp.landwaterstorage

cp coupling.ssp585.lws.ssp.landwaterstorage_localsl.nc $OUTPUTDIR

#EXPERIMENT STEP:  totaling_step 


# - Pipeline coupling.ssp585.total.facts.total.wf1f.global:


PIPELINEDIR=$WORKDIR/coupling.ssp585.total.facts.total.wf1f.global
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/coupling.ssp585/location.lst $PIPELINEDIR

# ---- Stage workflow:

cd $BASEDIR
cp experiments/coupling.ssp585/workflows.yml ./modules/facts/total/total_workflow.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
pip install --upgrade pip; pip install numpy netCDF4 pyyaml dask[array]
python3 total_workflow.py --directory $RP_PILOT_SANDBOX/to_total --workflows workflows.yml --workflow wf1f --scale global --experiment_name coupling.ssp585 --pyear_start 2020 --pyear_end 2150 --pyear_step 10

cp coupling.ssp585.total.workflow.wf1f.global.nc $OUTPUTDIR

# - Pipeline coupling.ssp585.total.facts.total.wf1f.local:


PIPELINEDIR=$WORKDIR/coupling.ssp585.total.facts.total.wf1f.local
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/coupling.ssp585/location.lst $PIPELINEDIR

# ---- Stage workflow:

cd $BASEDIR
cp experiments/coupling.ssp585/workflows.yml ./modules/facts/total/total_workflow.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
pip install --upgrade pip; pip install numpy netCDF4 pyyaml dask[array]
python3 total_workflow.py --directory $RP_PILOT_SANDBOX/to_total --workflows workflows.yml --workflow wf1f --scale local --experiment_name coupling.ssp585 --pyear_start 2020 --pyear_end 2150 --pyear_step 10

cp coupling.ssp585.total.workflow.wf1f.local.nc $OUTPUTDIR

# - Pipeline coupling.ssp585.total.facts.total.wf2f.global:


PIPELINEDIR=$WORKDIR/coupling.ssp585.total.facts.total.wf2f.global
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/coupling.ssp585/location.lst $PIPELINEDIR

# ---- Stage workflow:

cd $BASEDIR
cp experiments/coupling.ssp585/workflows.yml ./modules/facts/total/total_workflow.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
pip install --upgrade pip; pip install numpy netCDF4 pyyaml dask[array]
python3 total_workflow.py --directory $RP_PILOT_SANDBOX/to_total --workflows workflows.yml --workflow wf2f --scale global --experiment_name coupling.ssp585 --pyear_start 2020 --pyear_end 2150 --pyear_step 10

cp coupling.ssp585.total.workflow.wf2f.global.nc $OUTPUTDIR

# - Pipeline coupling.ssp585.total.facts.total.wf2f.local:


PIPELINEDIR=$WORKDIR/coupling.ssp585.total.facts.total.wf2f.local
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/coupling.ssp585/location.lst $PIPELINEDIR

# ---- Stage workflow:

cd $BASEDIR
cp experiments/coupling.ssp585/workflows.yml ./modules/facts/total/total_workflow.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
pip install --upgrade pip; pip install numpy netCDF4 pyyaml dask[array]
python3 total_workflow.py --directory $RP_PILOT_SANDBOX/to_total --workflows workflows.yml --workflow wf2f --scale local --experiment_name coupling.ssp585 --pyear_start 2020 --pyear_end 2150 --pyear_step 10

cp coupling.ssp585.total.workflow.wf2f.local.nc $OUTPUTDIR

# - Pipeline coupling.ssp585.total.facts.total.wf3f.global:


PIPELINEDIR=$WORKDIR/coupling.ssp585.total.facts.total.wf3f.global
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/coupling.ssp585/location.lst $PIPELINEDIR

# ---- Stage workflow:

cd $BASEDIR
cp experiments/coupling.ssp585/workflows.yml ./modules/facts/total/total_workflow.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
pip install --upgrade pip; pip install numpy netCDF4 pyyaml dask[array]
python3 total_workflow.py --directory $RP_PILOT_SANDBOX/to_total --workflows workflows.yml --workflow wf3f --scale global --experiment_name coupling.ssp585 --pyear_start 2020 --pyear_end 2150 --pyear_step 10

cp coupling.ssp585.total.workflow.wf3f.global.nc $OUTPUTDIR

# - Pipeline coupling.ssp585.total.facts.total.wf3f.local:


PIPELINEDIR=$WORKDIR/coupling.ssp585.total.facts.total.wf3f.local
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/coupling.ssp585/location.lst $PIPELINEDIR

# ---- Stage workflow:

cd $BASEDIR
cp experiments/coupling.ssp585/workflows.yml ./modules/facts/total/total_workflow.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
pip install --upgrade pip; pip install numpy netCDF4 pyyaml dask[array]
python3 total_workflow.py --directory $RP_PILOT_SANDBOX/to_total --workflows workflows.yml --workflow wf3f --scale local --experiment_name coupling.ssp585 --pyear_start 2020 --pyear_end 2150 --pyear_step 10

cp coupling.ssp585.total.workflow.wf3f.local.nc $OUTPUTDIR

# - Pipeline coupling.ssp585.total.facts.total.wf3e.global:


PIPELINEDIR=$WORKDIR/coupling.ssp585.total.facts.total.wf3e.global
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/coupling.ssp585/location.lst $PIPELINEDIR

# ---- Stage workflow:

cd $BASEDIR
cp experiments/coupling.ssp585/workflows.yml ./modules/facts/total/total_workflow.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
pip install --upgrade pip; pip install numpy netCDF4 pyyaml dask[array]
python3 total_workflow.py --directory $RP_PILOT_SANDBOX/to_total --workflows workflows.yml --workflow wf3e --scale global --experiment_name coupling.ssp585 --pyear_start 2020 --pyear_end 2100 --pyear_step 10

cp coupling.ssp585.total.workflow.wf3e.global.nc $OUTPUTDIR

# - Pipeline coupling.ssp585.total.facts.total.wf3e.local:


PIPELINEDIR=$WORKDIR/coupling.ssp585.total.facts.total.wf3e.local
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/coupling.ssp585/location.lst $PIPELINEDIR

# ---- Stage workflow:

cd $BASEDIR
cp experiments/coupling.ssp585/workflows.yml ./modules/facts/total/total_workflow.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
pip install --upgrade pip; pip install numpy netCDF4 pyyaml dask[array]
python3 total_workflow.py --directory $RP_PILOT_SANDBOX/to_total --workflows workflows.yml --workflow wf3e --scale local --experiment_name coupling.ssp585 --pyear_start 2020 --pyear_end 2100 --pyear_step 10

cp coupling.ssp585.total.workflow.wf3e.local.nc $OUTPUTDIR

# - Pipeline coupling.ssp585.total.facts.total.wf4.global:


PIPELINEDIR=$WORKDIR/coupling.ssp585.total.facts.total.wf4.global
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/coupling.ssp585/location.lst $PIPELINEDIR

# ---- Stage workflow:

cd $BASEDIR
cp experiments/coupling.ssp585/workflows.yml ./modules/facts/total/total_workflow.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
pip install --upgrade pip; pip install numpy netCDF4 pyyaml dask[array]
python3 total_workflow.py --directory $RP_PILOT_SANDBOX/to_total --workflows workflows.yml --workflow wf4 --scale global --experiment_name coupling.ssp585 --pyear_start 2020 --pyear_end 2150 --pyear_step 10

cp coupling.ssp585.total.workflow.wf4.global.nc $OUTPUTDIR

# - Pipeline coupling.ssp585.total.facts.total.wf4.local:


PIPELINEDIR=$WORKDIR/coupling.ssp585.total.facts.total.wf4.local
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/coupling.ssp585/location.lst $PIPELINEDIR

# ---- Stage workflow:

cd $BASEDIR
cp experiments/coupling.ssp585/workflows.yml ./modules/facts/total/total_workflow.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
pip install --upgrade pip; pip install numpy netCDF4 pyyaml dask[array]
python3 total_workflow.py --directory $RP_PILOT_SANDBOX/to_total --workflows workflows.yml --workflow wf4 --scale local --experiment_name coupling.ssp585 --pyear_start 2020 --pyear_end 2150 --pyear_step 10

cp coupling.ssp585.total.workflow.wf4.local.nc $OUTPUTDIR

# - Pipeline coupling.ssp585.total.facts.total.wf1e.global:


PIPELINEDIR=$WORKDIR/coupling.ssp585.total.facts.total.wf1e.global
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/coupling.ssp585/location.lst $PIPELINEDIR

# ---- Stage workflow:

cd $BASEDIR
cp experiments/coupling.ssp585/workflows.yml ./modules/facts/total/total_workflow.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
pip install --upgrade pip; pip install numpy netCDF4 pyyaml dask[array]
python3 total_workflow.py --directory $RP_PILOT_SANDBOX/to_total --workflows workflows.yml --workflow wf1e --scale global --experiment_name coupling.ssp585 --pyear_start 2020 --pyear_end 2100 --pyear_step 10

cp coupling.ssp585.total.workflow.wf1e.global.nc $OUTPUTDIR

# - Pipeline coupling.ssp585.total.facts.total.wf1e.local:


PIPELINEDIR=$WORKDIR/coupling.ssp585.total.facts.total.wf1e.local
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/coupling.ssp585/location.lst $PIPELINEDIR

# ---- Stage workflow:

cd $BASEDIR
cp experiments/coupling.ssp585/workflows.yml ./modules/facts/total/total_workflow.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
pip install --upgrade pip; pip install numpy netCDF4 pyyaml dask[array]
python3 total_workflow.py --directory $RP_PILOT_SANDBOX/to_total --workflows workflows.yml --workflow wf1e --scale local --experiment_name coupling.ssp585 --pyear_start 2020 --pyear_end 2100 --pyear_step 10

cp coupling.ssp585.total.workflow.wf1e.local.nc $OUTPUTDIR

# - Pipeline coupling.ssp585.total.facts.total.wf2e.global:


PIPELINEDIR=$WORKDIR/coupling.ssp585.total.facts.total.wf2e.global
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/coupling.ssp585/location.lst $PIPELINEDIR

# ---- Stage workflow:

cd $BASEDIR
cp experiments/coupling.ssp585/workflows.yml ./modules/facts/total/total_workflow.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
pip install --upgrade pip; pip install numpy netCDF4 pyyaml dask[array]
python3 total_workflow.py --directory $RP_PILOT_SANDBOX/to_total --workflows workflows.yml --workflow wf2e --scale global --experiment_name coupling.ssp585 --pyear_start 2020 --pyear_end 2100 --pyear_step 10

cp coupling.ssp585.total.workflow.wf2e.global.nc $OUTPUTDIR

# - Pipeline coupling.ssp585.total.facts.total.wf2e.local:


PIPELINEDIR=$WORKDIR/coupling.ssp585.total.facts.total.wf2e.local
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/coupling.ssp585/location.lst $PIPELINEDIR

# ---- Stage workflow:

cd $BASEDIR
cp experiments/coupling.ssp585/workflows.yml ./modules/facts/total/total_workflow.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
pip install --upgrade pip; pip install numpy netCDF4 pyyaml dask[array]
python3 total_workflow.py --directory $RP_PILOT_SANDBOX/to_total --workflows workflows.yml --workflow wf2e --scale local --experiment_name coupling.ssp585 --pyear_start 2020 --pyear_end 2100 --pyear_step 10

cp coupling.ssp585.total.workflow.wf2e.local.nc $OUTPUTDIR

#EXPERIMENT STEP:  esl_step 


# - Pipeline coupling.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf1f:


PIPELINEDIR=$WORKDIR/coupling.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf1f
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/coupling.ssp585/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp ./modules/extremesealevel/pointsoverthreshold/extremesealevel_pointsoverthreshold_preprocess.py ./modules-data/extremesealevel_pointsoverthreshold_data.tgz $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf extremesealevel_pointsoverthreshold_data.tgz 2> /dev/null; rm extremesealevel_pointsoverthreshold_data.tgz
python3 extremesealevel_pointsoverthreshold_preprocess.py --total_localsl_file $SHARED/totaled/coupling.ssp585.total.workflow.wf1f.local.nc --target_years 2050,2100 --pipeline_id coupling.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf1f


# ---- Stage fit:

cd $BASEDIR
cp ./modules/extremesealevel/pointsoverthreshold/extremesealevel_pointsoverthreshold_fit.py ./modules/extremesealevel/pointsoverthreshold/gplike.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 extremesealevel_pointsoverthreshold_fit.py --pipeline_id coupling.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf1f


# ---- Stage project:

cd $BASEDIR
cp ./modules/extremesealevel/pointsoverthreshold/extremesealevel_pointsoverthreshold_project.py ./modules/extremesealevel/pointsoverthreshold/sample_from_quantiles.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 extremesealevel_pointsoverthreshold_project.py --nsamps 2000 --pipeline_id coupling.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf1f

cp coupling.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf1f_extremesl.tgz $OUTPUTDIR

# - Pipeline coupling.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf2f:


PIPELINEDIR=$WORKDIR/coupling.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf2f
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/coupling.ssp585/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp ./modules/extremesealevel/pointsoverthreshold/extremesealevel_pointsoverthreshold_preprocess.py ./modules-data/extremesealevel_pointsoverthreshold_data.tgz $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf extremesealevel_pointsoverthreshold_data.tgz 2> /dev/null; rm extremesealevel_pointsoverthreshold_data.tgz
python3 extremesealevel_pointsoverthreshold_preprocess.py --total_localsl_file $SHARED/totaled/coupling.ssp585.total.workflow.wf2f.local.nc --target_years 2050,2100 --pipeline_id coupling.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf2f


# ---- Stage fit:

cd $BASEDIR
cp ./modules/extremesealevel/pointsoverthreshold/extremesealevel_pointsoverthreshold_fit.py ./modules/extremesealevel/pointsoverthreshold/gplike.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 extremesealevel_pointsoverthreshold_fit.py --pipeline_id coupling.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf2f


# ---- Stage project:

cd $BASEDIR
cp ./modules/extremesealevel/pointsoverthreshold/extremesealevel_pointsoverthreshold_project.py ./modules/extremesealevel/pointsoverthreshold/sample_from_quantiles.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 extremesealevel_pointsoverthreshold_project.py --nsamps 2000 --pipeline_id coupling.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf2f

cp coupling.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf2f_extremesl.tgz $OUTPUTDIR

# - Pipeline coupling.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf3f:


PIPELINEDIR=$WORKDIR/coupling.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf3f
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/coupling.ssp585/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp ./modules/extremesealevel/pointsoverthreshold/extremesealevel_pointsoverthreshold_preprocess.py ./modules-data/extremesealevel_pointsoverthreshold_data.tgz $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf extremesealevel_pointsoverthreshold_data.tgz 2> /dev/null; rm extremesealevel_pointsoverthreshold_data.tgz
python3 extremesealevel_pointsoverthreshold_preprocess.py --total_localsl_file $SHARED/totaled/coupling.ssp585.total.workflow.wf3f.local.nc --target_years 2050,2100 --pipeline_id coupling.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf3f


# ---- Stage fit:

cd $BASEDIR
cp ./modules/extremesealevel/pointsoverthreshold/extremesealevel_pointsoverthreshold_fit.py ./modules/extremesealevel/pointsoverthreshold/gplike.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 extremesealevel_pointsoverthreshold_fit.py --pipeline_id coupling.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf3f


# ---- Stage project:

cd $BASEDIR
cp ./modules/extremesealevel/pointsoverthreshold/extremesealevel_pointsoverthreshold_project.py ./modules/extremesealevel/pointsoverthreshold/sample_from_quantiles.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 extremesealevel_pointsoverthreshold_project.py --nsamps 2000 --pipeline_id coupling.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf3f

cp coupling.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf3f_extremesl.tgz $OUTPUTDIR

# - Pipeline coupling.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf3e:


PIPELINEDIR=$WORKDIR/coupling.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf3e
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/coupling.ssp585/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp ./modules/extremesealevel/pointsoverthreshold/extremesealevel_pointsoverthreshold_preprocess.py ./modules-data/extremesealevel_pointsoverthreshold_data.tgz $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf extremesealevel_pointsoverthreshold_data.tgz 2> /dev/null; rm extremesealevel_pointsoverthreshold_data.tgz
python3 extremesealevel_pointsoverthreshold_preprocess.py --total_localsl_file $SHARED/totaled/coupling.ssp585.total.workflow.wf3e.local.nc --target_years 2050,2100 --pipeline_id coupling.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf3e


# ---- Stage fit:

cd $BASEDIR
cp ./modules/extremesealevel/pointsoverthreshold/extremesealevel_pointsoverthreshold_fit.py ./modules/extremesealevel/pointsoverthreshold/gplike.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 extremesealevel_pointsoverthreshold_fit.py --pipeline_id coupling.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf3e


# ---- Stage project:

cd $BASEDIR
cp ./modules/extremesealevel/pointsoverthreshold/extremesealevel_pointsoverthreshold_project.py ./modules/extremesealevel/pointsoverthreshold/sample_from_quantiles.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 extremesealevel_pointsoverthreshold_project.py --nsamps 2000 --pipeline_id coupling.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf3e

cp coupling.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf3e_extremesl.tgz $OUTPUTDIR

# - Pipeline coupling.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf4:


PIPELINEDIR=$WORKDIR/coupling.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf4
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/coupling.ssp585/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp ./modules/extremesealevel/pointsoverthreshold/extremesealevel_pointsoverthreshold_preprocess.py ./modules-data/extremesealevel_pointsoverthreshold_data.tgz $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf extremesealevel_pointsoverthreshold_data.tgz 2> /dev/null; rm extremesealevel_pointsoverthreshold_data.tgz
python3 extremesealevel_pointsoverthreshold_preprocess.py --total_localsl_file $SHARED/totaled/coupling.ssp585.total.workflow.wf4.local.nc --target_years 2050,2100 --pipeline_id coupling.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf4


# ---- Stage fit:

cd $BASEDIR
cp ./modules/extremesealevel/pointsoverthreshold/extremesealevel_pointsoverthreshold_fit.py ./modules/extremesealevel/pointsoverthreshold/gplike.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 extremesealevel_pointsoverthreshold_fit.py --pipeline_id coupling.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf4


# ---- Stage project:

cd $BASEDIR
cp ./modules/extremesealevel/pointsoverthreshold/extremesealevel_pointsoverthreshold_project.py ./modules/extremesealevel/pointsoverthreshold/sample_from_quantiles.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 extremesealevel_pointsoverthreshold_project.py --nsamps 2000 --pipeline_id coupling.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf4

cp coupling.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf4_extremesl.tgz $OUTPUTDIR

# - Pipeline coupling.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf1e:


PIPELINEDIR=$WORKDIR/coupling.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf1e
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/coupling.ssp585/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp ./modules/extremesealevel/pointsoverthreshold/extremesealevel_pointsoverthreshold_preprocess.py ./modules-data/extremesealevel_pointsoverthreshold_data.tgz $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf extremesealevel_pointsoverthreshold_data.tgz 2> /dev/null; rm extremesealevel_pointsoverthreshold_data.tgz
python3 extremesealevel_pointsoverthreshold_preprocess.py --total_localsl_file $SHARED/totaled/coupling.ssp585.total.workflow.wf1e.local.nc --target_years 2050,2100 --pipeline_id coupling.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf1e


# ---- Stage fit:

cd $BASEDIR
cp ./modules/extremesealevel/pointsoverthreshold/extremesealevel_pointsoverthreshold_fit.py ./modules/extremesealevel/pointsoverthreshold/gplike.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 extremesealevel_pointsoverthreshold_fit.py --pipeline_id coupling.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf1e


# ---- Stage project:

cd $BASEDIR
cp ./modules/extremesealevel/pointsoverthreshold/extremesealevel_pointsoverthreshold_project.py ./modules/extremesealevel/pointsoverthreshold/sample_from_quantiles.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 extremesealevel_pointsoverthreshold_project.py --nsamps 2000 --pipeline_id coupling.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf1e

cp coupling.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf1e_extremesl.tgz $OUTPUTDIR

# - Pipeline coupling.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf2e:


PIPELINEDIR=$WORKDIR/coupling.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf2e
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/coupling.ssp585/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp ./modules/extremesealevel/pointsoverthreshold/extremesealevel_pointsoverthreshold_preprocess.py ./modules-data/extremesealevel_pointsoverthreshold_data.tgz $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf extremesealevel_pointsoverthreshold_data.tgz 2> /dev/null; rm extremesealevel_pointsoverthreshold_data.tgz
python3 extremesealevel_pointsoverthreshold_preprocess.py --total_localsl_file $SHARED/totaled/coupling.ssp585.total.workflow.wf2e.local.nc --target_years 2050,2100 --pipeline_id coupling.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf2e


# ---- Stage fit:

cd $BASEDIR
cp ./modules/extremesealevel/pointsoverthreshold/extremesealevel_pointsoverthreshold_fit.py ./modules/extremesealevel/pointsoverthreshold/gplike.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 extremesealevel_pointsoverthreshold_fit.py --pipeline_id coupling.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf2e


# ---- Stage project:

cd $BASEDIR
cp ./modules/extremesealevel/pointsoverthreshold/extremesealevel_pointsoverthreshold_project.py ./modules/extremesealevel/pointsoverthreshold/sample_from_quantiles.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 extremesealevel_pointsoverthreshold_project.py --nsamps 2000 --pipeline_id coupling.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf2e

cp coupling.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf2e_extremesl.tgz $OUTPUTDIR
