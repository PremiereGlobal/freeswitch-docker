#!/bin/bash

docker build -t freeswitch-docker:1.6-latest . -f Dockerfile-1.6
docker build -t freeswitch-docker:1.8-dtls-latest . -f Dockerfile-1.8-DTLS1_2
docker build -t freeswitch-docker:1.8-latest . -f Dockerfile-1.10-stretch
docker build -t freeswitch-docker:1.10-latest . -f Dockerfile-1.10-buster

FS_16_TMP=$(docker run --rm --entrypoint="" -it freeswitch-docker:1.6-latest /usr/bin/freeswitch -version 2> /dev/null)
FS_18_DTLS_TMP=$(docker run --rm --entrypoint="" -it freeswitch-docker:1.8-dtls-latest /opt/freeswitch/bin/freeswitch -version 2> /dev/null)
FS_110_stretch_TMP=$(docker run --rm --entrypoint="" -it freeswitch-docker:1.8-latest /usr/bin/freeswitch -version 2> /dev/null)
FS_110_buster_TMP=$(docker run --rm --entrypoint="" -it freeswitch-docker:1.10-latest /usr/bin/freeswitch -version 2> /dev/null)
echo "--------------==="
echo $FS_16_TMP
echo "--------------==="
echo $FS_18_DTLS_TMP
echo "--------------==="
echo $FS_110_stretch_TMP
echo "--------------==="
echo $FS_110_buster_TMP
echo "--------------==="

FS_16_V_A=(${FS_16_TMP[@]})
FS_16_VERSION=${FS_16_V_A[2]::-14}
FS_16_A=(${FS_16_VERSION//./ })
FS_16_A=(${FS_16_A[@]})
FS_16_MM="${FS_16_A[0]}.${FS_16_A[1]}"

FS_110_stretch_V_A=(${FS_110_stretch_TMP[@]})
FS_110_stretch_VERSION=${FS_110_stretch_V_A[2]::-14}
FS_110_stretch_A=(${FS_110_stretch_VERSION//-/ })
FS_110_stretch_A=(${FS_110_stretch_A[@]})
FS_110_stretch_VERSION="${FS_110_stretch_A[0]}-stretch"
FS_110_stretch_A=(${FS_110_stretch_VERSION//./ })
FS_110_stretch_A=(${FS_110_stretch_A[@]})
FS_110_stretch_MM="${FS_110_stretch_A[0]}.${FS_110_stretch_A[1]}-stretch"

FS_110_buster_V_A=(${FS_110_buster_TMP[@]})
FS_110_buster_VERSION=${FS_110_buster_V_A[2]::-14}
FS_110_buster_A=(${FS_110_buster_VERSION//-/ })
FS_110_buster_A=(${FS_110_buster_A[@]})
FS_110_buster_VERSION="${FS_110_buster_A[0]}-buster"
FS_110_buster_A=(${FS_110_buster_A[0]//./ })
FS_110_buster_A=(${FS_110_buster_A[@]})
FS_110_buster_MM="${FS_110_buster_A[0]}.${FS_110_buster_A[1]}-buster"

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

docker tag freeswitch-docker:1.8-latest readytalk/freeswitch-docker:${FS_110_stretch_VERSION}
docker tag freeswitch-docker:1.8-latest readytalk/freeswitch-docker:${FS_110_stretch_MM}
docker tag freeswitch-docker:1.8-latest readytalk/freeswitch-docker:1.10-stretch-latest

docker tag freeswitch-docker:1.10-latest readytalk/freeswitch-docker:${FS_110_buster_VERSION}
docker tag freeswitch-docker:1.10-latest readytalk/freeswitch-docker:${FS_110_buster_MM}
docker tag freeswitch-docker:1.10-latest readytalk/freeswitch-docker:1.10-buster-latest

docker tag freeswitch-docker:1.8-dtls-latest readytalk/freeswitch-docker:${FS_18_DTLS_VERSION}
docker tag freeswitch-docker:1.8-dtls-latest readytalk/freeswitch-docker:${FS_18_DTLS_MM}
docker tag freeswitch-docker:1.8-dtls-latest readytalk/freeswitch-docker:1.8-DTLS-latest

echo "-----------------------"
echo "Saved Tag \"readytalk/freeswitch-docker:${FS_16_VERSION}\""
echo "Saved Tag \"readytalk/freeswitch-docker:${FS_16_MM}\""
echo "Saved Tag \"readytalk/freeswitch-docker:${FS_18_DTLS_VERSION}\""
echo "Saved Tag \"readytalk/freeswitch-docker:${FS_18_DTLS_MM}\""
echo "Saved Tag \"readytalk/freeswitch-docker:${FS_110_stretch_VERSION}\""
echo "Saved Tag \"readytalk/freeswitch-docker:${FS_110_stretch_MM}\""
echo "Saved Tag \"readytalk/freeswitch-docker:${FS_110_buster_VERSION}\""
echo "Saved Tag \"readytalk/freeswitch-docker:${FS_110_buster_MM}\""
echo "-----------------------"

if [[ ${TRAVIS} && "${TRAVIS_BRANCH}" == "master" && -n $DOCKER_USERNAME && -n $DOCKER_PASSWORD ]]; then
  docker login -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD"
  docker push readytalk/freeswitch-docker:${FS_16_VERSION}
  docker push readytalk/freeswitch-docker:${FS_16_MM}
  docker push readytalk/freeswitch-docker:1.6-latest
  docker push readytalk/freeswitch-docker:${FS_18_DTLS_VERSION}
  docker push readytalk/freeswitch-docker:${FS_18_DTLS_MM}
  docker push readytalk/freeswitch-docker:1.8-DTLS-latest
  docker push readytalk/freeswitch-docker:${FS_110_stretch_VERSION}
  docker push readytalk/freeswitch-docker:${FS_110_stretch_MM}
  docker push readytalk/freeswitch-docker:1.10-stretch-latest
  docker push readytalk/freeswitch-docker:${FS_110_buster_VERSION}
  docker push readytalk/freeswitch-docker:${FS_110_buster_MM}
  docker push readytalk/freeswitch-docker:1.10-buster-latest
fi

