FROM ubuntu:latest

# Get up to date, install the bare necessities
RUN DEBIAN_FRONTEND=noninteractive sh -c '( \
    apt-get install -y -q curl wget vim man-db ssh bash-completion \
    )' > /dev/null

# Create "strongbox" user
RUN useradd -ms /bin/bash strongbox && chown -R strongbox /usr/local

# Let everyone run sudo without a password (dangerous!)
RUN echo "ALL	ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers

# Set up some semblance of an environment
WORKDIR /home/strongbox
ENV HOME /home/strongbox
USER strongbox

# Default to a login shell
CMD ["/bin/bash", "--login"]
