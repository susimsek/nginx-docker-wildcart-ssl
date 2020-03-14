#!/bin/bash
# Ask the user for login details

if ! [ $(id -u) = 0 ]; then
   echo "The script need to be run as root." >&2
   exit 1
fi

if [ $SUDO_USER ]; then
    real_user=$SUDO_USER
else
    real_user=$(whoami)
fi

read -p 'domain : ' domain
echo
openssl req -x509 -nodes -days 3650 -subj "/C=CA/ST=QC/O=Company, Inc./CN=*.$domain" -addext "subjectAltName=DNS:*.$domain,DNS:$domain" -newkey rsa:2048 -keyout ./certs/server.key -out ./certs/server.crt
echo
echo "ssl certificate created"

sudo security add-trusted-cert \
  -d -r trustRoot \
  -k /Library/Keychains/System.keychain ./certs/server.crt