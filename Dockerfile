FROM brimstone/ubuntu:14.04

RUN apt-get update \
    && apt-get install -y curl unzip git openssh-server \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists

RUN useradd git \
    && mkdir /home/git \
    && chown git: /home/git

RUN curl -L https://github.com/$(\
      curl -s https://github.com/gogits/gogs/releases \
      | grep "linux_amd64.zip" \
      | head -n 1 \
      | sed -e 's/^.*"\///;s/".*//'\
      ) > gogits.zip \
    && unzip gogits.zip \
    && rm gogits.zip \
    && mkdir gogs/data \
    && chown git: gogs/data \
    && mkdir gogs/custom \
    && chown git: gogs/custom \
    && mkdir gogs/log \
    && chown git: gogs/log


EXPOSE 3000

USER git
ENV HOME /home/git
ENV USER git
WORKDIR /gogs
ENTRYPOINT ["./gogs", "web"]
CMD []
