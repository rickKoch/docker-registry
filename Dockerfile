ARG GO_VERSION=1.17

FROM golang:${GO_VERSION}-alpine3.14 AS builder

ENV GO111MODULE=auto
ENV DISTRIBUTION_DIR /go/src/github.com/distribution/distribution
ENV BUILDTAGS include_oss include_gcs

ARG GOOS=linux
ARG GOARCH=amd64
ARG GOARM=6
ARG VERSION
ARG REVISION

RUN set -ex \
    && apk add --no-cache make git file

WORKDIR ${GOPATH}/src/github.com/distribution
RUN git clone https://github.com/distribution/distribution.git

WORKDIR $DISTRIBUTION_DIR
RUN CGO_ENABLED=0 make PREFIX=/go clean binaries && \
  file ./bin/registry | grep "statically linked"

FROM alpine:3.14

RUN set -ex \
    && apk add --no-cache ca-certificates

COPY config.yml /etc/docker/registry/config.yml
COPY --from=builder /go/src/github.com/distribution/distribution/bin/registry /bin/registry
VOLUME ["/var/lib/registry"]
EXPOSE 5000
ENTRYPOINT ["registry"]
CMD ["serve", "/etc/docker/registry/config.yml"]
