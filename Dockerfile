FROM ubuntu:18.04

RUN apt-get update
RUN apt-get install -y \
    sudo \
    python-pip \
    build-essential \
    libssl-dev \
    git \
    curl \
    python-dev

RUN sudo pip install setuptools awsebcli awscli

# Node

RUN curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
RUN sudo apt-get install -y nodejs
RUN npm install -g yarn code-push-cli
RUN sudo npm install -g sentry-cli-binary --unsafe-perm=true
RUN node -v
RUN npm -v
