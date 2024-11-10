#!/usr/bin/with-contenv bashio

CURTIME=$(date)
echo "STARTUP $CURTIME"

# Ensure the log files exist prior to ensuring icecast user has access
echo "STARTUP $CURTIME" >> /config/access.log
echo "STARTUP $CURTIME" >> /config/error.log
echo "STARTUP $CURTIME" >> /config/playlist.log

# Ensure icecast user has access
chmod a+rw /config/access.log
chmod a+rw /config/error.log
chmod a+rw /config/playlist.log

ADMINUSER="$(bashio::config 'adminuser')"
ESCAPED_ADMINUSER="$(echo ${ADMINUSER} | sed 's/\"/\\\"/g')"
xmlstarlet ed --inplace --update icecast/authentication/admin-user --value "$ESCAPED_ADMINUSER" /etc/icecast.xml

ADMINPASSWORD="$(bashio::config 'adminpassword')"
ESCAPED_ADMINPASSWORD="$(echo ${ADMINPASSWORD} | sed 's/\"/\\\"/g')"
xmlstarlet ed --inplace --update icecast/authentication/admin-password --value "$ESCAPED_ADMINPASSWORD" /etc/icecast.xml

SOURCEPASSWORD="$(bashio::config 'sourcepassword')"
ESCAPED_SOURCEPASSWORD="$(echo ${SOURCEPASSWORD} | sed 's/\"/\\\"/g')"
xmlstarlet ed --inplace --update icecast/authentication/source-password --value "$ESCAPED_SOURCEPASSWORD" /etc/icecast.xml

RELAYPASSWORD="$(bashio::config 'relaypassword')"
ESCAPED_RELAYPASSWORD="$(echo ${RELAYPASSWORD} | sed 's/\"/\\\"/g')"
xmlstarlet ed --inplace --update icecast/authentication/relay-password --value "$ESCAPED_RELAYPASSWORD" /etc/icecast.xml

CERTFILE="$(bashio::config 'certfile')"
ESCAPED_CERTFILE="$(echo ${CERTFILE} | sed 's/\"/\\\"/g')"
xmlstarlet ed --inplace --subnode icecast/paths --type elem --name ssl-certificate --value "$ESCAPED_CERTFILE" /etc/icecast.xml

/usr/bin/icecast -c /etc/icecast.xml
