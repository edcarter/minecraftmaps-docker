#!/bin/sh

cd /opt/minecraft
java -Xmx${JRE_HEAP} -Xms${JRE_HEAP} -jar server.jar nogui
