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

duration=$( ffmpeg -i "$file" 2>&1 | grep -i duration )
echo $duration

durationInSeconds=$(awk 'BEGIN { FS=":"; }; \
{ \
  gsub("^ 0","",$2); \
  gsub("^0","",$3); \
  gsub("\\.[0-9][0-9], start","",$4); \
  }; \
END { \
  $total=($2*3600)+($3*60)+$4; \
  print $total; \
 };' <<< "$duration" )


if (( $durationInSeconds > 0 ));then
  # there is no 'bc' on centOS (yum -y bc)
  # partDuration=$(bc <<< "scale=2;${durationInSeconds}/${split}")
  partDuration=$(awk -v duration="$durationInSeconds" -v parts="$split" 'BEGIN { print duration/parts }')
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
done
