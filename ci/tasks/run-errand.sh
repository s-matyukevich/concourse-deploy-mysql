#!/bin/bash -e

vault read -field=bosh-cacert secret/$VAULT_PROPERTIES_PATH > ca
BOSH_CA_CERT=ca
BOSH_CLIENT_SECRET=$(vault read -field=bosh-client-secret secret/$VAULT_PROPERTIES_PATH)
BOSH_ENVIRONMENT=$(vault read -field=bosh-url secret/$VAULT_PROPERTIES_PATH)
BOSH_CLIENT=director
BOSH_DEPLOYMENT=mysql

bosh -n run-errand $BOSH_ERRAND

