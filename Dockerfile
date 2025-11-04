FROM debian:13.1@sha256:e623a68de39df2046af830adc3c97928bf141c104a13cffc021fce9867aa54fe

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
