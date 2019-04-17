FROM python:3-alpine

WORKDIR /xelm

RUN apk add --update --no-cache bash libxslt libxml2-utils && \
    rm -rf /var/cache/apk/*

COPY . /xelm/

ENTRYPOINT ["/xelm/xelm.sh"]
