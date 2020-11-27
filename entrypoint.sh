#!/bin/sh

cd /opt/minecraft
if [ ! -d "world" ]; then
    if [ ! -z "${MINECRAFT_MAP_URL}" ]; then
        # There isn't a world generated and the user
        # provided a MINECRAFT_MAP_URL. We assume that
        # the MINECRAFT_MAP_URL points to a minecraftmaps.com
        # page for a specific minecraft map.
        curl ${MINECRAFT_MAP_URL} --output world.zip
        mkdir world
        unzip world.zip -o -d world

        # Little bit of a hack. The world zipfiles are
        # extracted within a subdirectory which means
        # that we have to move the files up one level.
        # We don't know the name of the unextracted directory
        # so we simply do a wildcard replace
        mv world/*/* world/.
        fi
fi
java -Xmx${JRE_HEAP} -Xms${JRE_HEAP} -jar server.jar nogui
