#!/bin/bash

rm -rf /etc/freeswitch/sip_profiles/*
rm -rf /etc/freeswitch/dialplan/*

#configure default password
sed -i -e 's/.*<X-PRE-PROCESS cmd="set" data="default_password=1234"\/>.*/<X-PRE-PROCESS cmd="set" data="default_password=$${FS_DEFAULT_PASSWORD}"\/>/g' /etc/freeswitch/vars.xml
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
#configure rtp ports
sed -i -e 's/.*<param name="rtp-start-port".*/<param name="rtp-start-port" value="$${FS_RTP_START_PORT}"\/>/g' /etc/freeswitch/autoload_configs/switch.conf.xml
sed -i -e 's/.*<param name="rtp-end-port".*/<param name="rtp-end-port" value="$${FS_RTP_END_PORT}"\/>/g' /etc/freeswitch/autoload_configs/switch.conf.xml
sed -i -e 's/.*<param name="rtp-port-usage-robustness".*/<param name="rtp-port-usage-robustness" value="$${FS_RTP_PORT_CHECK}"\/>/g' /etc/freeswitch/autoload_configs/switch.conf.xml
#configure Sessions
sed -i -e 's/.*<param name="max-sessions".*/<param name="max-sessions" value="$${FS_MAX_SESSION}"\/>/g' /etc/freeswitch/autoload_configs/switch.conf.xml
sed -i -e 's/.*<param name="sessions-per-second".*/<param name="sessions-per-second" value="$${FS_SESSION_PER_SECOND}"\/>/g' /etc/freeswitch/autoload_configs/switch.conf.xml



ln -sf /dev/stdout /var/log/freeswitch/freeswitch.log
ln -sf /dev/stdout /var/log/freeswitch/freeswitch_http.log

