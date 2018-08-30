FROM python:2.7-alpine
MAINTAINER Roi Avidan <roiavidan@gmail.com>

WORKDIR /app

RUN apk add --no-cache jq
RUN apk add --no-cache --virtual .build-deps git && \
    pip install awscli git+https://github.com/roiavidan/mobbage.git && \
    apk del .build-deps
COPY bin/stressed *VERSION /app/

CMD ["/app/stressed"]
