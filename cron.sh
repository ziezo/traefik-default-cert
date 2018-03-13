#!/bin/bash

#domain to extract
DOMAIN="${CERT_DOMAIN}"

#extract fullchain.pem, privkey.pem, cert.pem, and chain.pem to this directory
OUTPUTDIR="/cert"

#traefik acme.json file
ACME_JSON="/acme.json"

#command to execute on changed cert
CMD="/on-change.sh"

###########################################################

echo "###### `date` started" 

/acme-cert-dump.py --post-update "$CMD" "$ACME_JSON" "$DOMAIN" $OUTPUTDIR 

echo "###### `date` completed" 
