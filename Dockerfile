FROM brimstone/ubuntu:14.04

# Install the packages we need, clean up after them and us
RUN apt-get update \
    && apt-get install -y curl unzip git openssh-server \
    && apt-get clean \
    && rm /etc/ssh/ssh_host_* \
    && rm -rf /var/lib/apt/lists

# Configure a user for git and allow users to login via ssh
RUN useradd git \
    && mkdir /home/git \
    && chown git: /home/git \
    && sed '/pam_loginuid.so/s/^/#/g' -i  /etc/pam.d/*

# Download and install the latest binary release of gogs
RUN curl -L https://github.com/$(\
      curl -s https://github.com/gogits/gogs/releases \
      | grep "linux_amd64.zip" \
      | head -n 1 \
      | sed -e 's/^.*"\///;s/".*//'\
      ) > gogits.zip \
    && unzip gogits.zip \
    && rm gogits.zip \
    && mkdir gogs/data \
    && mkdir gogs/custom \
    && mkdir gogs/log

# Add our deploy script
ADD deploy /deploy

# Expose our port
EXPOSE 22 3000

# Set our command
CMD "/deploy"

# Expose our volume incase something else wants to use it
VOLUME ["/home/git", "/gogs/custom", "/gogs/data"]
