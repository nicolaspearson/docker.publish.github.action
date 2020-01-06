# ------------------------------------------------------
#                       Dockerfile
# ------------------------------------------------------
# image:    docker.publish.github.action
# name:     nicolaspearson/docker.publish.github.action/docker.publish.github.action:master
# repo:     https://github.com/nicolaspearson/docker.publish.github.action
# requires: docker:19.03
# authors:  Nicolas Pearson
# ------------------------------------------------------

FROM docker:19.03 as runtime

LABEL "repository"="https://github.com/nicolaspearson/docker.publish.github.action"
LABEL "maintainer"="Nicolas Pearson"

RUN apk update \
  && apk upgrade \
  && apk add --no-cache git

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

FROM runtime as testEnv
RUN apk add --no-cache coreutils bats ncurses
ADD test.bats /test.bats
ADD mock.sh /usr/local/bin/docker
ADD mock.sh /usr/bin/date
RUN /test.bats

FROM runtime
