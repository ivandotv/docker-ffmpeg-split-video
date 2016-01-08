FROM jrottenberg/ffmpeg:latest

MAINTAINER Ivan Vlatkovic <ivan.vlatkovic@gmail.com>


ADD ["container-init.sh","/usr/local/sbin"]

ADD ["ffmpeg-split.sh","/usr/local/sbin"]

RUN mkdir /tmp/video-in

WORKDIR /tmp/video-in

CMD ["ffmpeg","--help"]

ENTRYPOINT ["container-init.sh"]
