#!/bin/bash

docker build -t rt-freeswitch:latest .

FS_TMP=$(docker run --rm -it readytalk/rt-freeswitch:latest /usr/bin/freeswitch -version)
echo $FS_TMP

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
