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
PRINT 'tdict' TO SEE WHERE $RP_PILOT_SANDBOX IS COMING FROM:
 {'uid': 'task.000000', 'name': 'task1', 'state': 'DESCRIBED', 'state_history': ['DESCRIBED'], 'executable': 'python3', 'arguments': ['deconto16_AIS_preprocess.py', '--scenario', 'rcp26', '--pipeline_id', 'onemodule.deconto16.deconto16.AIS', '--baseyear', 2005], 'environment': {}, 'sandbox': '', 'pre_launch': [], 'post_launch': [], 'pre_exec': ['. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true', 'tar -xvf deconto16_AIS_preprocess_data.tgz 2> /dev/null; rm deconto16_AIS_preprocess_data.tgz', 'pip install --upgrade pip; pip install numpy scipy netCDF4 pyyaml matplotlib'], 'post_exec': [], 'cpu_reqs': {'cpu_processes': 1, 'cpu_process_type': 'None', 'cpu_threads': 1, 'cpu_thread_type': 'None'}, 'gpu_reqs': {'gpu_processes': 0.0, 'gpu_process_type': None, 'gpu_threads': 1, 'gpu_thread_type': None}, 'lfs_per_process': 0, 'mem_per_process': 0, 'upload_input_data': ['./modules/deconto16/AIS/deconto16_AIS_preprocess.py', './modules-data/deconto16_AIS_preprocess_data.tgz'], 'copy_input_data': [], 'link_input_data': [], 'move_input_data': [], 'copy_output_data': [], 'link_output_data': [], 'move_output_data': [], 'download_output_data': [], 'stdout': '', 'stderr': '', 'stage_on_error': False, 'exit_code': None, 'exception': None, 'exception_detail': None, 'path': '', 'tags': None, 'rts_uid': None, 'parent_stage': {'uid': 'stage.0000', 'name': 'preprocess'}, 'parent_pipeline': {'uid': 'pipeline.0000', 'name': 'onemodule.deconto16.deconto16.AIS'}}
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf deconto16_AIS_preprocess_data.tgz 2> /dev/null; rm deconto16_AIS_preprocess_data.tgz
pip install --upgrade pip; pip install numpy scipy netCDF4 pyyaml matplotlib
python3 deconto16_AIS_preprocess.py --scenario rcp26 --pipeline_id onemodule.deconto16.deconto16.AIS --baseyear 2005


# ---- Stage fit:

cd $BASEDIR
cp ./modules/deconto16/AIS/deconto16_AIS_fit.py $PIPELINEDIR
cd $PIPELINEDIR
PRINT 'tdict' TO SEE WHERE $RP_PILOT_SANDBOX IS COMING FROM:
 {'uid': 'task.000001', 'name': 'task1', 'state': 'DESCRIBED', 'state_history': ['DESCRIBED'], 'executable': 'python3', 'arguments': ['deconto16_AIS_fit.py', '--pipeline_id', 'onemodule.deconto16.deconto16.AIS'], 'environment': {}, 'sandbox': '', 'pre_launch': [], 'post_launch': [], 'pre_exec': ['. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true'], 'post_exec': [], 'cpu_reqs': {'cpu_processes': 1, 'cpu_process_type': 'None', 'cpu_threads': 1, 'cpu_thread_type': 'None'}, 'gpu_reqs': {'gpu_processes': 0.0, 'gpu_process_type': None, 'gpu_threads': 1, 'gpu_thread_type': None}, 'lfs_per_process': 0, 'mem_per_process': 0, 'upload_input_data': ['./modules/deconto16/AIS/deconto16_AIS_fit.py'], 'copy_input_data': [], 'link_input_data': [], 'move_input_data': [], 'copy_output_data': [], 'link_output_data': [], 'move_output_data': [], 'download_output_data': [], 'stdout': '', 'stderr': '', 'stage_on_error': False, 'exit_code': None, 'exception': None, 'exception_detail': None, 'path': '', 'tags': None, 'rts_uid': None, 'parent_stage': {'uid': 'stage.0001', 'name': 'fit'}, 'parent_pipeline': {'uid': 'pipeline.0000', 'name': 'onemodule.deconto16.deconto16.AIS'}}
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 deconto16_AIS_fit.py --pipeline_id onemodule.deconto16.deconto16.AIS


# ---- Stage project:

cd $BASEDIR
cp ./modules/deconto16/AIS/deconto16_AIS_project.py $PIPELINEDIR
cd $PIPELINEDIR
PRINT 'tdict' TO SEE WHERE $RP_PILOT_SANDBOX IS COMING FROM:
 {'uid': 'task.000002', 'name': 'task1', 'state': 'DESCRIBED', 'state_history': ['DESCRIBED'], 'executable': 'python3', 'arguments': ['deconto16_AIS_project.py', '--nsamps', 2000, '--pyear_start', 2020, '--pyear_end', 2150, '--pyear_step', 10, '--pipeline_id', 'onemodule.deconto16.deconto16.AIS'], 'environment': {}, 'sandbox': '', 'pre_launch': [], 'post_launch': [], 'pre_exec': ['. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true'], 'post_exec': [], 'cpu_reqs': {'cpu_processes': 1, 'cpu_process_type': 'None', 'cpu_threads': 1, 'cpu_thread_type': 'None'}, 'gpu_reqs': {'gpu_processes': 0.0, 'gpu_process_type': None, 'gpu_threads': 1, 'gpu_thread_type': None}, 'lfs_per_process': 0, 'mem_per_process': 0, 'upload_input_data': ['./modules/deconto16/AIS/deconto16_AIS_project.py'], 'copy_input_data': ['$Pipeline_onemodule.deconto16.deconto16.AIS_Stage_preprocess_Task_task1/onemodule.deconto16.deconto16.AIS_data.pkl'], 'link_input_data': [], 'move_input_data': [], 'copy_output_data': ['onemodule.deconto16.deconto16.AIS_AIS_globalsl.nc > $SHARED/to_total/global/onemodule.deconto16.deconto16.AIS_AIS_globalsl.nc'], 'link_output_data': [], 'move_output_data': [], 'download_output_data': ['onemodule.deconto16.deconto16.AIS_EAIS_globalsl.nc > experiments/onemodule/output/onemodule.deconto16.deconto16.AIS_EAIS_globalsl.nc', 'onemodule.deconto16.deconto16.AIS_AIS_globalsl.nc > experiments/onemodule/output/onemodule.deconto16.deconto16.AIS_AIS_globalsl.nc', 'onemodule.deconto16.deconto16.AIS_WAIS_globalsl.nc > experiments/onemodule/output/onemodule.deconto16.deconto16.AIS_WAIS_globalsl.nc'], 'stdout': '', 'stderr': '', 'stage_on_error': False, 'exit_code': None, 'exception': None, 'exception_detail': None, 'path': '', 'tags': None, 'rts_uid': None, 'parent_stage': {'uid': 'stage.0002', 'name': 'project'}, 'parent_pipeline': {'uid': 'pipeline.0000', 'name': 'onemodule.deconto16.deconto16.AIS'}}
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
python3 deconto16_AIS_project.py --nsamps 2000 --pyear_start 2020 --pyear_end 2150 --pyear_step 10 --pipeline_id onemodule.deconto16.deconto16.AIS

cp onemodule.deconto16.deconto16.AIS_EAIS_globalsl.nc $OUTPUTDIR
cp onemodule.deconto16.deconto16.AIS_AIS_globalsl.nc $OUTPUTDIR
cp onemodule.deconto16.deconto16.AIS_WAIS_globalsl.nc $OUTPUTDIR

# ---- Stage postprocess:

cd $BASEDIR
cp ./modules-data/grd_fingerprints_data.tgz ./modules/deconto16/AIS/deconto16_AIS_postprocess.py ./modules/deconto16/AIS/ReadFingerprint.py ./modules/deconto16/AIS/read_locationfile.py ./modules/deconto16/AIS/AssignFP.py $PIPELINEDIR
cd $PIPELINEDIR
PRINT 'tdict' TO SEE WHERE $RP_PILOT_SANDBOX IS COMING FROM:
 {'uid': 'task.000003', 'name': 'task1', 'state': 'DESCRIBED', 'state_history': ['DESCRIBED'], 'executable': 'python3', 'arguments': ['deconto16_AIS_postprocess.py', '--pipeline_id', 'onemodule.deconto16.deconto16.AIS'], 'environment': {}, 'sandbox': '', 'pre_launch': [], 'post_launch': [], 'pre_exec': ['. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true', 'tar -xvf grd_fingerprints_data.tgz 2> /dev/null; rm grd_fingerprints_data.tgz'], 'post_exec': [], 'cpu_reqs': {'cpu_processes': 1, 'cpu_process_type': 'None', 'cpu_threads': 1, 'cpu_thread_type': 'None'}, 'gpu_reqs': {'gpu_processes': 0.0, 'gpu_process_type': None, 'gpu_threads': 1, 'gpu_thread_type': None}, 'lfs_per_process': 0, 'mem_per_process': 0, 'upload_input_data': ['./modules-data/grd_fingerprints_data.tgz', './modules/deconto16/AIS/deconto16_AIS_postprocess.py', './modules/deconto16/AIS/ReadFingerprint.py', './modules/deconto16/AIS/read_locationfile.py', './modules/deconto16/AIS/AssignFP.py'], 'copy_input_data': ['$Pipeline_onemodule.deconto16.deconto16.AIS_Stage_project_Task_task1/onemodule.deconto16.deconto16.AIS_projections.pkl', '$SHARED/location.lst'], 'link_input_data': [], 'move_input_data': [], 'copy_output_data': ['onemodule.deconto16.deconto16.AIS_AIS_localsl.nc > $SHARED/to_total/local/onemodule.deconto16.deconto16.AIS_AIS_localsl.nc'], 'link_output_data': [], 'move_output_data': [], 'download_output_data': ['onemodule.deconto16.deconto16.AIS_EAIS_localsl.nc > experiments/onemodule/output/onemodule.deconto16.deconto16.AIS_EAIS_localsl.nc', 'onemodule.deconto16.deconto16.AIS_WAIS_localsl.nc > experiments/onemodule/output/onemodule.deconto16.deconto16.AIS_WAIS_localsl.nc', 'onemodule.deconto16.deconto16.AIS_AIS_localsl.nc > experiments/onemodule/output/onemodule.deconto16.deconto16.AIS_AIS_localsl.nc'], 'stdout': '', 'stderr': '', 'stage_on_error': False, 'exit_code': None, 'exception': None, 'exception_detail': None, 'path': '', 'tags': None, 'rts_uid': None, 'parent_stage': {'uid': 'stage.0003', 'name': 'postprocess'}, 'parent_pipeline': {'uid': 'pipeline.0000', 'name': 'onemodule.deconto16.deconto16.AIS'}}
. $RP_PILOT_SANDBOX/env/rp_named_env.rp.sh || true
tar -xvf grd_fingerprints_data.tgz 2> /dev/null; rm grd_fingerprints_data.tgz
python3 deconto16_AIS_postprocess.py --pipeline_id onemodule.deconto16.deconto16.AIS

cp onemodule.deconto16.deconto16.AIS_EAIS_localsl.nc $OUTPUTDIR
cp onemodule.deconto16.deconto16.AIS_WAIS_localsl.nc $OUTPUTDIR
cp onemodule.deconto16.deconto16.AIS_AIS_localsl.nc $OUTPUTDIR
