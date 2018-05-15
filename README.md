#Docker Freeswitch Image
A simple Docker container for running freeswitch.  The default settings will allow connections where the sip from user domain name will all be bridged into the same conference.

Any environment variable starting with FS_ will be passed into freeswitch automatically.

There are a few defaulted FS_* config variables for the default config:

*  FS_EVENT_PASSWORD - the event socket password (random if not set)
*  FS_EVENT_PORT - the event socket port (8020 if not set)
*  FS_DEFAULT_PASSWORD - default password in freeswitch (random if not set)
*  FS_XMLRPC_USER - the user for basic auth when doing http xmlrpc requests (random if not set)
*  FS_XMLRPC_PASSWORD - the password for basic auth when doing http xmlrpc requests
*  FS_XMLRPC_PORT - the port to use when doing http xmlrpc requests(8080 by default)
*  FS_WS_PORT - the port to use for plain text websocket-sip connections(7480 by default)
*  FS_WSS_PORT - the port to use for SSL/TLS websocket-sip connections(7443 by default)
*  FS_SIP_PORT - the port to use for plain text tcp/udp sip connections(5060 by default)
*  FS_TLS_PORT - the port to use for TLS sip connections(5061 by default)

No ports are forwarded by default so any ports you want open to the host you must set on the docker run command.

##Example build:

```
docker build -t fsd .
```

##Example run:

```
docker run --rm -it -p 7480:7480 fsd:latest
```

##Example changing port and password:

```
docker run --rm -it -p 5480:5480 -e "FS_WS_PORT=5480" -e "FS_XMLRPC_PASSWORD=TEST" fsd:latest
```