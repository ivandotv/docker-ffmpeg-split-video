
[![Docker Pulls](https://img.shields.io/docker/pulls/ivandotv/ffmpeg-split-video.svg?style=flat-square)](https://hub.docker.com/r/ivandotv/ffmpeg-split-video/)
### Easily split video files with the help of a docker container and ffmpeg. ###

It's a chore to properly install ffmpeg and all the codecs, and it's also not very easy to split video files. So that's why this image was created.

****Usage****

`docker run -it --rm  -u "your-user-id" -v /directory-with-video:/tmp/video-in
-v your-output-directory:/tmp/video-out ivandotv/ffmpeg-split-video "split" "big-video-file.avi" 4`

- `run` command can work without mounting the output directory, in that case newly created video files will be put in the same directory as the original video file.
- Default split is `2` (example uses `4`).
- If you **don't** use "split" as the first parameter that is passed to the container, then you will call "ffmpeg" binary directly (and can use it for whatever you normally use it for).
- When video file is split, it's not re-encoded.


Actual command line parameters that are going to be passed to `ffmpeg` binary are:

`ffmpeg -i "big-video-file" -ss (start time) -to (end time )  -acodec copy -vcodec copy "output-file-directory"`

### Helper script ###
There is also a helper script (./tools/split-video) that is used as a wrapper for the `split` functionality of the container.
You can put it somewhere in your `$PATH` so you can call it from everywhere.

Use it like this:
`split-video video_file [number_of_parts] [output_folder]`

The script will launch the container, and pass all the required parameters for the `split` functionality (mounting volumes, passing correct arguments etc...)

Licence MIT
