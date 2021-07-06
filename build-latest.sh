#!/bin/bash

docker build -t freeswitch-docker:1.10-latest . -f Dockerfile-1.10-buster

FS_110_buster_TMP=$(docker run --rm --entrypoint="" -it freeswitch-docker:1.10-latest /usr/bin/freeswitch -version 2> /dev/null)
echo "--------------==="
echo $FS_110_buster_TMP
echo "--------------==="

FS_110_buster_V_A=(${FS_110_buster_TMP[@]})
FS_110_buster_VERSION=${FS_110_buster_V_A[2]::-14}
FS_110_buster_A=(${FS_110_buster_VERSION//-/ })
FS_110_buster_A=(${FS_110_buster_A[@]})
FS_110_buster_VERSION="${FS_110_buster_A[0]}-buster"
FS_110_buster_A=(${FS_110_buster_A[0]//./ })
FS_110_buster_A=(${FS_110_buster_A[@]})
FS_110_buster_MM="${FS_110_buster_A[0]}.${FS_110_buster_A[1]}-buster"

docker tag freeswitch-docker:1.10-latest readytalk/freeswitch-docker:${FS_110_buster_VERSION}
docker tag freeswitch-docker:1.10-latest readytalk/freeswitch-docker:${FS_110_buster_MM}
docker tag freeswitch-docker:1.10-latest readytalk/freeswitch-docker:1.10-buster-latest


echo "-----------------------"
echo "Saved Tag \"readytalk/freeswitch-docker:${FS_110_buster_VERSION}\""
echo "Saved Tag \"readytalk/freeswitch-docker:${FS_110_buster_MM}\""
echo "-----------------------"

if [[ -n "${GITHUB_ACTION}" && -n $DOCKER_USER && -n $DOCKER_TOKEN ]]; then
  docker push readytalk/freeswitch-docker:${FS_110_buster_VERSION}
  docker push readytalk/freeswitch-docker:${FS_110_buster_MM}
  docker push readytalk/freeswitch-docker:1.10-buster-latest
fi

