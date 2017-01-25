#!/bin/bash -e

cat > manifest/tmp.yml < $MANIFEST

bosh interpolate manifest/tmp.yml -o concourse-deploy-mysql/ci/opfiles/common.yml > manifest/deployment.yml
