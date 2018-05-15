FROM debian:jessie

RUN apt-get update
RUN apt-get dist-upgrade -y --force-yes
RUN apt-get install -y --force-yes curl
RUN curl https://files.freeswitch.org/repo/deb/debian/freeswitch_archive_g0.pub | apt-key add -
RUN echo 'deb http://files.freeswitch.org/repo/deb/freeswitch-1.6/ jessie main' > /etc/apt/sources.list.d/freeswitch.list
RUN apt-get update
RUN apt-get install -y --force-yes freeswitch-all
RUN rm -rf /etc/freeswitch/sip_profiles/*
RUN rm -rf /etc/freeswitch/dialplan/*

#enable modules
RUN sed -i -e 's/.*<load module="mod_xml_cdr"\/>.*/<load module="mod_xml_cdr"\/>/g' /etc/freeswitch/autoload_configs/modules.conf.xml
#disable modules
RUN sed -i -e 's/.*<load module="mod_verto"\/>.*/<!--<load module="mod_verto"\/>-->/g' /etc/freeswitch/autoload_configs/modules.conf.xml
RUN sed -i -e 's/.*<load module="mod_voicemail"\/>.*/<!--<load module="mod_voicemail"\/>-->/g' /etc/freeswitch/autoload_configs/modules.conf.xml
RUN sed -i -e 's/.*<load module="mod_dialplan_asterisk"\/>.*/<!--<load module="mod_dialplan_asterisk"\/>-->/g' /etc/freeswitch/autoload_configs/modules.conf.xml

RUN sed -i '1 a <X-PRE-PROCESS cmd="exec-set" data="external_aws_ip=curl -s http://169.254.169.254/latest/meta-data/public-ipv4"/>' /etc/freeswitch/vars.xml

COPY configs/sip-profile.xml /etc/freeswitch/sip_profiles/
COPY configs/sip-dialplan.xml /etc/freeswitch/dialplan/
