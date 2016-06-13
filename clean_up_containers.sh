#!/bin/sh

IMAGES_COUNT="$(docker images -f "dangling=true" -q | wc -l)"
MINIMUM_COUNT=0

if [ $IMAGES_COUNT -gt 0 ]
  then
    echo $IMAGES_COUNT
    docker rmi -f $(docker images -f "dangling=true" -q)
else
  echo $IMAGES_COUNT
  echo "Conteiner count "
fi
