#!/bin/bash -e

bosh -n upload-release $RELEASE_URL
bosh -n upload-stemcell vsphere-stemcell/stemcell.tgz
