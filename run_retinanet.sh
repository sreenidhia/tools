PERSONAL_ACCESS_TOKEN=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
WORKING_DIR=$1
SDK_VERSION=2.6.0-EA.1+918

# clone repo
git clone https://$PERSONAL_ACCESS_TOKEN@github.com/graphcore/retinanet_mlperf.git retinanet_mlperf &

# Download the sdk
POPSDK_SDKS_DIR=$WORKING_DIR popsdk-download $SDK_VERSION

# untar the sdk tarball
for i in *.tar.gz;do
   tar -xvzf $i
done


set -- $WORKING_DIR/poplar*/
SDK_FOLDER=$1

cd retinanet_mlperf/retinanet_ipu
VIRTUALENV=venv3.6_sdk$SDK_VERSION
virtualenv -p /usr/bin/python3.6 $VIRTUALENV
source $VIRTUALENV/bin/activate
pip install -r requirements.txt
cd ../../

cd $SDK_FOLDER
find . -type f -name 'tensorflow-1*intel_skylake512-cp36-cp36m-linux_x86_64.whl' -exec pip install {} \;
cd ..


