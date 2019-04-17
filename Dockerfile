FROM python:3-alpine

RUN apk add --update --no-cache bash libxslt libxml2-utils && \
    rm -rf /var/cache/apk/*
