FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y apt-transport-https
RUN apt-key adv --keyserver keys.gnupg.net --recv-keys 09617FD37CC06B54
RUN echo "deb https://dist.crystal-lang.org/apt crystal main" > /etc/apt/sources.list.d/crystal.list
RUN apt-get update && \
    apt-get -y install \
      crystal \
      make \
      git \
      gcc \
      libxml2-dev \
      zlib1g-dev \
      libssl-dev

ADD . /src

WORKDIR /src

# delete binary if present (it's a darwin one probably)
RUN rm -f crul
