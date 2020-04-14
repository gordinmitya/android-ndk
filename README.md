# Docker Android
## Docker container to build Android app with NDK support.

Image on DockerHub [gordinmitya/android-ndk](https://hub.docker.com/repository/docker/gordinmitya/android-ndk)

There is two possible way to use this image:

> to list packages installed on your machine use `$ANDROID_HOME/tools/bin/sdkmanager --list`

* If all needed sdk packages already in mine `packages.txt`: 

    1. create `Dockerfile` in the project root
    2. put `FROM gordinmitya/android-ndk` to use my prebuilt image
    3. `COPY ./ /app` copy your project files to container

* If you need something different:

    1. copy content of `Dockerfile`
    2. create `packages.txt` with all necessary packages (don't forget to put empty line in the end)
    3. `COPY ./ /app` copy app to container
    4. build an image by yourself
