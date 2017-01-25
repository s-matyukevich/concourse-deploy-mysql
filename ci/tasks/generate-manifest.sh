#!/bin/bash -e

cat > /tmp/tmp-manifest.yml < $MANIFEST

props=$(vault read -field=bosh-variables secret/mysql-props || true)
echo "$props" > /tmp/props.yml

bosh interpolate /tmp/tmp-manifest.yml \
  -o concourse-deploy-mysql/ci/opfiles/common.yml \
  -v arbitrator-ip=$ARBITRATOR_IP \
  -v scdc1-master-ip=$SCDC1_MASTER_IP \
  -v scdc1-proxy-ip=$SCDC1_PROXY_IP \
  -v wdc1-master-ip=$WDC1_MASTER_IP \
  -v wdc1-proxy-ip=$WDC1_PROXY_IP \
  --vars-store /tmp/props.yml   > manifest/deployment.yml
  
vault write secret/mysql-props bosh-variables=@/tmp/props.yml
