FROM alpine:3.7

ENV VERSION=0.7.4-r0

RUN apk add --no-cache multipath-tools=${VERSION}
COPY . /

ENTRYPOINT ["/sbin/multipathd", "-d"]
CMD ["-v", "3"]