ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

RUN apk update && apk add --no-cache icecast xmlstarlet && mkdir /data && mkdir /config

# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh

ADD icecast.xml /etc/icecast.xml

# Icecast only writes to /var/log/icecast. Symlink the files into the /config directory for extraction
RUN ln -s /config/access.log /var/log/icecast/access.log
RUN ln -s /config/error.log /var/log/icecast/error.log
RUN ln -s /config/playlist.log /var/log/icecast/playlist.log

VOLUME ["/data", "/config"]

EXPOSE 8000/tcp

CMD ["/run.sh"]
