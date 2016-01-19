#!/bin/bash

#$1 - file
#$2 - how many parts
# set -x
echo "file ffmpeg-split: $1"

file=
split=2
outputFolder=
testOutFolder="/tmp/video-out/"
partDuration=
[[ "$1" ]] || { echo "parameter \"file\" is missing"; exit 1;}

file=$1

if [[ -a "$file" ]];then

  filename=$(basename "$file")
  extension="${filename##*.}"
  filename="${filename%.*}"
fi


if [[ "$2" && "$2" -gt 0 ]];then
  split=$2
fi


if [[ -d "$testOutFolder" ]];then
    outputFolder="$testOutFolder"
fi

duration=$( ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$file" | sed -r 's/\..+//')

echo "Duration in seconds : $durationInSeconds" >&2

if (( $duration > 0 ));then
  # there is no 'bc' on centOS (yum -y bc)
  # partDuration=$(bc <<< "scale=2;${durationInSeconds}/${split}")
  partDuration=$(awk -v duration="$duration" -v parts="$split" 'BEGIN { print duration/parts }')
  echo "Each part will be: $partDuration seconds long" >&2
fi

startTime=0
endTime=$partDuration

filename=$( echo $filename | sed 's/[[:space:]]/\ /g' | sed 's/-/\-/g')

for((i=1;i<="$split";i++));do

  f=${outputFolder}${filename}-${i}.${extension}

  # endTime=$(bc <<< "scale=2;${partDuration}*${i}")
  endTime=$(awk -v duration="$partDuration" -v parts="$i" 'BEGIN {print duration*parts }')

  if ! ffmpeg -i "$file" -ss $startTime -to $endTime -acodec copy -vcodec copy "$f"; then
    break
    exit 1
  else
    echo -e "\n \n" >&2
    echo "${f} complete"  >&2
    echo -e "\n \n"  >&2
    startTime=$endTime
  fi
      startTime=$endTime

done
