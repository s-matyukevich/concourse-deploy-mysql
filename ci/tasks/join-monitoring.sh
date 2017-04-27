#!/bin/bash -e

BASEDIR=$(dirname "$0")
source $BASEDIR/common.sh  $VAULT_PROPERTIES_PATH

bosh vms | grep mysql | awk '{print $1}' | xargs -I id bosh ssh id 'sudo /var/vcap/jobs/mysql/bin/join-monitoring'
