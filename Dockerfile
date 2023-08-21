FROM ubuntu:20.04

# Setup

ENV VERSION_COMMANDLINETOOLS="10406996_latest" \
	ANDROID_HOME=/usr/local/android-sdk-linux \
	DEBIAN_FRONTEND=nointeractive
ENV ANDROID_NDK=$ANDROID_HOME/ndk-bundle
ENV PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools

WORKDIR $ANDROID_HOME

# uses closest mirror
RUN apt update && apt install -y --no-install-recommends \
    wget curl git \
    zip unzip \
    gradle \
    openssl \
    cmake \
    build-essential \
    openjdk-17-jdk && \  
    # Clean up
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    apt autoremove -y && apt clean

ENV JAVA_HOME /usr/lib/jvm/java-17-openjdk-amd64

# Android commandlinetools
RUN mkdir -p $ANDROID_HOME/cmdline-tools/latest && \
    chown -R root.root $ANDROID_HOME && \
    wget -q -O commandlinetools.zip https://dl.google.com/android/repository/commandlinetools-linux-$VERSION_COMMANDLINETOOLS.zip && \
    unzip commandlinetools.zip -d /tmp && \
    mv /tmp/cmdline-tools/* $ANDROID_HOME/cmdline-tools/latest && \
    rm -f commandlinetools.zip

RUN yes | $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager --licenses

# Install and update Android packages
ADD packages.txt $ANDROID_HOME
RUN $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager --package_file=$ANDROID_HOME/packages.txt

WORKDIR /app
CMD ["/bin/bash"]
