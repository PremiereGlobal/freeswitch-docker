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

#setup dumb-init
RUN curl -k -L https://github.com/Yelp/dumb-init/releases/download/v1.2.1/dumb-init_1.2.1_amd64 > /usr/bin/dumb-init
RUN chmod 755 /usr/bin/dumb-init

#run config changes
COPY configs/updatefs.sh /
RUN /updatefs.sh
RUN rm /updatefs.sh

#add generic profile
COPY configs/sip-profile.xml /etc/freeswitch/sip_profiles/
#add generic config
COPY configs/sip-dialplan.xml /etc/freeswitch/dialplan/
#add generic conference config
COPY configs/conference.conf.xml /etc/freeswitch/autoload_configs/
COPY configs/json_cdr.conf.xml /etc/freeswitch/autoload_configs/
#add run.sh
COPY run.sh /
RUN touch /env.sh


ENTRYPOINT ["/run.sh"]
CMD ["/usr/bin/freeswitch", "-nonat", "-nf", "-nc"]
