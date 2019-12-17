FROM golang:1.12.6-alpine
ENV LANG ja_jp.utf8
ENV GO111MODULE on

ARG POSTGRES_HOST
ARG POSTGRES_DB
ARG POSTGRES_USER
ARG POSTGRES_PASSWORD
#
ENV POSTGRES_HOST $POSTGRES_HOST
ENV POSTGRES_DB $POSTGRES_DB
ENV POSTGRES_USER $POSTGRES_USER
ENV POSTGRES_PASSWORD $POSTGRES_PASSWORD

WORKDIR /go/app
COPY ./mecab /go/app

RUN apk --no-cache update && \
    apk add git && \
    apk add gcc && \
    go get -u github.com/oxequa/realize && \
    :
#    set -x && \
#        cd /go/app && \
#        $(test -f /app/go.mod || go mod init app) && \
#        go mod download && \
#    :

#CMD go run main.go


