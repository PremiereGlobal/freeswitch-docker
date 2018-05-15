#!/bin/bash

rm -rf /etc/freeswitch/sip_profiles/*
rm -rf /etc/freeswitch/dialplan/*

#enable modules
sed -i -e 's/.*<load module="mod_xml_cdr"\/>.*/<load module="mod_xml_cdr"\/>/g' /etc/freeswitch/autoload_configs/modules.conf.xml
sed -i -e 's/.*<load module="mod_xml_rpc"\/>.*/<load module="mod_xml_rpc"\/>/g' /etc/freeswitch/autoload_configs/modules.conf.xml
#disable modules
sed -i -e 's/.*<load module="mod_verto"\/>.*/<!--<load module="mod_verto"\/>-->/g' /etc/freeswitch/autoload_configs/modules.conf.xml
sed -i -e 's/.*<load module="mod_voicemail"\/>.*/<!--<load module="mod_voicemail"\/>-->/g' /etc/freeswitch/autoload_configs/modules.conf.xml
sed -i -e 's/.*<load module="mod_dialplan_asterisk"\/>.*/<!--<load module="mod_dialplan_asterisk"\/>-->/g' /etc/freeswitch/autoload_configs/modules.conf.xml

#configure default password
sed -i -e 's/.*<X-PRE-PROCESS cmd="set" data="default_password=1234"\/>.*/<X-PRE-PROCESS cmd="set" data="default_password=$${FS_DEFAULT_PASSWD}"\/>/g' /etc/freeswitch/vars.xml
#configure aws IP (will be "" if not in aws)
sed -i '1 a <X-PRE-PROCESS cmd="exec-set" data="external_aws_ip=curl -s http://169.254.169.254/latest/meta-data/public-ipv4"/>' /etc/freeswitch/vars.xml
#add vars include dir
sed -i '1 a <X-PRE-PROCESS cmd="include" data="envVars/*.xml"/>' /etc/freeswitch/vars.xml
mkdir /etc/freeswitch/envVars

#configure eventport
sed -i -e 's/.*<param name="listen-ip" value="::"\/>.*/<param name="listen-ip" value="0.0.0.0"\/>/g' /etc/freeswitch/autoload_configs/event_socket.conf.xml
sed -i -e 's/.*<param name="listen-port" value="8021"\/>.*/<param name="listen-port" value="$${FS_EVENT_PORT}"\/>/g' /etc/freeswitch/autoload_configs/event_socket.conf.xml
sed -i -e 's/.*<param name="password" value="ClueCon"\/>.*/<param name="password" value="$${FS_EVENT_PASSWORD}"\/>/g' /etc/freeswitch/autoload_configs/event_socket.conf.xml
#configure xmlrpc
sed -i -e 's/.*<param name="http-port" value="8080"\/>.*/<param name="http-port" value="$${FS_XMLRPC_PORT}"\/>/g' /etc/freeswitch/autoload_configs/xml_rpc.conf.xml
sed -i -e 's/.*<param name="auth-user" value="freeswitch"\/>.*/<param name="auth-user" value="$${FS_XMLRPC_USER}"\/>/g' /etc/freeswitch/autoload_configs/xml_rpc.conf.xml
sed -i -e 's/.*<param name="auth-pass" value="works"\/>.*/<param name="auth-pass" value="$${FS_XMLRPC_PASSWORD}"\/>/g' /etc/freeswitch/autoload_configs/xml_rpc.conf.xml
sed -i -e 's/.*<param name="rollover".*/<param name="rollover" value="0"\/>/g' /etc/freeswitch/autoload_configs/logfile.conf.xml

ln -sf /dev/stdout /var/log/freeswitch/freeswitch.log
ln -sf /dev/stdout /var/log/freeswitch/freeswitch_http.log

