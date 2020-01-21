#!/bin/bash

if [[ "$1" == 'split' ]]; then
  shift
  exec ffmpeg-split.sh "$@"
elif [[ "$1" == 'ffmpeg' ]]; then
  shift
  exec ffmpeg "$@"
elif [[ "$1" == 'ffprobe' ]]; then
  shift
  exec ffprobe "$@"
fi
