#!/bin/sh -e

# default to the latest published versions
PM_VERSION=${PM_VERSION:-latest}
DEPLOY_VERSION=${DEPLOY_VERSION:-latest}

# On RHEL family distributions /usr/local/bin is not part of the "secure path"
# that sudo uses, so we use this little trick to ensure that the $PATH we are
# using as a regular user is used as the $PATH for what we run under sudo.
RHEL_SUDO="sudo env PATH=$PATH"

echo "Installing strong-pm from $(npm config get registry)..."
npm install -g strong-pm@$PM_VERSION

echo "Installing strong-deploy from $(npm config get registry)..."
npm install -g strong-deploy@$DEPLOY_VERSION

echo "Installing strong-pm as Upstart job..."
# RHEL 6 uses Upstart 0.6, not 1.4+ like Ubuntu or systemd like RHEL 7
# Creates a strong-pm user and a strong-pm Upstart job. Output from strong-pm
# and any apps deployed to it is sent to syslog under the name 'strong-pm'
# If a custom registry has been defined in the global npmrc, it would be used
# by the strong-pm user. Similarly for any custom nodedir config.
$RHEL_SUDO sl-pm-install --upstart=0.6 --force

# start PM service
sudo start strong-pm

echo "strong-pm and strong-deploy installed"
sl-pm --version
sl-deploy --version

echo "strong-pm started"
sudo status strong-pm
