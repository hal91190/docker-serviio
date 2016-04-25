# Serviio media server
# cf. https://github.com/linuxserver/docker-serviio
# cf. https://github.com/HedgehogNinja/docker-serviio
# cf. https://github.com/sergeyfd/docker-serviio

FROM hal91190/debian-testing-fr
MAINTAINER hal

# Installation de Oracle java 8
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list \
 && echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list \
 && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 \
 && echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections \
 && apt-get -y update \
 && apt-get -y install oracle-java8-installer oracle-java8-set-default \
 && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/*

ENV JAVA_HOME=/usr/lib/jvm/java-8-oracle \
    J2SDKDIR=/usr/lib/jvm/java-8-oracle \
    J2REDIR=/usr/lib/jvm/java-8-oracle/jre \
    DERBY_HOME=/usr/lib/jvm/java-8-oracle/db \
    PATH=$PATH:/usr/lib/jvm/java-8-oracle/bin:/usr/lib/jvm/java-8-oracle/jre/bin:/usr/lib/jvm/java-8-oracle/db/bin

# Installation des paquets requis
RUN apt-get -y update \
 && apt-get -y install curl dcraw ffmpeg wget \
 && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/*

# Installation de serviio
RUN wget http://download.serviio.org/releases/serviio-1.6.1-linux.tar.gz -O - | tar xz -C /opt \
 && ln -s /opt/$(cd /opt; ls -d serviio-*) /opt/serviio

# la base de données, la bibliothèque et le journal
VOLUME ["/opt/serviio/library", "/medialibs", "/opt/serviio/log"]

# port TCP 8895 et UDP 1900 le contenu, 23423 pour l'API REST
# et 23424 pour le MediaBrowser
EXPOSE 23423/tcp 23424/tcp 8895/tcp 1900/udp

WORKDIR /opt/serviio
CMD ["bin/serviio.sh"]
