#!/bin/bash

sleep 3 # there seems to be some kind of race with sculptor agent restarting

type=$(echo $1 | cut -f 1 -d'-')

# check for a deployment of this type fo binary on this host already
if [[ -z $(sculptor agent list | grep $type) ]] 
then
  echo "nothing of this type is here, so let's put ours there"
  sculptor agent deploy --start --name $1 http://static.giftudi.com/$1-x86_64-linux.tar.gz
else
  # something of this type is deployed here, so lets see if it is the same version
  if [[ -z $(sculptor agent list | grep $1) ]] 
  then
    echo "no match on current version, remove old and put on new"
    sculptor slot clear $(sculptor agent list | grep $type | cut -f 1)
    sculptor agent deploy --start --name $1 http://static.giftudi.com/$1-x86_64-linux.tar.gz
  else
    echo "okay, looks like we are being asked to install same version that is running,"
    echo "let's make sure it is running"
    sculptor slot start $(sculptor agent list | grep $1 | cut -f 1)
  fi
fi

echo "finished sculptor deploy of $1"