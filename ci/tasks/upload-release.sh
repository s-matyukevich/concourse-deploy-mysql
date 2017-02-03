#!/bin/bash -e

BASEDIR=$(dirname "$0")

$BASEDIR/common.sh  $CONTROL_PLANE_VAULT_PROPERTIES_PATH

bosh -n upload-release $RELEASE_URL
bosh -n upload-stemcell vsphere-stemcell/stemcell.tgz

$BASEDIR/common.sh  $SCDC1_VAULT_PROPERTIES_PATH

bosh -n upload-release $RELEASE_URL
bosh -n upload-stemcell vsphere-stemcell/stemcell.tgz

$BASEDIR/common.sh  $WDC1_VAULT_PROPERTIES_PATH

bosh -n upload-release $RELEASE_URL
bosh -n upload-stemcell vsphere-stemcell/stemcell.tgz
