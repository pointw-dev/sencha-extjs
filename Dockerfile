FROM openjdk:8-jre-alpine

MAINTAINER Michael Ottoson <michael@pointw.com>

ENV cmdVersion 6.5.3.6
ENV PATH /opt/sencha/cmd/${cmdVersion}/:$PATH
ENV PJS_HOME=/usr/lib/phantomjs

EXPOSE 1841

### Install needed packages
RUN apk update && \
    apk upgrade && \
    apk --update add \
      ruby \
      build-base \
      libstdc++ \
      tzdata \
      bash \
      ttf-dejavu \
      freetype \
      fontconfig \
      curl 

      
### Docker for Windows introduces a problem for sencha app watch to detect changes.  Permissions?      
# RUN mkdir -p /home/sencha && \
#     useradd sencha && \
#     # cd && cp -R .bashrc .profile /home/sencha && \
#     mkdir -p /workspace && \
#     chown -R sencha:sencha /home/sencha /workspace
# 
# USER sencha
# ENV HOME /home/sencha

    
### Add Ext JS SDK, Install Sencha CMD and Phantom JS (note: Phantom JS support for v2.1.1 has expired)
WORKDIR /opt/sencha/sdk
RUN curl https://cdn.sencha.com/ext/gpl/ext-6.2.0-gpl.zip -o extjs.zip; \
    unzip extjs.zip; \
    mv ext-6.2.0 /opt/sencha/sdk/; \
    rm extjs.zip;

### Sencha CMD updates more frequently than Ext JS GPL, so above is pulled out as separate layer    
RUN curl http://cdn.sencha.com/cmd/${cmdVersion}/no-jre/SenchaCmd-${cmdVersion}-linux-amd64.sh.zip -o senchacmd.zip && \
    unzip senchacmd.zip && \
    rm senchacmd.zip && \
    chmod +x SenchaCmd-${cmdVersion}-linux-amd64.sh && \
    ./SenchaCmd-${cmdVersion}-linux-amd64.sh -q -dir /opt/sencha/cmd/${cmdVersion} -Dall=true && \
    rm SenchaCmd-${cmdVersion}-linux-amd64.sh && \
    chmod +x /opt/sencha/cmd/${cmdVersion}/sencha && \
    cd /tmp && \
    curl -Ls "https://github.com/israelroldan/docker-sencha-cmd/raw/phantomjs-2.1.1/dockerized-phantomjs-2.1.1.tar.gz" | tar xz -C / && \
    ln -s "$PJS_HOME/bin/phantomjs" /usr/bin/phantomjs && \
    rm /opt/sencha/cmd/${cmdVersion}/bin/linux-x64/phantomjs/phantomjs && \
    ln -s "$PJS_HOME/bin/phantomjs" /opt/sencha/cmd/${cmdVersion}/bin/linux-x64/phantomjs/phantomjs && \
    PS1='[sencha-extjs] \W\$ '
    
VOLUME /code
WORKDIR /code

CMD ["bash"]
