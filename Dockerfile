# This is the base vscode image for the software development of a git
# repository at [1]. This shall allow us to run a vscode-server backend
# for the Remote Code Tunnnels feature of vscode.
#
# 1. github.com:haxxin/win64_docker-examples.git
#

# TODO(JEFF): Review whether or not we may size this image down further; I
# believe that debian:12.10-slim could be used, but this needs testing.
# https://hub.docker.com/_/debian/tags?name=12.10
FROM debian:12.10
LABEL maintainer="Jeffrey Carpenter <1329364+i8degrees@users.noreply.github.com>"

# FIXME(JEFF): Allow the end-user to choose what unprivileged user ID to use
# in building this image.
#ENV 
#USERID=code

USER root
WORKDIR /root

# NOTE(JEFF): Any conveniences we wish to have within the container's shell
# should be handled here if we wish for it to be permanent.
COPY --chmod=+x --chown=root:root \
  ./build.sh /build.sh
COPY --chmod=+x --chown=root:root \
  ./run.sh /run.sh
#COPY --chown=root:root bashrc ./.bashrc
#COPY --chown=root:root bash_profile ./.bash_profile
#COPY --chown=root:root bash_aliases ./.bash_aliases
#COPY --chown=root:root inputrc ./.inputrc

# NOTE(JEFF): I have separated the distribution build sections as its own
# shell script for the sake of a bit less struggle for me with debugging
# issues with this step.
RUN echo "INFO: Executing /build.sh..." && \
  sh -c '/build.sh'

# NOTE(JEFF): create "code" user
RUN echo "INFO: Adding unprivileged user 'code:src' to container..." && \
  useradd -m -s /bin/bash -G src code
#adduser -S -D -G src vscode

#EXPOSE 8000/tcp

# NOTE(JEFF): This is insecure and should never be used
#USER root
#WORKDIR /root
#ENTRYPOINT ["/usr/bin/code", "server", "--no-sandbox" ]

USER code
WORKDIR /home/code
ENTRYPOINT ["/run.sh", "code" ]

