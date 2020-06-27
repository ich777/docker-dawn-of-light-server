FROM ich777/mono-baseimage

LABEL maintainer="admin@minenet.at"

RUN dpkg --add-architecture i386 && \
	apt-get update && \
	apt-get -y install --no-install-recommends && \
	rm -rf /var/lib/apt/lists/*

ENV DATA_DIR="/dol"
ENV GAME_PARAMS="template"
ENV UMASK=000
ENV UID=99
ENV GID=100
ENV USER="dol"
ENV DATA_PERM=770

RUN mkdir $DATA_DIR && \
	useradd -d $DATA_DIR -s /bin/bash $USER && \
	chown -R $USER $DATA_DIR && \
	ulimit -n 2048

ADD /scripts/ /opt/scripts/
RUN chmod -R 770 /opt/scripts/

#Server Start
ENTRYPOINT ["/opt/scripts/start.sh"]