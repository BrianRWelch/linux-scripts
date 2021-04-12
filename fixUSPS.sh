#!/bin/bash

if [[ ${1} != "" ]]
then
  echo ${1} | tail -c 23
else
  echo "ERROR:Need to provide a string to parse"
fi
