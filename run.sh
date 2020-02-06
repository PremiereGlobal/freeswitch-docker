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
DEFAULT_FS_RTP_START_PORT=16384
DEFAULT_FS_RTP_END_PORT=32768
DEFAULT_FS_RTP_PORT_CHECK="true"
DEFAULT_FS_SESSION_PER_SECOND=30
DEFAULT_FS_MAX_SESSION=1000
DEFAULT_FS_EXT_RTP_IP="$\\\${local_ip_v4}"
DEFAULT_FS_EXT_SIP_IP="$\\\${local_ip_v4}"
DEFAULT_FS_XMLRPC_USER=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
DEFAULT_FS_XMLRPC_PASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
DEFAULT_FS_SIP_CAPTURE="no"
DEFAULT_FS_SIP_CAPTURE_SERVER="false"
DEFAULT_FS_MOD_ENABLE_XML_CDR="false"
DEFAULT_FS_MOD_ENABLE_XML_RPC="true"
DEFAULT_FS_MOD_ENABLE_VERTO="false"
DEFAULT_FS_MOD_ENABLE_VOICEMAIL="false"
DEFAULT_FS_MOD_ENABLE_DIALPLAN_ASTERISK="false"
DEFAULT_FS_MOD_ENABLE_AV="true"
DEFAULT_FS_MOD_ADD_JSON_CDR="true"
DEFAULT_FS_SQLITE_MEMORY="false"

echo "disable env: ${FS_DISABLE_ENV}"

if [[ "${FS_DISABLE_ENV}" != "true" ]]; then

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


  echo -e "[default]\npassword=${FS_EVENT_PASSWORD}\nport=${FS_EVENT_PORT}\n" > /etc/fs_cli.conf


  for var in ${!FS_*}; do
    if [[ $var == FS_MOD_ENABLE_* ]]; then
      var1=${var#FS_MOD_ENABLE_*}
      var2=${var1,,}
      var3="mod_${var2}"
      if [[ "${!var}" == "true" ]]; then
        sed -i -e "s/.*<load module=\"${var3}\"\/>.*/<load module=\"${var3}\"\/>/g" /etc/freeswitch/autoload_configs/modules.conf.xml
      else 
        sed -i -e "s/.*<load module=\"${var3}\"\/>.*/<!--<load module=\"${var3}\"\/>-->/g" /etc/freeswitch/autoload_configs/modules.conf.xml
      fi
    elif [[ $var == FS_MOD_ADD_* ]]; then
      var1=${var#FS_MOD_ADD_*}
      var2=${var1,,}
      var3="mod_${var2}"
      if [[ "${!var}" == "true" ]]; then
        sed -i -e "s/.*<\/modules>.*/<load module=\"${var3}\"\/>\n<\/modules>/g" /etc/freeswitch/autoload_configs/modules.conf.xml
      fi
    elif [[ $var == FS_* ]]; then
      echo "<X-PRE-PROCESS cmd=\"set\" data=\"${var}=${!var}\"/>" > "/etc/freeswitch/envVars/${var}.xml"
    fi
  done

  if [[ $FS_SIP_CAPTURE_SERVER != "false" ]]; then
    sed -i -e 's/.*<param name="capture-server".*/<param name="capture-server" value="$${FS_SIP_CAPTURE_SERVER}"\/>/g' /etc/freeswitch/autoload_configs/sofia.conf.xml
  fi

  if [[ $FS_SQLITE_MEMORY != "false" ]]; then
    sed -i -e 's/.*<!-- <param name="core-db-dsn" value="dsn:username:password" \/> -->.*/<param name="core-db-dsn" value="sqlite:\/\/memory:\/\/core.db" \/>/g' /etc/freeswitch/autoload_configs/switch.conf.xml
  fi
else
  echo "Disabled Freeswitch Environment setup, using config files only"
fi
exec "${@}"
