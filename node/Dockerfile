FROM strongloop/strongbox:ubuntu

# Install node & npm
RUN mkdir -p /usr/local/src/node /usr/local/etc \
    && curl -s http://nodejs.org/dist/v0.10.39/node-v0.10.39-linux-x64.tar.gz \
    | tar -C /usr/local --strip-components 1 -xz -f - \
    && curl -s http://nodejs.org/dist/v0.10.39/node-v0.10.39.tar.gz \
    | tar -C /usr/local/src/node --strip-components 1 -xz -f - \
    && echo "nodedir = /usr/local/src/node" > /usr/local/etc/npmrc \
    && npm install -g npm && npm cache clear
