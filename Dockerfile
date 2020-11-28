FROM alpine:latest
RUN apk update && apk upgrade
RUN apk add openjdk8-jre curl
RUN rm -rf /var/cache/apk/*

# Set up server directory and user.
# Do this before copying in any sources
# to avoid making unecessarily large image layers.
RUN mkdir /opt/minecraft
RUN addgroup minecraft
RUN adduser -h /opt/minecraft -G minecraft -D minecraft
RUN chown -R minecraft:minecraft /opt/minecraft

ADD --chown=minecraft:minecraft https://launcher.mojang.com/v1/objects/35139deedbd5182953cf1caa23835da59ca3d7cd/server.jar \
  /opt/minecraft/server.jar
ADD --chown=minecraft:minecraft entrypoint.sh /opt/minecraft/entrypoint.sh
ADD --chown=minecraft:minecraft eula.txt /opt/minecraft/eula.txt

ENV JRE_HEAP=1024M
ENV MINECRAFT_MAP_URL=

HEALTHCHECK --interval=10s --timeout=10s --start-period=1m \
  CMD nc -z localhost 25565 

VOLUME /opt/minecraft
EXPOSE 25565/tcp
STOPSIGNAL SIGINT
USER minecraft:minecraft
CMD /opt/minecraft/entrypoint.sh
