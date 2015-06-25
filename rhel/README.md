# Enterprise Linux Example

This is a set of shell scripts that demonstrate a simple strong-pm deployment
on a RHEL/CentOS 6.6 VM.

The deployment is split into three phases:
 1. installing node and npm
 2. installing strong-pm and strong-deploy
 3. deploying our app

The scripts are all run without `root` privileges, though they are run as a user
that has `sudo` privileges. This allows a clear demonstration of what does and
does not require `root` access.

### Installing Node and npm
File: [nodejs-install.sh](./nodejs-install.sh).

The first phase installs node and npm from the binaries published on nodejs.org.
The example script installs them to `/usr/local/bin/node` and
`/usr/local/bin/npm`, respectively, but makes use of environment variables to
show how they could be installed to alternate locations, such as `/opt/node`.

A special feature of this example is the use of the `nodedir` config in the
global `npmrc` file and the pre-downloaded copy of the node source code. This
allows `node-gyp` to build binary add-ons _without_ having to download the node
source code upon its first invocation.

The global `npmrc` is also used to, optionally, override the npm registry that
is used and apply that change system wide.

The global module paths (`/usr/local/bin` and `/usr/local/lib/node_modules`) are
also `chown`ed to the deploying user so that `sudo` is not needed later when
installing modules globally.

**Note:** this does _not_ grant this privilege to all users, so it does not
allow the strong-pm user or any apps deployed under it to install modules
globally.

This phase also ensure that the proper development tools (g++, make, etc.) are
installed so that binary add-ons can be installed.

### Installing strong-pm and strong-deploy
File: [strongloop-install.sh](./strongloop-install.sh)

The second phase installs [strong-pm](https://github.com/strongloop/strong-pm)
and [strong-deploy](https://github.com/strongloop/strong-deploy) globally and
then installs strong-pm as a system service.

The script demonstrates that root privileges are not required if the current
user has write access to the location where global modules are installed. It
also provides an example of how to work around RHEL not including
`/usr/local/bin` in the `sudo` secure path by using `sudo env "PATH=$PATH" ...`.

### Installing/Deploying an Application
File: [app-install.sh](./app-insta.sh)

The third and final deployment phase of this example downloads a tarball of an
example app and deploys it to the locally installed and running strong-pm
instance.

The example tarball is the GitHub provided source code snapshot from
[loopback-example-app](https://github.com/strongloop/loopback-example-app),
which is structured similarly enough to an `npm pack` or `slc build` generated
tarball that it can be deployed.

As part of the deployment, the script demonstrates how to check for whether an
app has been defined and how to create it if necessary. Additionally, we see
that the app's environment can be defined _before_ it is deployed, which can
save the initial deployment from failing to start due to missing environment
details such as database credentials or license keys.

This script also shows how to expose an app running without root privileges can
be exposed on port 80 without using a proxy server. This is done by using
`iptables` to forward port 80 to port 3001, which is the port that strong-pm
assigns to service 1 (the first one created).

---
&copy; 2015 StrongLoop, Inc.
