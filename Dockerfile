FROM ubuntu:18.04

# Setup

ENV VERSION_SDK_TOOLS=4333796 \
	ANDROID_HOME=/usr/local/android-sdk-linux \
	DEBIAN_FRONTEND=nointeractive

ENV PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools

# Install Android SDK
RUN mkdir -p $ANDROID_HOME && \
    chown -R root.root $ANDROID_HOME && \

    apt update && \

    # Oracle java
    apt install -y software-properties-common --no-install-recommends && \
    add-apt-repository ppa:webupd8team/java -y && \
    apt update -y && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt install -y oracle-java8-installer && \
    apt install -y oracle-java8-set-default && \

    # Other deps
	apt install -y gradle bash curl git openssl openssh-client ca-certificates build-essential && \

	# Android SDK
    wget -q -O sdk.zip http://dl.google.com/android/repository/sdk-tools-linux-$VERSION_SDK_TOOLS.zip && \
    unzip sdk.zip -d $ANDROID_HOME && \
    rm -f sdk.zip && \

    # Clean up
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    apt purge -y --auto-remove software-properties-common && \
    apt autoremove -y && apt-get clean

# Bug with java.se.ee https://stackoverflow.com/questions/46402772/failed-to-install-android-sdk-java-lang-noclassdeffounderror-javax-xml-bind-a
# ENV JAVA_OPTS '-XX:+IgnoreUnrecognizedVMOptions --add-modules java.se.ee'

# Install and update Android packages
# sdkmanager --package_file=$ANDROID_HOME/packages.txt && \  bug https://issuetracker.google.com/issues/66465833  
ADD packages.txt $ANDROID_HOME
RUN mkdir -p /root/.android && \
    touch /root/.android/repositories.cfg && \
    sdkmanager --update && yes | sdkmanager --licenses && \
    while read p; do echo "y" | printf "starting ${p}" && sdkmanager "${p}" > /dev/null && printf "\n"; done < $ANDROID_HOME/packages.txt

WORKDIR /app
