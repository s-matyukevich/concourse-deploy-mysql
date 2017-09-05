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

export BOSH_CLIENT_SECRET=$(vault read -field=bosh-client-secret secret/$VAULT_PROPERTIES_PATH)

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
  -v monitoring-ip=$MONITORING_IP \
  -v syslog-address=$SYSLOG_ADDRESS \
  -v syslog-port=$SYSLOG_PORT \
  -v cf_admin_password=$(vault read -field=admin-password secret/$VAULT_PASSWORDS_PATH) \
  -v cf_api_url=https://api."$(vault read -field=system-domain secret/$VAULT_PROPERTIES_PATH)" \
  -v broker_url=mysql."$(vault read -field=system-domain secret/$VAULT_PROPERTIES_PATH)" \
  -v app_domains=$(vault read -field=app-domain secret/$VAULT_PROPERTIES_PATH) \
  -v nats_machines="[ $(vault read -field=nats-machine-ip secret/$VAULT_PROPERTIES_PATH) ]" \
  -v nats_password=$(vault read -field=nats-pass secret/$VAULT_PASSWORDS_PATH) \
  -v release-version=$RELEASE_VERSION \
  -v broker_name=$BROKER_NAME \
  -v environment=$ENVIRONMENT \
  --vars-store /tmp/props.yml   > deployment.yml
  
vault write secret/mysql-props bosh-variables=@/tmp/props.yml

bosh -n deploy deployment.yml
