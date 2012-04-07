#!/bin/bash

if [[ -z $(sculptor agent list | grep $1) ]] 
then
    sculptor agent deploy --start --name $1 http://static.giftudi.com/$1-x86_64-linux.tar.gz
else
    # ensure it is running
    sculptor slot start $(sculptor agent list | grep $1 | cut -f 1)
fi
