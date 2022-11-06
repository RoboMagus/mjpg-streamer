FROM alpine:3.16 AS builder

RUN apk --no-cache add gcc make cmake linux-headers musl-dev libjpeg-turbo-dev

ADD mjpg-streamer-experimental /mjpg-streamer-experimental
RUN cd mjpg-streamer-experimental && make && make install

FROM alpine:3.16
RUN apk --no-cache add libjpeg-turbo
COPY --from=builder /usr/local/bin/mjpg_streamer /usr/local/bin/mjpg_streamer
COPY --from=builder /usr/local/share/mjpg-streamer /usr/local/share/mjpg-streamer
COPY --from=builder /usr/local/lib/mjpg-streamer /usr/local/lib/mjpg-streamer

EXPOSE 80

ENTRYPOINT ["mjpg_streamer"]
CMD ["-i", "input_uvc.so -n -f 30", "-o", "output_http.so -p 80 -w /usr/local/share/mjpg-streamer/www"]