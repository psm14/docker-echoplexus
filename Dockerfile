FROM danscan/node

RUN mkdir /data && useradd -d /data -s /bin/bash echoplexus && chown echoplexus:echoplexus /data
RUN apt-get install -y ruby rubygems git && apt-get clean
RUN gem install sass --no-rdoc --no-ri
WORKDIR /data
RUN su echoplexus -c 'git clone https://github.com/qq99/echoplexus.git echoplexus'
WORKDIR echoplexus
RUN su echoplexus -c 'npm install'
RUN npm install -g coffee-script grunt grunt-cli supervisor bower
RUN su echoplexus -c 'bower install'
ADD config.coffee /data/echoplexus/src/server/config.coffee
RUN chown echoplexus:echoplexus src/server/config.coffee
RUN su echoplexus -c 'grunt build'

EXPOSE 8080
USER echoplexus
CMD grunt exec:production
