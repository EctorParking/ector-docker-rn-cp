FROM ubuntu:18.04

RUN apt-get update
RUN apt-get install -y --fix-missing \
    sudo \
    python3-pip \
    build-essential \
    libssl-dev \
    git \
    curl \
    python3-dev \
    unzip \
    openjdk-8-jre \
    openjdk-8-jdk \
    wget

RUN sudo pip3 install setuptools pyrsistent==0.16.1 awsebcli==3.10.0 awscli

# Ngrok

RUN curl -sL https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip > ngrok.zip
RUN unzip ngrok.zip
RUN chmod +x ngrok
RUN sudo cp ngrok /usr/bin

# Node

RUN curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
RUN sudo apt-get install -y nodejs
RUN npm install -g yarn code-push-cli
RUN sudo npm install -g sentry-cli-binary --unsafe-perm=true
RUN node -v
RUN npm -v

# Android SDK

ARG sdk_manager_version=commandlinetools-linux-8512546_latest.zip
ARG android_home=/opt/android/sdk
ARG sdkmanager=${android_home}/cmdline-tools/latest/bin/sdkmanager

RUN sudo mkdir -p ${android_home} && \
    wget -O /tmp/${sdk_manager_version} -t 5 "https://dl.google.com/android/repository/${sdk_manager_version}" && \
    unzip -q /tmp/${sdk_manager_version} -d /tmp && \
    rm /tmp/${sdk_manager_version}

RUN sudo mkdir -p ${android_home}/cmdline-tools/latest && \
    mv /tmp/cmdline-tools/* ${android_home}/cmdline-tools/latest && \
    rm -r /tmp/cmdline-tools

ENV ANDROID_HOME ${android_home}
ENV ADB_INSTALL_TIMEOUT 120
ENV PATH=${ANDROID_HOME}/emulator:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools:${PATH}
ENV NODE_OPTIONS --max-old-space-size=4096
ENV CODE_PUSH_NODE_ARGS --max-old-space-size=4096

RUN mkdir ~/.android && echo '### User Sources for Android SDK Manager' > ~/.android/repositories.cfg

RUN yes | ${sdkmanager} --licenses && yes | ${sdkmanager} --update

RUN ${sdkmanager} "tools" "platform-tools" "build-tools;28.0.3"
