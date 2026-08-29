FROM debian:13.6@sha256:f324c7ff54321e8d9c588493a20244965938ce0aa50bbd1022d38010e9ffc4b1

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
