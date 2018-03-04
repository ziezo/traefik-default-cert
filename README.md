## traefik-cert-cron

Docker Hub: [ziezo/traefik-default-cert](https://hub.docker.com/r/ziezo/traefik-default-cert/)

Set default traefik certificate.

Extracts a specific certificate from acme.json and restart traefik container on changed cert. Can be used to setup a default cert for traefik, so that non SNI clients like IE8 work correctly.

### Setup

- edit traefik.toml
- touch acme.json
- edit docker-compose.yml
- docker-compose up -d

### traefik.toml example

`[entryPoints]  
...  
  [entryPoints.https]  
  address = ":443"  
    [entryPoints.https.tls]  
      #define default cert to use when no SNI match is found  
      [[entryPoints.https.tls.certificates]]  
      certFile = "/cert/fullchain.pem"  
      keyFile = "/cert/privkey.pem"  
...  
#define the default certificate  
[[acme.domains]]  
main= "__DEFAULT.YOURDOMAIN.COM__"  
sans=[  
"__YOURDOMAIN.COM__",  
"__WWW.YOURDOMAIN.COM__"  
]`

### docker-compose example

`version: "2.3"  
services:  
  
###################################################################################  
# traefik-default-cert  
###################################################################################  
  traefik-default-cert:  
    container_name: traefik-default-cert  
    image: ziezo/traefik-default-cert  
    volumes:  
    #enable execution of docker inside container  
    - /var/run/docker.sock:/var/run/docker.sock  
    #acme.json  
    - ./traefik/vol/acme.json:/acme.json:ro  
    #extracted cert is stored here  
    - ./traefik/vol/cert:/cert  
    environment:  
    #domain to extract (MAIN domain, not SAN domain)  
    - "CERT_DOMAIN=__DEFAULT.YOURDOMAIN.COM__"  
    #container to restart after cert change  
    - "TRAEFIK_CONTAINER=traefik"  
    #cron time to run cert extract  
    - "CRON_TIME=0 1 * * *"  
    depends_on:  
    - traefik  
    restart: always  
  
  
###################################################################################  
# traefik  
###################################################################################  
  traefik:  
    container_name: traefik  
    image: traefik:1.5  
    command: --docker  
    ports:  
    - "80:80"  
    - "443:443"  
    volumes:  
    - /var/run/docker.sock:/var/run/docker.sock  
    - ./traefik/conf/traefik.toml:/traefik.toml:ro  
    - ./traefik/vol/acme.json:/acme.json  
    - ./traefik/vol/cert:/cert:ro  
    restart: always`

### Sources

acme-cert-dump.py creates fullchain.pem and privkey.pem  
[JayH5/acme-cert-dump.py](https://gist.github.com/JayH5/f9e4dc48635f3faa63c52813ff6d115f)

acme-cert-all-dump.py  creates /cert/path/domain1.com.cert /cert/path/domain2.com.cert  
[JayH5/acme-cert-dump-all.py](https://gist.github.com/JayH5/1a427e2f52444f45280f30215d5a92d9)
