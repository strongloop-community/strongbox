# strongbox

Linux VMs for testing:

 * ubuntu1204
 * ubuntu1404
 * centos65

Docker images for disposable dev/test environments:

 * strongbox:ubuntu (bare Ubuntu 14.04 + vim, ssh, man pages + user shell)
 * strongbox:node (strongbox:ubuntu + node from tarball)
 * strongbox:dev (strongbox:node + git, compilers)

If you are on a Mac you're using boot2docker for Docker support. You'll find
this useful to put into your `~/.bashrc`:

```sh
for tag in $(docker images | awk '/strongbox/ { print $2 }'); do
    alias strongbox-$tag="boot2docker ssh -t docker run -it -v \\\$SSH_AUTH_SOCK:/ssh-agent -e SSH_AUTH_SOCK=/ssh-agent strongbox:$tag"
done
```

# Usage

 1. Install VirtualBox: https://www.virtualbox.org/wiki/Downloads
 2. Install Vagrant: http://www.vagrantup.com/downloads.html
 3. `git clone git@github.com:strongloop-community/strongbox.git`
 4. `cd strongbox`
 5. `vagrant up <name>`
 6. `vagrant ssh`
 7. Your're in! You've got node, npm, gcc, and vim. The world is your oyster!
