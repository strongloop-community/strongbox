#!/bin/sh -e

APP_NAME=${APP_NAME:-loopback-example-app}
APP_TGZ=${APP_TGZ:-https://github.com/strongloop/loopback-example-app/archive/master.tar.gz}

# Use strong-pm instance running on localhost
# Note that we are setting this to the default, so the '-C $STRONG_PM' below
# aren't strictly speaking necessary.
STRONG_PM=${STRONG_PM:-http://127.0.0.1:8701}

# Environment variables to set in the $APP_NAME deployment
APP_ENV="NODE_ENV=staging UPSTREAM_SERVER=other-server"

# If $STRONGLOOP_LICENSE is set, add it to the app's environment
if [[ -n "$STRONGLOOP_LICENSE" ]]; then
  APP_ENV="$APP_ENV STRONGLOOP_LICENSE=$STRONGLOOP_LICENSE"
fi

# Verify that strong-pm is running and accessible (don't need sudo)
echo "Ensuring strong-pm is up and running..."
sl-pmctl -C $STRONG_PM info

# Ensure the app is created, then predefine our app's environment before it is
# even deployed.
echo "Preparing strong-pm for $APP_NAME deployment..."
if ! sl-pmctl -C $STRONG_PM ls | grep $APP_NAME; then
  sl-pmctl -C $STRONG_PM create $APP_NAME
fi
sl-pmctl -C $STRONG_PM env-set $APP_NAME $APP_ENV

# If we need to set up any custom firewall policies. Here's an example of how
# one would use iptables to forward port 80 to the port our app is listening
# on (using the strong-pm defined $PORT of 3000 + service id).
echo "Exposing port 3001 as port 80..."
sudo iptables -I INPUT 1 -i eth0 -p tcp --dport 80 -j ACCEPT
sudo iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 3001
sudo /sbin/service iptables save

echo "Fetching $APP_TGZ..."
curl -sL $APP_TGZ > app.tgz

echo "Deploying $APP_NAME..."
sl-deploy -s $APP_NAME $STRONG_PM ./app.tgz

# Note that for the example app we are using, there are a fair number of
# dependencies that need to be downloaded and installed, so it may take longer
# than 10 seconds for the deployment to actually finish.
echo "Sleeping for a bit to let the deployment finish..."
sleep 10

echo "Checking app status..."
sl-pmctl -C $STRONG_PM status
