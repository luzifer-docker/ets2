FROM debian:13.6@sha256:fac46bff2e02f51425b6e33b0e1169f55dfb053d83511ca28aa50c09fd5ed7a4

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games

COPY nonfree.sources /etc/apt/sources.list.d/nonfree.sources
COPY build.sh        /usr/local/bin/build.sh
COPY run.sh          /usr/local/bin/run.sh

RUN bash /usr/local/bin/build.sh

USER steam
COPY ets2-install.txt /home/steam/

# Mount persistent volume here to keep game client / apps
VOLUME /home/steam/.local/share

CMD ["bash", "/usr/local/bin/run.sh"]
