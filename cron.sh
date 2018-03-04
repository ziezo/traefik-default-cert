#!/bin/bash

#domain to extract
DOMAIN="${CERT_DOMAIN}"

#extract fullchain.pem and privkey.pem to this directory
OUTPUTDIR="/cert"

#traefik acme.json file
ACME_JSON="/acme.json"

#container to restart on changed cert
CONTAINER="${TRAEFIK_CONTAINER}"

###########################################################

echo "###### `date` started" 

/acme-cert-dump.py --post-update "docker restart $CONTAINER" "$ACME_JSON" "$DOMAIN" $OUTPUTDIR 

echo "###### `date` completed" 
