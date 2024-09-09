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


# - Pipeline larmip.ipccar6.ssp585.dummy.facts.dummy:


PIPELINEDIR=$WORKDIR/larmip.ipccar6.ssp585.dummy.facts.dummy
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/larmip.ipccar6.ssp585/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp ./modules/facts/dummy/facts_dummy_preprocess.py experiments/larmip.ipccar6.ssp585/input/ipccar6_climate_data.tgz $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf ipccar6_climate_data.tgz 2> /dev/null; rm ipccar6_climate_data.tgz
python facts_dummy_preprocess.py --pipeline_id larmip.ipccar6.ssp585.dummy.facts.dummy

cp twolayer_SSPs.h5 $OUTPUTDIR

#EXPERIMENT STEP:  sealevel_step 


# - Pipeline larmip.ipccar6.ssp585.larmip.larmip.AIS:


PIPELINEDIR=$WORKDIR/larmip.ipccar6.ssp585.larmip.larmip.AIS
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/larmip.ipccar6.ssp585/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp ./modules/larmip/AIS/larmip_icesheet_preprocess.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
pip install --upgrade pip; pip install numpy scipy netCDF4 pyyaml matplotlib h5py
python larmip_icesheet_preprocess.py --scenario ssp585 --pipeline_id larmip.ipccar6.ssp585.larmip.larmip.AIS --climate_data_file $SHARED/climate/twolayer_SSPs.h5


# ---- Stage fit:

cd $BASEDIR
cp ./modules-data/larmip_icesheet_fit_data.tgz ./modules/larmip/AIS/larmip_icesheet_fit.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf larmip_icesheet_fit_data.tgz 2> /dev/null; rm larmip_icesheet_fit_data.tgz
python larmip_icesheet_fit.py --pipeline_id larmip.ipccar6.ssp585.larmip.larmip.AIS


# ---- Stage project:

cd $BASEDIR
cp ./modules/larmip/AIS/larmip_icesheet_project.py ./modules-data/larmip_icesheet_project_data.tgz $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf larmip_icesheet_project_data.tgz 2> /dev/null; rm larmip_icesheet_project_data.tgz
python larmip_icesheet_project.py --nsamps 500 --baseyear 2005 --pyear_start 2020 --pyear_end 2150 --pyear_step 10 --pipeline_id larmip.ipccar6.ssp585.larmip.larmip.AIS

cp larmip.ipccar6.ssp585.larmip.larmip.AIS_SMB_globalsl.nc $OUTPUTDIR
cp larmip.ipccar6.ssp585.larmip.larmip.AIS_PEN_globalsl.nc $OUTPUTDIR
cp larmip.ipccar6.ssp585.larmip.larmip.AIS_EAIS_globalsl.nc $OUTPUTDIR
cp larmip.ipccar6.ssp585.larmip.larmip.AIS_WAIS_globalsl.nc $OUTPUTDIR
cp larmip.ipccar6.ssp585.larmip.larmip.AIS_globalsl.nc $OUTPUTDIR

# ---- Stage postprocess:

cd $BASEDIR
cp ./modules/larmip/AIS/read_locationfile.py ./modules/larmip/AIS/AssignFP.py ./modules-data/grd_fingerprints_data.tgz ./modules/larmip/AIS/ReadFingerprint.py ./modules/larmip/AIS/larmip_icesheet_postprocess.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf grd_fingerprints_data.tgz 2> /dev/null; rm grd_fingerprints_data.tgz
python larmip_icesheet_postprocess.py --pipeline_id larmip.ipccar6.ssp585.larmip.larmip.AIS

cp larmip.ipccar6.ssp585.larmip.larmip.AIS_EAIS_localsl.nc $OUTPUTDIR
cp larmip.ipccar6.ssp585.larmip.larmip.AIS_WAIS_localsl.nc $OUTPUTDIR
cp larmip.ipccar6.ssp585.larmip.larmip.AIS_localsl.nc $OUTPUTDIR
