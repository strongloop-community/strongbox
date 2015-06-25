#!/bin/sh -e

###
### Config
###

# /usr/local is a pretty typical choice for binaries that were not installed
# using the OS's own package manager (yum, apt-get, etc.).
# Another reasonable choice would be /opt/node or similar, but such locations
# lack the convenience of /usr/local/bin being in the default $PATH
NODE_PREFIX=${NODE_PREFIX:-/usr/local}

# If you have a restricted network you would probably mirror these URLs on a
# local repository like Artifactory or Nexus or even just a plain http server.
NODE_BIN=${NODE_BIN:-http://nodejs.org/dist/v0.10.39/node-v0.10.39-linux-x64.tar.gz}
NODE_SRC=${NODE_SRC:-http://nodejs.org/dist/v0.10.39/node-v0.10.39.tar.gz}

# Place holder for if we want to use a local/private npm registry instead of
# the default public registry.
#NPM_REGISTRY = https://registry.npmjs.org/

# User to own $NODE_PREFIX/bin and $NODE_PREFIX/lib/node_modules so that it can
# install modules globally without requiring root.
NPM_USER=$(whoami)

###
### Make it so!
###

echo "Installing node and npm in $NODE_PREFIX from $NODE_BIN"
# Installs node, npm, man pages, and some release header files
curl -sL $NODE_BIN | sudo tar -C $NODE_PREFIX --strip-components 1 -xzf - '*/*/*'

echo "Granting user $NPM_USER write access to npm modules..."
sudo mkdir -p $NODE_PREFIX/src/node $(npm config get prefix)/etc
sudo touch $(npm config get globalconfig)
sudo chown -R $NPM_USER $NODE_PREFIX/bin \
              $NODE_PREFIX/lib/node_modules \
              $(npm config get globalconfig)

echo "Installing node source code to $NODE_PREFIX/src/node for use by node-gyp"
curl -sL $NODE_SRC | sudo tar -C $NODE_PREFIX/src/node --strip-components 1 -xzf -

echo "Configuring npm to use local node source code for node-gyp"
# "../etc/npmrc" relative to the npm binary is the location of the "global"
# npmrc that is used by all users. The values override the defaults, but can be
# overriden by values in a user's own ~/.npmrc file.

# The nodedir config value points to the source you built node from so that
# node-gyp doesn't try to download the source. This is normally used by devs
# because the node-gyp version detection doesn't handle non-release version
# numbers, but it is also very handy for offline scenarios.
echo "nodedir = /usr/local/src/node" >> $(npm config get globalconfig)

# If a private npm registry is being used, make it the global default
if [[ -n "$NPM_REGISTRY" ]]; then
  echo "registry = $NPM_REGISTRY" >> $(npm config get globalconfig)
fi

echo "Installing development tools necessary for building binary addons..."
# minimal install:
sudo yum -y -q install gcc-c++ make
# # full install:
# sudo yum -y -q groupinstall "Development Tools"

echo "Node and npm successfully installed:"
node --version
npm --version
