#!/bin/sh

# Print each command run and exit on non-zero exit code of subcommands.
# Some people don't like -e: http://mywiki.wooledge.org/BashFAQ/105
set -ex

cd /opt/minecraft
if [ ! -d "world" ]; then
    if [ ! -z "${MINECRAFT_MAP_URL}" ]; then
        # There isn't a world generated and the user
        # provided a MINECRAFT_MAP_URL. We assume that
        # the MINECRAFT_MAP_URL points to a minecraftmaps.com
        # page for a specific minecraft map.

        # First lets assume the MINECRAFT_MAP_URL is for the main page
        # of the map, in that case we just need to append /download to
        # the URL to get the zip.
        curl ${MINECRAFT_MAP_URL}/download --output world.zip || true
        if [ ! -s "world.zip" ]; then
            # If the first download failed produces an empty file the
            # download failed. Maybe the user provided a direct link
            # to the download, lets try that.
            curl ${MINECRAFT_MAP_URL} --output world.zip
        fi
   
        mkdir world
        unzip world.zip -o -d world

        # Little bit of a hack. The world zipfiles are
        # extracted within a subdirectory which means
        # that we have to move the files up one level.
        # We don't know the name of the unextracted directory
        # so we simply do a wildcard replace
        mv world/*/* world/.
        rm -f world.zip
    fi
fi
java -Xmx${JRE_HEAP} -Xms${JRE_HEAP} -jar server.jar nogui
