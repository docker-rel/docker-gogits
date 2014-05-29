FROM brimstone/ubuntu:14.04

RUN apt-get update \
    && apt-get install -y curl unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists

RUN curl -LO gogits.zip https://github.com/$(\
      curl -s https://github.com/gogits/gogs/releases \
      | grep "linux_amd64.zip" \
      | head -n 1 \
      | sed -e 's/^.*"\///;s/".*//'\
      ) \
    && unzip gogits.zip


EXPOSE 3000
ENTYRPOINT /gogs/gogs
CMD web
