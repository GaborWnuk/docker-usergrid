#!/bin/bash
#
# Based on https://github.com/tutumcloud/tutum-docker-tomcat
#

if [ -f ${TOMCAT_CONFIGURATION_FLAG} ]; then
    echo "Tomcat 'admin' user already created"
    exit 0
fi

#generate password
PASS=${TOMCAT_PASS:-$(pwgen -s 12 1)}
_word=$( [ ${TOMCAT_PASS} ] && echo "preset" || echo "random" )

echo "=> Creating and admin user with a ${_word} password in Tomcat ..."
sed -i -r 's/<\/tomcat-users>//' ${CATALINA_BASE}/tomcat-users.xml
echo '<role rolename="manager-gui"/>' >> ${CATALINA_BASE}/tomcat-users.xml
echo '<role rolename="manager-script"/>' >> ${CATALINA_BASE}/tomcat-users.xml
echo '<role rolename="manager-jmx"/>' >> ${CATALINA_BASE}/tomcat-users.xml
echo '<role rolename="admin-gui"/>' >> ${CATALINA_BASE}/tomcat-users.xml
echo '<role rolename="admin-script"/>' >> ${CATALINA_BASE}/tomcat-users.xml
echo "<user username=\"admin\" password=\"${PASS}\" roles=\"manager-gui,manager-script,manager-jmx,admin-gui, admin-script\"/>" >> ${TOMCAT_CONFIG_DIR}/tomcat-users.xml
echo '</tomcat-users>' >> ${CATALINA_BASE}/tomcat-users.xml 
echo "=> Done!"

echo "=> Creating Apache usergrid_ properties ..."
if [ ! -z "${CASSANDRA_HOST}" ]; then
    sed -i.bak "s/{CASSANDRA_HOST}/${CASSANDRA_HOST}/g" /usr/share/tomcat7/lib/usergrid-deployment.properties
fi

if [ -z "${UG_USERNAME}" ]; then
    UG_USERNAME="superuser"
fi

if [ -z "${UG_EMAIL}" ]; then
    UG_EMAIL="superuser@localhost"
fi

if [ -z "${UG_PASSWORD}" ]; then
    UG_PASSWORD=`pwgen -s 12 1`
fi

sed -i.bak "s/{UG_USERNAME}/${UG_USERNAME}/g" /usr/share/tomcat7/lib/usergrid-deployment.properties
sed -i.bak "s/{UG_EMAIL}/${UG_EMAIL}/g" /usr/share/tomcat7/lib/usergrid-deployment.properties
sed -i.bak "s/{UG_PASSWORD}/${UG_PASSWORD}/g" /usr/share/tomcat7/lib/usergrid-deployment.properties

echo "=> Done!"

touch ${TOMCAT_CONFIGURATION_FLAG}

echo "========================================================================"
echo "You can now configure to this Tomcat server using:"
echo ""
echo "    admin:${PASS}"
echo ""
echo "Your Cassandra host is:"

echo "    ${CASSANDRA_HOST}"
echo ""
echo "Your Apache usergrid_ superuser credentials are:"
echo ""
echo "    ${UG_USERNAME}:${UG_PASSWORD}"
echo ""
echo "========================================================================"

