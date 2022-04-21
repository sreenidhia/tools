PERSONAL_ACCESS_TOKEN=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
POPRUN_PREFIX='poprun --num-replicas 4 --ipus-per-replica 4 --num-instances 4'

run_retinanet_sdk() {
  SDK_VERSION=$1
  WORKING_DIR=sdk_$SDK_VERSION

  mkdir $WORKING_DIR
  pushd $WORKING_DIR

  # clone repo
  git clone https://$PERSONAL_ACCESS_TOKEN@github.com/graphcore/retinanet_mlperf.git retinanet_mlperf

  pushd retinanet_mlperf/retinanet_ipu
  VIRTUALENV=venv3.6_sdk$SDK_VERSION
  virtualenv -p /usr/bin/python3.6 $VIRTUALENV
  source $VIRTUALENV/bin/activate
  pip install -r requirements.txt
  popd

  # Download the sdk in current folder
  POPSDK_SDKS_DIR=$PWD popsdk-download $SDK_VERSION

  # untar the sdk tarball
  for i in *.tar.gz;do
    tar -xvzf $i
  done

  set -- ./poplar*/
  SDK_FOLDER=$1

  pushd $SDK_FOLDER
  find . -type f -name 'tensorflow-1*intel_skylake512-cp36-cp36m-linux_x86_64.whl' -exec pip install {} \;
  POPLAR_FOLDER=$(find . -type d -name 'poplar-ubuntu*')
  source $POPLAR_FOLDER/enable.sh
  popd

  pushd retinanet_mlperf/retinanet_ipu
  make
  POPLAR_ENGINE_OPTIONS='{"autoReport.all":"true", "debug.allowOutOfMemory":"true", "autoReport.directory":"./pv"}' $POPRUN_PREFIX python3 train.py --config 'retinanet_default_config' 2>&1 | tee LOG
  popd
  popd
}

# banner 2.6.0-EA.1+918
# run_retinanet_sdk 2.6.0-EA.1+918

banner 2.5.0-EA.1+895
run_retinanet_sdk 2.5.0-EA.1+895

banner 2.5.0+909
run_retinanet_sdk 2.5.0+909

banner 2.5.0+924
run_retinanet_sdk 2.5.0+924

banner 2.5.0+934
run_retinanet_sdk 2.5.0+934

banner 2.5.0+952
run_retinanet_sdk 2.5.0+952

banner 2.5.0+953
run_retinanet_sdk 2.5.0+953

