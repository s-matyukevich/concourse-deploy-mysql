#!/bin/bash -e

BASEDIR=$(dirname "$0")

source $BASEDIR/common.sh  $CONTROL_PLANE_VAULT_PROPERTIES_PATH

bosh -n upload-release $RELEASE_URL
bosh -n upload-stemcell vsphere-stemcell/stemcell.tgz

source $BASEDIR/common.sh  $SCDC1_VAULT_PROPERTIES_PATH

bosh -n upload-release $RELEASE_URL
bosh -n upload-stemcell vsphere-stemcell/stemcell.tgz

source $BASEDIR/common.sh  $WDC1_VAULT_PROPERTIES_PATH

bosh -n upload-release $RELEASE_URL
bosh -n upload-stemcell vsphere-stemcell/stemcell.tgz
