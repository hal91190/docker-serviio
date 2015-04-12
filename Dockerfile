# Serviio media server
# cf. https://github.com/HedgehogNinja/docker-serviio
# cf. https://github.com/sergeyfd/docker-serviio

FROM hal91190/debian
MAINTAINER hal

ENV HOME=/root DEBIAN_FRONTEND=noninteractive

# Installation de Oracle java 8
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list \
 && echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list \
 && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 \
 && echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections \
 && apt-get -y update \
 && apt-get -y install oracle-java8-installer

ENV J2SDKDIR=/usr/lib/jvm/java-8-oracle \
    J2REDIR=/usr/lib/jvm/java-8-oracle/jre \
    PATH=$PATH:/usr/lib/jvm/java-8-oracle/bin:/usr/lib/jvm/java-8-oracle/db/bin:/usr/lib/jvm/java-8-oracle/jre/bin \
    JAVA_HOME=/usr/lib/jvm/java-8-oracle \
    DERBY_HOME=/usr/lib/jvm/java-8-oracle/db

# Installation des paquets requis
RUN apt-get -y install curl dcraw libav-tools wget xz-utils \
 && apt-get clean

# Installation de ffmpeg
RUN wget http://johnvansickle.com/ffmpeg/releases/ffmpeg-release-64bit-static.tar.xz -O - | tar xJ -C /opt \
 && ln -s /opt/ffmpeg-2.6.2-64bit-static /opt/ffmpeg

ENV PATH $PATH:/opt/ffmpeg

# Installation de serviio
# Récupération de serviio
RUN wget --output-document=/tmp/serviio.tar.gz http://download.serviio.org/releases/serviio-1.5.2-linux.tar.gz

# Installation dans /opt
RUN mkdir -p /opt
RUN tar -zxvf /tmp/serviio.tar.gz -C /opt
RUN ls /opt | grep serviio | xargs echo "/opt/" | sed 's/ //' | xargs -I {} mv {} "/opt/serviio"
RUN rm /tmp/serviio.tar.gz

# la base de données
VOLUME ["/opt/serviio/library"]

# la bibliothèque
VOLUME ["/medialibs"]

# le journal
VOLUME ["/opt/serviio/log"]

# port TCP 8895 et UDP 1900 le contenu, 23423 pour l'API REST
# et 23424 pour le MediaBrowser
EXPOSE 23423/tcp 23424/tcp 8895/tcp 1900/udp

WORKDIR /opt/serviio
CMD ["bin/serviio.sh"]

