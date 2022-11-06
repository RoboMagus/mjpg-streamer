FROM alpine:3.16

RUN apk --no-cache add gcc make cmake linux-headers musl-dev libjpeg-turbo-dev

RUN cd mjpg-streamer-experimental && make && make install

EXPOSE 80

ENTRYPOINT ["mjpg_streamer"]
CMD ["-i", "input_uvc.so -n -f 30", "-o", "output_http.so -p 80 -w /usr/local/share/mjpg-streamer/www"]