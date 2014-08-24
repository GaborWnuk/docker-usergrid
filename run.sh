#!/bin/bash
#
# Based on https://github.com/tutumcloud/tutum-docker-tomcat
#

if [ ! -f ${TOMCAT_CONFIGURATION_FLAG} ]; then
    /usergrid/create_tomcat_admin_user.sh
fi

exec /usr/share/tomcat7/bin/catalina.sh run