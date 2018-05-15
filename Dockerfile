FROM debian:jessie

RUN apt-get update
RUN apt-get dist-upgrade -y --force-yes
RUN apt-get install -y --force-yes --no-install-recommends curl

#debug tools
#RUN apt-get install -y --force-yes vim net-tools less

RUN curl -k https://files.freeswitch.org/repo/deb/debian/freeswitch_archive_g0.pub | apt-key add -
RUN echo 'deb http://files.freeswitch.org/repo/deb/freeswitch-1.6/ jessie main' > /etc/apt/sources.list.d/freeswitch.list
RUN apt-get update

RUN apt-get install -y --force-yes --no-install-recommends freeswitch-conf-curl freeswitch-mod-b64 freeswitch-mod-blacklist freeswitch-mod-cdr-csv freeswitch-mod-cdr-pg-csv freeswitch-mod-cdr-sqlite freeswitch-mod-cidlookup freeswitch-mod-commands freeswitch-mod-conference freeswitch-mod-console freeswitch-mod-curl freeswitch-mod-db freeswitch-mod-dialplan-xml freeswitch-mod-dptools freeswitch-mod-enum freeswitch-mod-event-socket freeswitch-mod-expr freeswitch-mod-fifo freeswitch-mod-format-cdr freeswitch-mod-fsv freeswitch-mod-g723-1 freeswitch-mod-g729 freeswitch-mod-graylog2 freeswitch-mod-hash freeswitch-mod-httapi freeswitch-mod-json-cdr freeswitch-mod-local-stream freeswitch-mod-logfile freeswitch-mod-loopback freeswitch-mod-lua freeswitch-mod-native-file freeswitch-mod-opus freeswitch-mod-posix-timer freeswitch-mod-prefix freeswitch-mod-python freeswitch-mod-radius-cdr freeswitch-mod-random freeswitch-mod-rtc freeswitch-mod-sndfile freeswitch-mod-snmp freeswitch-mod-sofia freeswitch-mod-spandsp freeswitch-mod-spy freeswitch-mod-syslog freeswitch-mod-timerfd freeswitch-mod-tone-stream freeswitch-mod-valet-parking freeswitch-mod-xml-cdr freeswitch-mod-xml-curl freeswitch-mod-xml-rpc freeswitch-mod-yaml freeswitch-systemd freeswitch-timezones freeswitch-conf-vanilla freeswitch

RUN apt-get clean

RUN rm -rf /etc/freeswitch/sip_profiles/*
RUN rm -rf /etc/freeswitch/dialplan/*

#setup dumb-init
RUN curl -k -L https://github.com/Yelp/dumb-init/releases/download/v1.2.1/dumb-init_1.2.1_amd64 > /usr/bin/dumb-init
RUN chmod 755 /usr/bin/dumb-init

#enable modules
RUN sed -i -e 's/.*<load module="mod_xml_cdr"\/>.*/<load module="mod_xml_cdr"\/>/g' /etc/freeswitch/autoload_configs/modules.conf.xml
RUN sed -i -e 's/.*<load module="mod_xml_rpc"\/>.*/<load module="mod_xml_rpc"\/>/g' /etc/freeswitch/autoload_configs/modules.conf.xml
#disable modules
RUN sed -i -e 's/.*<load module="mod_verto"\/>.*/<!--<load module="mod_verto"\/>-->/g' /etc/freeswitch/autoload_configs/modules.conf.xml
RUN sed -i -e 's/.*<load module="mod_voicemail"\/>.*/<!--<load module="mod_voicemail"\/>-->/g' /etc/freeswitch/autoload_configs/modules.conf.xml
RUN sed -i -e 's/.*<load module="mod_dialplan_asterisk"\/>.*/<!--<load module="mod_dialplan_asterisk"\/>-->/g' /etc/freeswitch/autoload_configs/modules.conf.xml

#configure default password
RUN sed -i -e 's/.*<X-PRE-PROCESS cmd="set" data="default_password=1234"\/>.*/<X-PRE-PROCESS cmd="set" data="default_password=$${FS_DEFAULT_PASSWD}"\/>/g' /etc/freeswitch/vars.xml
#configure aws IP (will be "" if not in aws)
RUN sed -i '1 a <X-PRE-PROCESS cmd="exec-set" data="external_aws_ip=curl -s http://169.254.169.254/latest/meta-data/public-ipv4"/>' /etc/freeswitch/vars.xml
#add vars include dir
RUN sed -i '1 a <X-PRE-PROCESS cmd="include" data="envVars/*.xml"/>' /etc/freeswitch/vars.xml
RUN mkdir /etc/freeswitch/envVars

#configure eventport
RUN sed -i -e 's/.*<param name="listen-ip" value="::"\/>.*/<param name="listen-ip" value="0.0.0.0"\/>/g' /etc/freeswitch/autoload_configs/event_socket.conf.xml
RUN sed -i -e 's/.*<param name="listen-port" value="8021"\/>.*/<param name="listen-port" value="$${FS_EVENT_PORT}"\/>/g' /etc/freeswitch/autoload_configs/event_socket.conf.xml
RUN sed -i -e 's/.*<param name="password" value="ClueCon"\/>.*/<param name="password" value="$${FS_EVENT_PASSWORD}"\/>/g' /etc/freeswitch/autoload_configs/event_socket.conf.xml
#configure xmlrpc
RUN sed -i -e 's/.*<param name="http-port" value="8080"\/>.*/<param name="http-port" value="$${FS_XMLRPC_PORT}"\/>/g' /etc/freeswitch/autoload_configs/xml_rpc.conf.xml
RUN sed -i -e 's/.*<param name="auth-user" value="freeswitch"\/>.*/<param name="auth-user" value="$${FS_XMLRPC_USER}"\/>/g' /etc/freeswitch/autoload_configs/xml_rpc.conf.xml
RUN sed -i -e 's/.*<param name="auth-pass" value="works"\/>.*/<param name="auth-pass" value="$${FS_XMLRPC_PASSWORD}"\/>/g' /etc/freeswitch/autoload_configs/xml_rpc.conf.xml

#add generic profile
COPY configs/sip-profile.xml /etc/freeswitch/sip_profiles/
#add generic config
COPY configs/sip-dialplan.xml /etc/freeswitch/dialplan/
#add generic conference config
COPY configs/conference.conf.xml /etc/freeswitch/autoload_configs/
#add run.sh
COPY run.sh /


CMD /run.sh
