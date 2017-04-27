#!/bin/bash -e

BASEDIR=$(dirname "$0")

exit 0

source $BASEDIR/common.sh  $CONTROL_PLANE_VAULT_PROPERTIES_PATH

bosh -d ${ENVIRONMENT}cp-mysql -n upload-release $RELEASE_URL
bosh -d ${ENVIRONMENT}cp-mysql -n upload-stemcell vsphere-stemcell/stemcell.tgz

source $BASEDIR/common.sh  $WDC1_VAULT_PROPERTIES_PATH

bosh -d ${ENVIRONMENT}wdc1-mysql -n upload-release $RELEASE_URL
bosh -d ${ENVIRONMENT}wdc1-mysql -n upload-stemcell vsphere-stemcell/stemcell.tgz

source $BASEDIR/common.sh  $SCDC1_VAULT_PROPERTIES_PATH

bosh -d ${ENVIRONMENT}scdc1-mysql -n upload-release $RELEASE_URL
bosh -d ${ENVIRONMENT}scdc1-mysql -n upload-stemcell vsphere-stemcell/stemcell.tgz

