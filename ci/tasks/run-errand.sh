#!/bin/bash -e

BASEDIR=$(dirname "$0")
source $BASEDIR/common.sh  $VAULT_PROPERTIES_PATH

bosh -n run-errand $BOSH_ERRAND

