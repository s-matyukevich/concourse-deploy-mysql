#!/bin/bash -e

BASEDIR=$(dirname "$0")
source $BASEDIR/common.sh  $VAULT_PROPERTIES_PATH
#process to take db backup using mysqldump

bosh -n start backup/0
bosh -n stop backup/0
