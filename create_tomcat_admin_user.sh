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

echo "=> Creating and admin user with a ${_word} password in Tomcat"
sed -i -r 's/<\/tomcat-users>//' ${CATALINA_BASE}/tomcat-users.xml
echo '<role rolename="manager-gui"/>' >> ${CATALINA_BASE}/tomcat-users.xml
echo '<role rolename="manager-script"/>' >> ${CATALINA_BASE}/tomcat-users.xml
echo '<role rolename="manager-jmx"/>' >> ${CATALINA_BASE}/tomcat-users.xml
echo '<role rolename="admin-gui"/>' >> ${CATALINA_BASE}/tomcat-users.xml
echo '<role rolename="admin-script"/>' >> ${CATALINA_BASE}/tomcat-users.xml
echo "<user username=\"admin\" password=\"${PASS}\" roles=\"manager-gui,manager-script,manager-jmx,admin-gui, admin-script\"/>" >> ${TOMCAT_CONFIG_DIR}/tomcat-users.xml
echo '</tomcat-users>' >> ${CATALINA_BASE}/tomcat-users.xml 
echo "=> Done!"

touch ${TOMCAT_CONFIGURATION_FLAG}

echo "========================================================================"
echo "You can now configure to this Tomcat server using:"
echo ""
echo "    admin:${PASS}"
echo ""
echo "========================================================================"


