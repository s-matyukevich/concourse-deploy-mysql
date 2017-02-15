#!/bin/bash -e

VAULT_PROPERTIES_PATH=$1

vault read -field=bosh-cacert secret/$VAULT_PROPERTIES_PATH > ca
export BOSH_CA_CERT=ca
export BOSH_CLIENT_SECRET=$(vault read -field=bosh-client-secret secret/$VAULT_PROPERTIES_PATH)
export BOSH_ENVIRONMENT=$(vault read -field=bosh-url secret/$VAULT_PROPERTIES_PATH)
export BOSH_CLIENT=director
