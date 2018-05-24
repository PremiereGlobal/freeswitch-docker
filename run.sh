#!/usr/bin/dumb-init /bin/bash

. /env.sh

DEFAULT_FS_EVENT_PASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
DEFAULT_FS_DEFAULT_PASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
DEFAULT_FS_WS_PORT=7480
DEFAULT_FS_WSS_PORT=7443
DEFAULT_FS_SIP_PORT=5060
DEFAULT_FS_TLS_PORT=5061
DEFAULT_FS_EVENT_PORT=8020
DEFAULT_FS_XMLRPC_PORT=8080
DEFAULT_FS_XMLRPC_USER=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
DEFAULT_FS_XMLRPC_PASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

rm -rf /etc/freeswitch/envVars/*
for var in ${!DEFAULT_FS*}; do
  t=${var/DEFAULT_/}
  if [ -z ${!t} ]; then
    echo "Using default for ${t}:${!var}"
    eval ${t}=${!var}
    export "${t}"
  else
    echo "Using override value for ${t}"
  fi
done

echo -e "[default]\npassword=${DEFAULT_FS_EVENT_PASSWORD}\nport=${DEFAULT_FS_EVENT_PORT}\n" > /etc/fs_cli.conf


for var in $(compgen -e); do
  if [[ $var == FS_* ]]; then
    echo "<X-PRE-PROCESS cmd=\"set\" data=\"${var}=${!var}\"/>" > "/etc/freeswitch/envVars/${var}.xml"
  fi
done
exec "${@}"
