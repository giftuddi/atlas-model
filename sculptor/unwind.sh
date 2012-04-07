#!/bin/bash

if [[ -z $(sculptor agent list | grep $1) ]] 
then
    # it isn't there, someone cleared it for us!
else
    # ensure it is gone
    sculptor slot stop $(sculptor agent list | grep $1 | cut -f 1)
    sculptor slot clear $(sculptor agent list | grep $1 | cut -f 1)
fi
