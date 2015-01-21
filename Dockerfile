# Serviio media server
# cf. https://github.com/HedgehogNinja/docker-serviio
# cf. https://github.com/sergeyfd/docker-serviio

FROM debian:testing
MAINTAINER hal

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

# Installation des paquets requis
RUN apt-get -y update \
    && apt-get -y install curl libav-tools wget dcraw
RUN apt-get -y --no-install-recommends install default-jre

# Cration du lien pour ffmpeg
RUN ln -s /usr/bin/avconv /usr/bin/ffmpeg

# Installation de serviio
# récupération de la page de téléchargement
RUN wget --output-document=/tmp/download.html http://serviio.org/download

# extrait le lien de téléchargement et télécharge dans /tmp/serviio-latest.tar.gz 
RUN grep -oEm 1 "<a href=\".*(linux.tar.gz)\"" /tmp/download.html | cut -d\" -f2 | xargs wget --output-document=/tmp/serviio-latest.tar.gz
RUN rm /tmp/download.html

# Installation dans /opt
RUN mkdir -p /opt
RUN tar -zxvf /tmp/serviio-latest.tar.gz -C /opt
RUN ls /opt/ | xargs echo "/opt/" | sed 's/ //' | xargs -I {} mv {} "/opt/serviio" 
RUN rm /tmp/serviio-latest.tar.gz

# la bibliothèque
VOLUME ["/medialibs"]

# le journal
VOLUME ["/opt/serviio/log"]

# port TCP 8895 et UDP 1900 le contenu, 23423 pour l'API REST
# et 23424 pour le MediaBrowser
EXPOSE 23423/tcp 23424/tcp 8895/tcp 1900/udp

WORKDIR /opt/serviio
CMD ["bin/serviio.sh"]

