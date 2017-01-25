#!/bin/bash -e

vault read -field=bosh-cacert secret/$VAULT_PROPERTIES_PATH > ca
bosh_client=$(vault read -field=bosh-client-id secret/$VAULT_PROPERTIES_PATH)
bosh_secret=$(vault read -field=bosh-secret secret/$VAULT_PROPERTIES_PATH)
bosh_url=$(vault read -field=bosh-url secret/$VAULT_PROPERTIES_PATH)

bosh -n -d mysql -e $bosh_url --ca-cert ca --cliet $bosh_client --client-secret $bosh_client_secret run-errand $BOSH_ERRAND

