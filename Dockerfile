FROM jrottenberg/ffmpeg:4.3-ubuntu

COPY ./build-assets/container-init.sh /usr/local/sbin/

COPY ./build-assets/ffmpeg-split.sh /usr/local/sbin/

WORKDIR /tmp/video-in

CMD ["ffmpeg","--help"]

ENTRYPOINT ["container-init.sh"]
