#!/bin/bash

docker build -t rt-freeswitch:latest .

FS_TMP=$(docker run --rm --entrypoint="" -it readytalk/rt-freeswitch:latest /usr/bin/freeswitch -version 2> /dev/null)
echo "--------------==="
echo $FS_TMP
echo "--------------==="

FS_V_A=(${FS_TMP[@]})
FS_VERSION=${FS_V_A[2]::-14}
GIT_HASH=$(git rev-parse HEAD)
GIT_COMMIT=${GIT_HASH::7}
FS_A=(${FS_VERSION//./ })
FS_A=(${FS_A[@]})
FS_MM="${FS_A[0]}.${FS_A[1]}"

docker tag rt-freeswitch:latest readytalk/rt-freeswitch:${FS_VERSION}
docker tag rt-freeswitch:latest readytalk/rt-freeswitch:${FS_A[0]}.${FS_A[1]}
docker tag rt-freeswitch:latest readytalk/rt-freeswitch:latest
echo "-----------------------"
echo "Saved Tag \"rt-freeswitch:${FS_VERSION}\""
echo "Saved Tag \"rt-freeswitch:${FS_MM}\""
echo "Saved Tag \"rt-freeswitch:latest\""
echo "-----------------------"

if [[ ${TRAVIS} && "${TRAVIS_BRANCH}" == "master" && -n $DOCKER_USERNAME && -n $DOCKER_PASSWORD ]]; then
  docker login -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD"
  docker push readytalk/rt-freeswitch:${KAM_VER}
  docker push readytalk/rt-freeswitch:${KAM_A[0]}.${KAM_A[1]}
  docker push readytalk/rt-freeswitch:latest
fi

