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


# - Pipeline onemodule.deconto16.deconto16.AIS:


PIPELINEDIR=$WORKDIR/onemodule.deconto16.deconto16.AIS
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/onemodule/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp ./modules/deconto16/AIS/deconto16_AIS_preprocess.py ./modules-data/deconto16_AIS_preprocess_data.tgz $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf deconto16_AIS_preprocess_data.tgz 2> /dev/null; rm deconto16_AIS_preprocess_data.tgz
pip install --upgrade pip; pip install numpy scipy netCDF4 pyyaml matplotlib
python3 deconto16_AIS_preprocess.py --scenario rcp26 --pipeline_id onemodule.deconto16.deconto16.AIS --baseyear 2005


# ---- Stage fit:

cd $BASEDIR
cp ./modules/deconto16/AIS/deconto16_AIS_fit.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 deconto16_AIS_fit.py --pipeline_id onemodule.deconto16.deconto16.AIS


# ---- Stage project:

cd $BASEDIR
cp ./modules/deconto16/AIS/deconto16_AIS_project.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 deconto16_AIS_project.py --nsamps 2000 --pyear_start 2020 --pyear_end 2150 --pyear_step 10 --pipeline_id onemodule.deconto16.deconto16.AIS

cp onemodule.deconto16.deconto16.AIS_EAIS_globalsl.nc $OUTPUTDIR
cp onemodule.deconto16.deconto16.AIS_WAIS_globalsl.nc $OUTPUTDIR
cp onemodule.deconto16.deconto16.AIS_AIS_globalsl.nc $OUTPUTDIR

# ---- Stage postprocess:

cd $BASEDIR
cp ./modules/deconto16/AIS/read_locationfile.py ./modules/deconto16/AIS/deconto16_AIS_postprocess.py ./modules/deconto16/AIS/AssignFP.py ./modules-data/grd_fingerprints_data.tgz ./modules/deconto16/AIS/ReadFingerprint.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf grd_fingerprints_data.tgz 2> /dev/null; rm grd_fingerprints_data.tgz
python3 deconto16_AIS_postprocess.py --pipeline_id onemodule.deconto16.deconto16.AIS

cp onemodule.deconto16.deconto16.AIS_EAIS_localsl.nc $OUTPUTDIR
cp onemodule.deconto16.deconto16.AIS_AIS_localsl.nc $OUTPUTDIR
cp onemodule.deconto16.deconto16.AIS_WAIS_localsl.nc $OUTPUTDIR
