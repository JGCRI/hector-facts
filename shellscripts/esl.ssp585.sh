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


# - Pipeline esl.ssp585.dummy.facts.dummy:


PIPELINEDIR=$WORKDIR/esl.ssp585.dummy.facts.dummy
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/esl.ssp585/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp ./modules/facts/dummy/facts_dummy_preprocess.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python facts_dummy_preprocess.py --pipeline_id esl.ssp585.dummy.facts.dummy


#EXPERIMENT STEP:  esl_step 


# - Pipeline esl.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf1f:


PIPELINEDIR=$WORKDIR/esl.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf1f
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/esl.ssp585/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf1f.local.nc ./modules-data/extremesealevel_pointsoverthreshold_data.tgz ./modules/extremesealevel/pointsoverthreshold/extremesealevel_pointsoverthreshold_preprocess.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf extremesealevel_pointsoverthreshold_data.tgz 2> /dev/null; rm extremesealevel_pointsoverthreshold_data.tgz
python3 extremesealevel_pointsoverthreshold_preprocess.py --total_localsl_file coupling.ssp585.total.workflow.wf1f.local.nc --target_years 2050,2100 --pipeline_id esl.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf1f


# ---- Stage fit:

cd $BASEDIR
cp ./modules/extremesealevel/pointsoverthreshold/extremesealevel_pointsoverthreshold_fit.py ./modules/extremesealevel/pointsoverthreshold/gplike.py experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf1f.local.nc $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 extremesealevel_pointsoverthreshold_fit.py --pipeline_id esl.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf1f


# ---- Stage project:

cd $BASEDIR
cp ./modules/extremesealevel/pointsoverthreshold/sample_from_quantiles.py experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf1f.local.nc ./modules/extremesealevel/pointsoverthreshold/extremesealevel_pointsoverthreshold_project.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 extremesealevel_pointsoverthreshold_project.py --nsamps 2000 --pipeline_id esl.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf1f

cp esl.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf1f_extremesl.tgz $OUTPUTDIR

# - Pipeline esl.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf1e:


PIPELINEDIR=$WORKDIR/esl.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf1e
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/esl.ssp585/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp ./modules-data/extremesealevel_pointsoverthreshold_data.tgz experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf1f.local.nc experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf1e.local.nc ./modules/extremesealevel/pointsoverthreshold/extremesealevel_pointsoverthreshold_preprocess.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf extremesealevel_pointsoverthreshold_data.tgz 2> /dev/null; rm extremesealevel_pointsoverthreshold_data.tgz
python3 extremesealevel_pointsoverthreshold_preprocess.py --total_localsl_file coupling.ssp585.total.workflow.wf1e.local.nc --target_years 2050,2100 --pipeline_id esl.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf1e


# ---- Stage fit:

cd $BASEDIR
cp ./modules/extremesealevel/pointsoverthreshold/extremesealevel_pointsoverthreshold_fit.py ./modules/extremesealevel/pointsoverthreshold/gplike.py experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf1e.local.nc experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf1f.local.nc $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 extremesealevel_pointsoverthreshold_fit.py --pipeline_id esl.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf1e


# ---- Stage project:

cd $BASEDIR
cp ./modules/extremesealevel/pointsoverthreshold/sample_from_quantiles.py experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf1e.local.nc experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf1f.local.nc ./modules/extremesealevel/pointsoverthreshold/extremesealevel_pointsoverthreshold_project.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 extremesealevel_pointsoverthreshold_project.py --nsamps 2000 --pipeline_id esl.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf1e

cp esl.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf1e_extremesl.tgz $OUTPUTDIR

# - Pipeline esl.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf2e:


PIPELINEDIR=$WORKDIR/esl.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf2e
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/esl.ssp585/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf1e.local.nc ./modules/extremesealevel/pointsoverthreshold/extremesealevel_pointsoverthreshold_preprocess.py experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf1f.local.nc experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf2e.local.nc ./modules-data/extremesealevel_pointsoverthreshold_data.tgz $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf extremesealevel_pointsoverthreshold_data.tgz 2> /dev/null; rm extremesealevel_pointsoverthreshold_data.tgz
python3 extremesealevel_pointsoverthreshold_preprocess.py --total_localsl_file coupling.ssp585.total.workflow.wf2e.local.nc --target_years 2050,2100 --pipeline_id esl.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf2e


# ---- Stage fit:

cd $BASEDIR
cp ./modules/extremesealevel/pointsoverthreshold/gplike.py experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf1e.local.nc experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf1f.local.nc ./modules/extremesealevel/pointsoverthreshold/extremesealevel_pointsoverthreshold_fit.py experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf2e.local.nc $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 extremesealevel_pointsoverthreshold_fit.py --pipeline_id esl.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf2e


# ---- Stage project:

cd $BASEDIR
cp experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf1e.local.nc experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf1f.local.nc ./modules/extremesealevel/pointsoverthreshold/sample_from_quantiles.py experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf2e.local.nc ./modules/extremesealevel/pointsoverthreshold/extremesealevel_pointsoverthreshold_project.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 extremesealevel_pointsoverthreshold_project.py --nsamps 2000 --pipeline_id esl.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf2e

cp esl.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf2e_extremesl.tgz $OUTPUTDIR

# - Pipeline esl.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf2f:


PIPELINEDIR=$WORKDIR/esl.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf2f
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/esl.ssp585/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf1e.local.nc ./modules/extremesealevel/pointsoverthreshold/extremesealevel_pointsoverthreshold_preprocess.py experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf1f.local.nc experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf2f.local.nc experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf2e.local.nc ./modules-data/extremesealevel_pointsoverthreshold_data.tgz $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf extremesealevel_pointsoverthreshold_data.tgz 2> /dev/null; rm extremesealevel_pointsoverthreshold_data.tgz
python3 extremesealevel_pointsoverthreshold_preprocess.py --total_localsl_file coupling.ssp585.total.workflow.wf2f.local.nc --target_years 2050,2100 --pipeline_id esl.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf2f


# ---- Stage fit:

cd $BASEDIR
cp ./modules/extremesealevel/pointsoverthreshold/gplike.py experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf1e.local.nc experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf1f.local.nc experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf2f.local.nc ./modules/extremesealevel/pointsoverthreshold/extremesealevel_pointsoverthreshold_fit.py experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf2e.local.nc $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 extremesealevel_pointsoverthreshold_fit.py --pipeline_id esl.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf2f


# ---- Stage project:

cd $BASEDIR
cp experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf1e.local.nc experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf1f.local.nc experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf2f.local.nc ./modules/extremesealevel/pointsoverthreshold/sample_from_quantiles.py experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf2e.local.nc ./modules/extremesealevel/pointsoverthreshold/extremesealevel_pointsoverthreshold_project.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 extremesealevel_pointsoverthreshold_project.py --nsamps 2000 --pipeline_id esl.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf2f

cp esl.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf2f_extremesl.tgz $OUTPUTDIR

# - Pipeline esl.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf3e:


PIPELINEDIR=$WORKDIR/esl.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf3e
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/esl.ssp585/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf1e.local.nc ./modules/extremesealevel/pointsoverthreshold/extremesealevel_pointsoverthreshold_preprocess.py experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf1f.local.nc experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf2f.local.nc experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf2e.local.nc ./modules-data/extremesealevel_pointsoverthreshold_data.tgz experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf3e.local.nc $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf extremesealevel_pointsoverthreshold_data.tgz 2> /dev/null; rm extremesealevel_pointsoverthreshold_data.tgz
python3 extremesealevel_pointsoverthreshold_preprocess.py --total_localsl_file coupling.ssp585.total.workflow.wf3e.local.nc --target_years 2050,2100 --pipeline_id esl.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf3e


# ---- Stage fit:

cd $BASEDIR
cp ./modules/extremesealevel/pointsoverthreshold/gplike.py experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf1e.local.nc experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf1f.local.nc experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf2f.local.nc ./modules/extremesealevel/pointsoverthreshold/extremesealevel_pointsoverthreshold_fit.py experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf2e.local.nc experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf3e.local.nc $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 extremesealevel_pointsoverthreshold_fit.py --pipeline_id esl.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf3e


# ---- Stage project:

cd $BASEDIR
cp experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf3e.local.nc experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf1e.local.nc experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf1f.local.nc experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf2f.local.nc ./modules/extremesealevel/pointsoverthreshold/sample_from_quantiles.py experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf2e.local.nc ./modules/extremesealevel/pointsoverthreshold/extremesealevel_pointsoverthreshold_project.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 extremesealevel_pointsoverthreshold_project.py --nsamps 2000 --pipeline_id esl.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf3e

cp esl.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf3e_extremesl.tgz $OUTPUTDIR

# - Pipeline esl.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf3f:


PIPELINEDIR=$WORKDIR/esl.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf3f
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/esl.ssp585/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf1e.local.nc ./modules/extremesealevel/pointsoverthreshold/extremesealevel_pointsoverthreshold_preprocess.py experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf1f.local.nc experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf2f.local.nc ./modules-data/extremesealevel_pointsoverthreshold_data.tgz experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf2e.local.nc experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf3f.local.nc experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf3e.local.nc $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf extremesealevel_pointsoverthreshold_data.tgz 2> /dev/null; rm extremesealevel_pointsoverthreshold_data.tgz
python3 extremesealevel_pointsoverthreshold_preprocess.py --total_localsl_file coupling.ssp585.total.workflow.wf3f.local.nc --target_years 2050,2100 --pipeline_id esl.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf3f


# ---- Stage fit:

cd $BASEDIR
cp ./modules/extremesealevel/pointsoverthreshold/gplike.py experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf1e.local.nc experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf1f.local.nc experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf2f.local.nc ./modules/extremesealevel/pointsoverthreshold/extremesealevel_pointsoverthreshold_fit.py experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf2e.local.nc experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf3f.local.nc experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf3e.local.nc $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 extremesealevel_pointsoverthreshold_fit.py --pipeline_id esl.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf3f


# ---- Stage project:

cd $BASEDIR
cp experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf3e.local.nc experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf1e.local.nc experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf1f.local.nc experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf2f.local.nc ./modules/extremesealevel/pointsoverthreshold/sample_from_quantiles.py experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf2e.local.nc experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf3f.local.nc ./modules/extremesealevel/pointsoverthreshold/extremesealevel_pointsoverthreshold_project.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 extremesealevel_pointsoverthreshold_project.py --nsamps 2000 --pipeline_id esl.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf3f

cp esl.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf3f_extremesl.tgz $OUTPUTDIR

# - Pipeline esl.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf4:


PIPELINEDIR=$WORKDIR/esl.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf4
mkdir -p $PIPELINEDIR

cd $BASEDIR
cp experiments/esl.ssp585/location.lst $PIPELINEDIR

# ---- Stage preprocess:

cd $BASEDIR
cp experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf1e.local.nc ./modules/extremesealevel/pointsoverthreshold/extremesealevel_pointsoverthreshold_preprocess.py experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf1f.local.nc experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf2f.local.nc ./modules-data/extremesealevel_pointsoverthreshold_data.tgz experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf2e.local.nc experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf3f.local.nc experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf4.local.nc experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf3e.local.nc $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf extremesealevel_pointsoverthreshold_data.tgz 2> /dev/null; rm extremesealevel_pointsoverthreshold_data.tgz
python3 extremesealevel_pointsoverthreshold_preprocess.py --total_localsl_file coupling.ssp585.total.workflow.wf4.local.nc --target_years 2050,2100 --pipeline_id esl.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf4


# ---- Stage fit:

cd $BASEDIR
cp ./modules/extremesealevel/pointsoverthreshold/gplike.py experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf1e.local.nc experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf1f.local.nc experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf2f.local.nc ./modules/extremesealevel/pointsoverthreshold/extremesealevel_pointsoverthreshold_fit.py experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf2e.local.nc experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf3f.local.nc experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf4.local.nc experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf3e.local.nc $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 extremesealevel_pointsoverthreshold_fit.py --pipeline_id esl.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf4


# ---- Stage project:

cd $BASEDIR
cp experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf3e.local.nc experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf1e.local.nc experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf1f.local.nc experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf2f.local.nc ./modules/extremesealevel/pointsoverthreshold/sample_from_quantiles.py experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf2e.local.nc experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf3f.local.nc experiments/esl.ssp585/input/coupling.ssp585.total.workflow.wf4.local.nc ./modules/extremesealevel/pointsoverthreshold/extremesealevel_pointsoverthreshold_project.py $PIPELINEDIR
cd $PIPELINEDIR
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 extremesealevel_pointsoverthreshold_project.py --nsamps 2000 --pipeline_id esl.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf4

cp esl.ssp585.extremesealevel.extremesealevel.pointsoverthreshold.wf4_extremesl.tgz $OUTPUTDIR
