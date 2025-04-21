FROM debian:12.10

ENV DUMB_INIT_VERSION=1.2.1 \
    GOSU_VERSION=1.10 \
    PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games

COPY nonfree.sources /etc/apt/sources.list.d/nonfree.sources
COPY build.sh        /usr/local/bin/build.sh
COPY run.sh          /usr/local/bin/run.sh

RUN bash /usr/local/bin/build.sh

USER steam
COPY ets2-install.txt /home/steam/

# Mount persistent volume here to keep game client / apps
VOLUME /home/steam/.local/share

CMD ["bash", "/usr/local/bin/run.sh"]
