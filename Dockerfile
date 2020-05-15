FROM ubuntu:18.04

RUN apt-get update
RUN apt-get install -y \
    sudo \
    python-pip \
    build-essential \
    libssl-dev \
    git \
    curl \
    python-dev \
    unzip \
    openjdk-8-jre

RUN sudo pip install setuptools awsebcli awscli

# Ngrok

RUN curl -sL https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip > ngrok.zip
RUN unzip ngrok.zip
RUN chmod +x ngrok
RUN sudo cp ngrok /usr/bin

# Node

RUN curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
RUN sudo apt-get install -y nodejs
RUN npm install -g yarn code-push-cli
RUN sudo npm install -g sentry-cli-binary --unsafe-perm=true
RUN node -v
RUN npm -v
