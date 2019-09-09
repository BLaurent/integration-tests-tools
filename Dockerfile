FROM ubuntu:bionic

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y -qq clean && apt-get -y -qq update
RUN apt-get install -y -qq locales
RUN locale-gen "en_US.UTF-8"
RUN dpkg-reconfigure locales
RUN apt-get install -y -qq curl apt-transport-https
RUN apt-get install -y -qq \
      jq iputils-ping httpie

RUN apt-get -y -qq clean && \
      rm -rf /var/lib/apt/lists/*

RUN groupadd -g 1000 docker
RUN useradd -g 1000 -d /home/docker -s /bin/bash -u 1000 docker
RUN mkdir -p /home/docker/work
COPY profile /home/docker/.profile
RUN chown -R docker:docker /home/docker
USER docker
WORKDIR /home/docker

ENV NODE_VERSION 10.16.0
ENV NVM_VERSION v0.34.0
ENV NVM_DIR=/home/docker/.nvm
RUN mkdir -p /home/docker/.nvm

# Install nvm with node and npm
RUN curl https://raw.githubusercontent.com/creationix/nvm/$NVM_VERSION/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default \
    && npm install -g yarn \
    && yarn config set yarn-offline-mirror /home/docker/npm-packages-offline-cache \
    && yarn config set strict-ssl false \
    && yarn config set yarn-offline-mirror-pruning true \
    && yarn global add jest jest-html-reporter \
    && yarn add fs supertest \
    && rm -rf node_modules

COPY jest.config.js /home/docker/
WORKDIR /home/docker/work

CMD ["/bin/bash"]
