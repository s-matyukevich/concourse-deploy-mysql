#!/bin/bash -e

cat > /tmp/tmp-manifest.yml < $MANIFEST

vault read -field=bosh-cacert secret/$VAULT_PROPERTIES_PATH > ca
bosh_client=$(vault read -field=bosh-client-id secret/$VAULT_PROPERTIES_PATH)
bosh_secret=$(vault read -field=bosh-client-secret secret/$VAULT_PROPERTIES_PATH)
bosh_url=$(vault read -field=bosh-url secret/$VAULT_PROPERTIES_PATH)


props=$(vault read -field=bosh-variables secret/mysql-props || true)
echo "$props" > /tmp/props.yml

bosh interpolate /tmp/tmp-manifest.yml \
  -o concourse-deploy-mysql/ci/opfiles/common.yml \
  -v arbitrator-ip=$ARBITRATOR_IP \
  -v scdc1-master-ip=$SCDC1_MASTER_IP \
  -v scdc1-proxy-ip=$SCDC1_PROXY_IP \
  -v wdc1-master-ip=$WDC1_MASTER_IP \
  -v wdc1-proxy-ip=$WDC1_PROXY_IP \
  --vars-store /tmp/props.yml   > deployment.yml
  
vault write secret/mysql-props bosh-variables=@/tmp/props.yml

bosh -n -d mysql -e $bosh_url --ca-cert ca --client $bosh_client --client-secret $bosh_client_secret deploy deployment.yml
