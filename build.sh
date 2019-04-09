#!/bin/bash

docker build -t freeswitch-docker:1.6-latest . -f Dockerfile-1.6
docker build -t freeswitch-docker:1.8-latest . -f Dockerfile-1.8
docker build -t freeswitch-docker:1.8-dtls-latest . -f Dockerfile-1.8-DTLS1_2

FS_16_TMP=$(docker run --rm --entrypoint="" -it freeswitch-docker:1.6-latest /usr/bin/freeswitch -version 2> /dev/null)
FS_18_TMP=$(docker run --rm --entrypoint="" -it freeswitch-docker:1.8-latest /usr/bin/freeswitch -version 2> /dev/null)
FS_18_DTLS_TMP=$(docker run --rm --entrypoint="" -it freeswitch-docker:1.8-dtls-latest /opt/freeswitch/bin/freeswitch -version 2> /dev/null)
echo "--------------==="
echo $FS_16_TMP
echo "--------------==="
echo $FS_18_TMP
echo "--------------==="
echo $FS_18_DTLS_TMP
echo "--------------==="

FS_16_V_A=(${FS_16_TMP[@]})
FS_16_VERSION=${FS_16_V_A[2]::-14}
FS_16_A=(${FS_16_VERSION//./ })
FS_16_A=(${FS_16_A[@]})
FS_16_MM="${FS_16_A[0]}.${FS_16_A[1]}"

FS_18_V_A=(${FS_18_TMP[@]})
FS_18_VERSION=${FS_18_V_A[2]::-14}
FS_18_A=(${FS_18_VERSION//./ })
FS_18_A=(${FS_18_A[@]})
FS_18_MM="${FS_18_A[0]}.${FS_18_A[1]}"

FS_18_DTLS_V_A=(${FS_18_DTLS_TMP[@]})
FS_18_DTLS_VERSION=${FS_18_DTLS_V_A[2]}
FS_18_DTLS_VERSION=(${FS_18_DTLS_VERSION//+/ })
FS_18_DTLS_VERSION="${FS_18_DTLS_VERSION[0]}"
FS_18_DTLS_A=(${FS_18_DTLS_VERSION//./ })
FS_18_DTLS_A=(${FS_18_DTLS_A[@]})
FS_18_DTLS_MM="${FS_18_DTLS_A[0]}.${FS_18_DTLS_A[1]}"
FS_18_DTLS_VERSION="${FS_18_DTLS_VERSION}-DTLS"
FS_18_DTLS_MM="${FS_18_DTLS_MM}-DTLS"



docker tag freeswitch-docker:1.6-latest readytalk/freeswitch-docker:${FS_16_VERSION}
docker tag freeswitch-docker:1.6-latest readytalk/freeswitch-docker:${FS_16_MM}
docker tag freeswitch-docker:1.6-latest readytalk/freeswitch-docker:1.6-latest

docker tag freeswitch-docker:1.8-latest readytalk/freeswitch-docker:${FS_18_VERSION}
docker tag freeswitch-docker:1.8-latest readytalk/freeswitch-docker:${FS_18_MM}
docker tag freeswitch-docker:1.8-latest readytalk/freeswitch-docker:1.8-latest

docker tag freeswitch-docker:1.8-dtls-latest readytalk/freeswitch-docker:${FS_18_DTLS_VERSION}
docker tag freeswitch-docker:1.8-dtls-latest readytalk/freeswitch-docker:${FS_18_DTLS_MM}
docker tag freeswitch-docker:1.8-dtls-latest readytalk/freeswitch-docker:1.8-DTLS-latest

echo "-----------------------"
echo "Saved Tag \"readytalk/freeswitch-docker:${FS_16_VERSION}\""
echo "Saved Tag \"readytalk/freeswitch-docker:${FS_16_MM}\""
echo "Saved Tag \"readytalk/freeswitch-docker:${FS_18_VERSION}\""
echo "Saved Tag \"readytalk/freeswitch-docker:${FS_18_MM}\""
echo "Saved Tag \"readytalk/freeswitch-docker:${FS_18_DTLS_VERSION}\""
echo "Saved Tag \"readytalk/freeswitch-docker:${FS_18_DTLS_MM}\""
echo "-----------------------"

if [[ ${TRAVIS} && "${TRAVIS_BRANCH}" == "master" && -n $DOCKER_USERNAME && -n $DOCKER_PASSWORD ]]; then
  docker login -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD"
  docker push readytalk/freeswitch-docker:${FS_16_VERSION}
  docker push readytalk/freeswitch-docker:${FS_16_MM}
  docker push readytalk/freeswitch-docker:1.6-latest
  docker push readytalk/freeswitch-docker:${FS_18_VERSION}
  docker push readytalk/freeswitch-docker:${FS_18_MM}
  docker push readytalk/freeswitch-docker:1.8-latest
  readytalk/freeswitch-docker:${FS_18_DTLS_VERSION}
  readytalk/freeswitch-docker:${FS_18_DTLS_MM}
  readytalk/freeswitch-docker:1.8-DTLS-latest
fi

