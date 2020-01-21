#!/bin/bash
set -eu

temp_build_dir='temp_build_dir'
build_assets_dir='build-assets'
username='ivandotv'
image_name='ffmpeg-split-video'
build_params="$@"
full_image_name=${username}/${image_name}

function clean_up(){
    rm -rf "$temp_build_dir"
}

trap clean_up ERR SIGINT


mkdir -p "$temp_build_dir"

cp Dockerfile "$temp_build_dir"

cp -R "$build_assets_dir" "$temp_build_dir"

docker build ${build_params} -t ${full_image_name} ${temp_build_dir}

clean_up
