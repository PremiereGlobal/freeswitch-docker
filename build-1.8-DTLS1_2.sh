#!/bin/bash

docker build -t freeswitch-docker:1.8-dtls-latest . -f Dockerfile-1.8-DTLS1_2

FS_18_DTLS_TMP=$(docker run --rm --entrypoint="" -it freeswitch-docker:1.8-dtls-latest /opt/freeswitch/bin/freeswitch -version 2> /dev/null)
echo "--------------==="
echo $FS_18_DTLS_TMP
echo "--------------==="

FS_18_DTLS_V_A=(${FS_18_DTLS_TMP[@]})
FS_18_DTLS_VERSION=${FS_18_DTLS_V_A[2]}
FS_18_DTLS_VERSION=(${FS_18_DTLS_VERSION//+/ })
FS_18_DTLS_VERSION="${FS_18_DTLS_VERSION[0]}"
FS_18_DTLS_A=(${FS_18_DTLS_VERSION//./ })
FS_18_DTLS_A=(${FS_18_DTLS_A[@]})
FS_18_DTLS_MM="${FS_18_DTLS_A[0]}.${FS_18_DTLS_A[1]}"
FS_18_DTLS_VERSION="${FS_18_DTLS_VERSION}-DTLS"
FS_18_DTLS_MM="${FS_18_DTLS_MM}-DTLS"

docker tag freeswitch-docker:1.8-dtls-latest readytalk/freeswitch-docker:${FS_18_DTLS_VERSION}
docker tag freeswitch-docker:1.8-dtls-latest readytalk/freeswitch-docker:${FS_18_DTLS_MM}
docker tag freeswitch-docker:1.8-dtls-latest readytalk/freeswitch-docker:1.8-DTLS-latest

echo "-----------------------"
echo "Saved Tag \"readytalk/freeswitch-docker:${FS_18_DTLS_VERSION}\""
echo "Saved Tag \"readytalk/freeswitch-docker:${FS_18_DTLS_MM}\""
echo "-----------------------"

if [[ -n $GITHUB_ACTION && -n $DOCKER_USER && -n $DOCKER_TOKEN ]]; then
  docker push readytalk/freeswitch-docker:${FS_18_DTLS_VERSION}
  docker push readytalk/freeswitch-docker:${FS_18_DTLS_MM}
  docker push readytalk/freeswitch-docker:1.8-DTLS-latest
fi

