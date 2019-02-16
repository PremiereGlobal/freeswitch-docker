#!/bin/bash

docker build -t freeswitch-docker:1.6-latest . -f Dockerfile-1.6
docker build -t freeswitch-docker:1.8-latest . -f Dockerfile-1.8

FS_16_TMP=$(docker run --rm --entrypoint="" -it freeswitch-docker:1.6-latest /usr/bin/freeswitch -version 2> /dev/null)
FS_18_TMP=$(docker run --rm --entrypoint="" -it freeswitch-docker:1.8-latest /usr/bin/freeswitch -version 2> /dev/null)
echo "--------------==="
echo $FS_16_TMP
echo "--------------==="
echo $FS_18_TMP
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

docker tag freeswitch-docker:1.6-latest readytalk/freeswitch-docker:${FS_16_VERSION}
docker tag freeswitch-docker:1.6-latest readytalk/freeswitch-docker:${FS_16_MM}
docker tag freeswitch-docker:1.8-latest readytalk/freeswitch-docker:${FS_18_VERSION}
docker tag freeswitch-docker:1.8-latest readytalk/freeswitch-docker:${FS_18_MM}
docker tag freeswitch-docker:1.8-latest readytalk/freeswitch-docker:latest

echo "-----------------------"
echo "Saved Tag \"readytalk/freeswitch-docker:${FS_16_VERSION}\""
echo "Saved Tag \"readytalk/freeswitch-docker:${FS_16_MM}\""
echo "Saved Tag \"readytalk/freeswitch-docker:${FS_18_VERSION}\""
echo "Saved Tag \"readytalk/freeswitch-docker:${FS_18_MM}\""
echo "Saved Tag \"readytalk/freeswitch-docker:latest\""
echo "-----------------------"

if [[ ${TRAVIS} && "${TRAVIS_BRANCH}" == "master" && -n $DOCKER_USERNAME && -n $DOCKER_PASSWORD ]]; then
  docker login -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD"
  docker push readytalk/freeswitch-docker:${FS_16_VERSION}
  docker push readytalk/freeswitch-docker:${FS_16_MM}
  docker push readytalk/freeswitch-docker:${FS_18_VERSION}
  docker push readytalk/freeswitch-docker:${FS_18_MM}
  docker push readytalk/freeswitch-docker:latest
fi

