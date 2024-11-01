ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

RUN apk update && apk add --no-cache icecast xmlstarlet && mkdir /data && mkdir /config

# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh

ADD icecast.xml /etc/icecast.xml

VOLUME ["/data", "/config"]

EXPOSE 8000/tcp

CMD ["/run.sh"]
