FROM ubuntu:latest

# Get up to date, install the bare necessities
# Create "strongbox" user
# Let everyone run sudo without a password (dangerous!)
RUN DEBIAN_FRONTEND=noninteractive sh -c '( \
        apt-get update -q && \
        apt-get dist-upgrade -y -q && \
        apt-get install -y -q curl wget vim man-db ssh bash-completion && \
        apt-get clean \
    )' > /dev/null && \
    useradd -ms /bin/bash strongbox && \
    chown -R strongbox /usr/local && \
    echo "ALL	ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers

# Set up some semblance of an environment
WORKDIR /home/strongbox
ENV HOME /home/strongbox
USER strongbox

# Default to a login shell
CMD ["/bin/bash", "--login"]
