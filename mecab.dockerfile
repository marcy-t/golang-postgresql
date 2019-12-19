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
    apk add vim && \
    go get -u github.com/oxequa/realize && \
    :
#    set -x && \
#        cd /go/app && \
#        $(test -f /app/go.mod || go mod init app) && \
#        go mod download && \
#    :



#CMD go run main.go

RUN apk add --update --no-cache build-base
ENV MECAB_VERSION 0.996
ENV IPADIC_VERSION 2.7.0-20070801
ENV mecab_url https://drive.google.com/uc?export=download&amp;id=0B4y35FiV1wh7cENtOXlicTFaRUE
ENV ipadic_url https://drive.google.com/uc?export=download&amp;id=0B4y35FiV1wh7MWVlSDBCSXZMTXM
ENV build_deps 'curl git bash file sudo openssh'
ENV dependencies 'openssl'
RUN apk add --update --no-cache ${build_deps} \
  # Install dependencies
  && apk add --update --no-cache ${dependencies} \
  # Install MeCab
  && curl -SL -o mecab-${MECAB_VERSION}.tar.gz ${mecab_url} \
  && tar zxf mecab-${MECAB_VERSION}.tar.gz \
  && cd mecab-${MECAB_VERSION} \
  && ./configure --enable-utf8-only --with-charset=utf8 \
  && make \
  && make install \
  && cd \
  # Install IPA dic
  && curl -SL -o mecab-ipadic-${IPADIC_VERSION}.tar.gz ${ipadic_url} \
  && tar zxf mecab-ipadic-${IPADIC_VERSION}.tar.gz \
  && cd mecab-ipadic-${IPADIC_VERSION} \
  && ./configure --with-charset=utf8 \
  && make \
  && make install \
  && cd \
  # Install Neologd
  && git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git \
  && mecab-ipadic-neologd/bin/install-mecab-ipadic-neologd -n -y \
  # Clean up
  && apk del ${build_deps} \
  && rm -rf \
    mecab-${MECAB_VERSION}* \
    mecab-${IPADIC_VERSION}* \
    mecab-ipadic-neologd
CMD ["mecab", "-d", "/usr/local/lib/mecab/dic/mecab-ipadic-neologd"]


