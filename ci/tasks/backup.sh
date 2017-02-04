#!/bin/bash -e

BASEDIR=$(dirname "$0")
source $BASEDIR/common.sh  $VAULT_PROPERTIES_PATH

bosh -n start backup/0
bosh -n stop backup/0
bosh -n take-snapshot backup/0
