FROM openjdk:9-jdk

# Setup

ENV VERSION_SDK_TOOLS=4333796 \
	ANDROID_HOME=/usr/local/android-sdk-linux \
	DEBIAN_FRONTEND=nointeractive
ENV ANDROID_NDK=$ANDROID_HOME:ndk-bundle
ENV PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools

RUN apt update && apt install -y --no-install-recommends \
    wget \
    gradle \
    bash \
    curl \
    git \
    openssl \
    openssh-client \
    ca-certificates \
    build-essential && \    
    # Clean up
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    apt autoremove -y && apt-get clean

# Android SDK
RUN mkdir -p $ANDROID_HOME && \
    chown -R root.root $ANDROID_HOME && \
    wget -q -O sdk.zip http://dl.google.com/android/repository/sdk-tools-linux-$VERSION_SDK_TOOLS.zip && \
    unzip sdk.zip -d $ANDROID_HOME && \
    rm -f sdk.zip

# Install and update Android packages
# sdkmanager --package_file=$ANDROID_HOME/packages.txt
# bug https://issuetracker.google.com/issues/66465833  
ADD packages.txt $ANDROID_HOME
ENV SDKMANAGER_OPTS "--add-modules java.se.ee" 
RUN mkdir -p /root/.android && \
    touch /root/.android/repositories.cfg && \
    sdkmanager --update && yes | sdkmanager --licenses && \
    while read p; do echo "y" | printf "starting ${p}" && sdkmanager "${p}" > /dev/null && printf "\n"; done < $ANDROID_HOME/packages.txt

WORKDIR /app
CMD ["/bin/bash"]
