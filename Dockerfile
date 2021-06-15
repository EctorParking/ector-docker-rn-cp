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
    openjdk-8-jre \
    openjdk-8-jdk \
    wget

RUN sudo pip install setuptools awsebcli awscli

# Ngrok

RUN curl -sL https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip > ngrok.zip
RUN unzip ngrok.zip
RUN chmod +x ngrok
RUN sudo cp ngrok /usr/bin

# Node

RUN curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
RUN sudo apt-get install -y nodejs
RUN npm install -g yarn code-push-cli
RUN sudo npm install -g sentry-cli-binary --unsafe-perm=true
RUN node -v
RUN npm -v

# Android SDK

ARG sdk_version=sdk-tools-linux-4333796.zip
ARG android_home=/opt/android/sdk

RUN sudo mkdir -p ${android_home} && \
    wget -O /tmp/${sdk_version} -t 5 "https://dl.google.com/android/repository/${sdk_version}" && \
    unzip -q /tmp/${sdk_version} -d ${android_home} && \
    rm /tmp/${sdk_version}

ENV ANDROID_HOME ${android_home}
ENV ADB_INSTALL_TIMEOUT 120
ENV PATH=${ANDROID_HOME}/emulator:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools:${PATH}
ENV NODE_OPTIONS=${NODE_OPTIONS} --max_old_space_size=4096

RUN mkdir ~/.android && echo '### User Sources for Android SDK Manager' > ~/.android/repositories.cfg

RUN yes | sdkmanager --licenses && yes | sdkmanager --update

RUN sdkmanager "tools" "platform-tools" "build-tools;28.0.3"
