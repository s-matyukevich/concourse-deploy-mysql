#!/bin/bash -e

cat > /tmp/tmp-manifest.yml < $MANIFEST

BASEDIR=$(dirname "$0")
source $BASEDIR/common.sh  $VAULT_PROPERTIES_PATH

props=$(vault read -field=bosh-variables secret/mysql-props || true)
echo "$props" > /tmp/props.yml

scdc_ips=${SCDC1_MASTER_IPS#"["}
scdc_ips=${scdc_ips%"]"}
wdc_ips=${WDC1_MASTER_IPS#"["}
wdc_ips=${wdc_ips%"]"}
cluster_ips="[$scdc_ips,$wdc_ips,$ARBITRATOR_IP,$BACKUP_IP]"
IFS=',' read -ra scdc_ip_array <<< "$scdc_ips"
IFS=',' read -ra wdc_ip_array <<< "$wdc_ips"

bosh interpolate /tmp/tmp-manifest.yml \
  -o concourse-deploy-mysql/ci/opfiles/common.yml \
  -v cluster-ips=$cluster_ips \
  -v arbitrator-ip=$ARBITRATOR_IP \
  -v backup-ip=$BACKUP_IP \
  -v scdc1-master-ips=$SCDC1_MASTER_IPS \
  -v scdc1-proxy-ip=$SCDC1_PROXY_IP \
  -v scdc1-broker-ip=$SCDC1_BROKER_IP \
  -v wdc1-master-ips=$WDC1_MASTER_IPS \
  -v wdc1-proxy-ip=$WDC1_PROXY_IP \
  -v wdc1-broker-ip=$WDC1_BROKER_IP \
  -v scdc1-master-nodes=${#scdc_ip_array[@]} \
  -v wdc1-master-nodes=${#wdc_ip_array[@]} \
  --vars-store /tmp/props.yml   > deployment.yml
  
vault write secret/mysql-props bosh-variables=@/tmp/props.yml

bosh -n deploy deployment.yml
