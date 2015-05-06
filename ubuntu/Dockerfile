FROM ubuntu:latest

# Get up to date, install the bare necessities
RUN DEBIAN_FRONTEND=noninteractive sh -c '( \
        apt-get update && \
        apt-get install -y -q curl wget vim man-db ssh-client bash-completion && \
        apt-get clean && \
        apt-get autoclean \
    )' > /dev/null

# Create "strongbox" user
# Let strongbox run sudo without a password (dangerous!)
RUN useradd -ms /bin/bash strongbox && \
    chown -R strongbox /usr/local && \
    echo "strongbox	ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers

# Set up some semblance of an environment
WORKDIR /home/strongbox
ENV HOME /home/strongbox
USER strongbox

# Default to a login shell
CMD ["/bin/bash", "--login"]
