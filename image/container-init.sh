#!/bin/bash

if [[ $1=='split' ]]; then
  shift
  exec ffmpeg-split.sh "$@"
elif [[ $1=='ffmpeg' ]];then
  shift
  exec ffmpeg "$@"
fi
